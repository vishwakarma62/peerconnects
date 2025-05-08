import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peer_connects/features/gamification/data/datasources/gamification_datasource.dart';
import 'package:peer_connects/features/gamification/data/models/achievement_model.dart';
import 'package:peer_connects/features/gamification/data/models/challenge_model.dart';
import 'package:peer_connects/features/gamification/data/models/user_progress_model.dart';
import 'package:peer_connects/features/gamification/domain/entities/achievement_entity.dart';

/// Firebase implementation of the GamificationDataSource
class FirebaseGamificationDataSource implements GamificationDataSource {
  final FirebaseFirestore _firestore;

  FirebaseGamificationDataSource({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  // Collection references
  CollectionReference get _achievementsCollection => 
      _firestore.collection('achievements');
  
  CollectionReference get _challengesCollection => 
      _firestore.collection('challenges');
  
  CollectionReference get _userProgressCollection => 
      _firestore.collection('user_progress');
  
  CollectionReference get _userAchievementsCollection => 
      _firestore.collection('user_achievements');
  
  CollectionReference get _userChallengesCollection => 
      _firestore.collection('user_challenges');

  @override
  Future<List<AchievementModel>> getAchievements() async {
    final snapshot = await _achievementsCollection.get();
    return snapshot.docs
        .map((doc) => AchievementModel.fromJson({
              'id': doc.id,
              ...doc.data() as Map<String, dynamic>,
            }))
        .toList();
  }

  @override
  Future<AchievementModel> getAchievementById(String id) async {
    final doc = await _achievementsCollection.doc(id).get();
    if (!doc.exists) {
      throw Exception('Achievement not found');
    }
    return AchievementModel.fromJson({
      'id': doc.id,
      ...doc.data() as Map<String, dynamic>,
    });
  }

  @override
  Future<List<AchievementModel>> getAchievementsByCategory(
      AchievementCategory category) async {
    final categoryString = category.toString().split('.').last;
    final snapshot = await _achievementsCollection
        .where('category', isEqualTo: categoryString)
        .get();
    
    return snapshot.docs
        .map((doc) => AchievementModel.fromJson({
              'id': doc.id,
              ...doc.data() as Map<String, dynamic>,
            }))
        .toList();
  }

  @override
  Future<List<AchievementModel>> getUserAchievements(String userId) async {
    final snapshot = await _userAchievementsCollection
        .where('userId', isEqualTo: userId)
        .get();
    
    final achievementIds = snapshot.docs
        .map((doc) => (doc.data() as Map<String, dynamic>)['achievementId'] as String)
        .toList();
    
    if (achievementIds.isEmpty) {
      return [];
    }
    
    // Get achievement details for each ID
    final achievements = <AchievementModel>[];
    for (final id in achievementIds) {
      try {
        final achievement = await getAchievementById(id);
        // Add unlocked timestamp
        final userAchievement = snapshot.docs.firstWhere(
          (doc) => (doc.data() as Map<String, dynamic>)['achievementId'] == id
        );
        final unlockedAt = (userAchievement.data() as Map<String, dynamic>)['unlockedAt'];
        
        achievements.add(achievement.copyWith(
          unlockedAt: unlockedAt != null ? (unlockedAt as Timestamp).toDate() : null,
        ) as AchievementModel);
      } catch (e) {
        // Skip if achievement not found
        continue;
      }
    }
    
    return achievements;
  }

  @override
  Future<void> unlockAchievement(String userId, String achievementId) async {
    // Check if already unlocked
    final existingDoc = await _userAchievementsCollection
        .where('userId', isEqualTo: userId)
        .where('achievementId', isEqualTo: achievementId)
        .get();
    
    if (existingDoc.docs.isNotEmpty) {
      // Already unlocked
      return;
    }
    
    // Get achievement details to add points
    final achievement = await getAchievementById(achievementId);
    
    // Add to user achievements
    await _userAchievementsCollection.add({
      'userId': userId,
      'achievementId': achievementId,
      'unlockedAt': FieldValue.serverTimestamp(),
    });
    
    // Update user progress with points
    await updateUserPoints(userId, achievement.pointsValue);
  }

  @override
  Future<bool> hasUnlockedAchievement(String userId, String achievementId) async {
    final snapshot = await _userAchievementsCollection
        .where('userId', isEqualTo: userId)
        .where('achievementId', isEqualTo: achievementId)
        .get();
    
    return snapshot.docs.isNotEmpty;
  }

  @override
  Future<List<ChallengeModel>> getActiveChallenges() async {
    final now = DateTime.now();
    final snapshot = await _challengesCollection
        .where('startDate', isLessThanOrEqualTo: now)
        .where('endDate', isGreaterThanOrEqualTo: now)
        .where('status', isEqualTo: 'active')
        .get();
    
    return snapshot.docs
        .map((doc) => ChallengeModel.fromJson({
              'id': doc.id,
              ...doc.data() as Map<String, dynamic>,
            }))
        .toList();
  }

  @override
  Future<List<ChallengeModel>> getUpcomingChallenges() async {
    final now = DateTime.now();
    final snapshot = await _challengesCollection
        .where('startDate', isGreaterThan: now)
        .where('status', isEqualTo: 'upcoming')
        .get();
    
    return snapshot.docs
        .map((doc) => ChallengeModel.fromJson({
              'id': doc.id,
              ...doc.data() as Map<String, dynamic>,
            }))
        .toList();
  }

  @override
  Future<List<ChallengeModel>> getUserCompletedChallenges(String userId) async {
    final snapshot = await _userChallengesCollection
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: 'completed')
        .get();
    
    final challengeIds = snapshot.docs
        .map((doc) => (doc.data() as Map<String, dynamic>)['challengeId'] as String)
        .toList();
    
    if (challengeIds.isEmpty) {
      return [];
    }
    
    // Get challenge details for each ID
    final challenges = <ChallengeModel>[];
    for (final id in challengeIds) {
      try {
        final challenge = await getChallengeById(id);
        challenges.add(challenge);
      } catch (e) {
        // Skip if challenge not found
        continue;
      }
    }
    
    return challenges;
  }

  @override
  Future<ChallengeModel> getChallengeById(String id) async {
    final doc = await _challengesCollection.doc(id).get();
    if (!doc.exists) {
      throw Exception('Challenge not found');
    }
    return ChallengeModel.fromJson({
      'id': doc.id,
      ...doc.data() as Map<String, dynamic>,
    });
  }

  @override
  Future<void> joinChallenge(String userId, String challengeId) async {
    // Check if already joined
    final existingDoc = await _userChallengesCollection
        .where('userId', isEqualTo: userId)
        .where('challengeId', isEqualTo: challengeId)
        .get();
    
    if (existingDoc.docs.isNotEmpty) {
      // Already joined
      return;
    }
    
    // Add to user challenges
    await _userChallengesCollection.add({
      'userId': userId,
      'challengeId': challengeId,
      'joinedAt': FieldValue.serverTimestamp(),
      'status': 'active',
      'progress': 0.0,
    });
    
    // Update challenge participants
    await _challengesCollection.doc(challengeId).update({
      'participants': FieldValue.arrayUnion([userId]),
    });
    
    // Update user progress
    final userProgress = await getUserProgress(userId);
    await _userProgressCollection.doc(userId).set(
      userProgress.addActiveChallenge(challengeId).toJson(),
      SetOptions(merge: true),
    );
  }

  @override
  Future<void> leaveChallenge(String userId, String challengeId) async {
    // Find user challenge document
    final snapshot = await _userChallengesCollection
        .where('userId', isEqualTo: userId)
        .where('challengeId', isEqualTo: challengeId)
        .get();
    
    if (snapshot.docs.isEmpty) {
      // Not joined
      return;
    }
    
    // Delete user challenge
    for (final doc in snapshot.docs) {
      await doc.reference.delete();
    }
    
    // Update challenge participants
    await _challengesCollection.doc(challengeId).update({
      'participants': FieldValue.arrayRemove([userId]),
    });
    
    // Update user progress
    final userProgress = await getUserProgress(userId);
    final newActiveChallenges = [...userProgress.activeChallenges];
    newActiveChallenges.remove(challengeId);
    
    await _userProgressCollection.doc(userId).update({
      'activeChallenges': newActiveChallenges,
    });
  }

  @override
  Future<void> updateChallengeProgress(
      String userId, String challengeId, double progress) async {
    // Find user challenge document
    final snapshot = await _userChallengesCollection
        .where('userId', isEqualTo: userId)
        .where('challengeId', isEqualTo: challengeId)
        .get();
    
    if (snapshot.docs.isEmpty) {
      // Not joined
      return;
    }
    
    // Update progress
    for (final doc in snapshot.docs) {
      await doc.reference.update({
        'progress': progress,
      });
    }
    
    // Update user progress
    final userProgress = await getUserProgress(userId);
    await _userProgressCollection.doc(userId).update({
      'challengeProgress': {
        ...userProgress.challengeProgress,
        challengeId: progress,
      },
    });
    
    // Check if challenge is completed
    if (progress >= 1.0) {
      await completeChallenge(userId, challengeId);
    }
  }

  @override
  Future<void> completeChallenge(String userId, String challengeId) async {
    // Find user challenge document
    final snapshot = await _userChallengesCollection
        .where('userId', isEqualTo: userId)
        .where('challengeId', isEqualTo: challengeId)
        .get();
    
    if (snapshot.docs.isEmpty) {
      // Not joined
      return;
    }
    
    // Update status to completed
    for (final doc in snapshot.docs) {
      await doc.reference.update({
        'status': 'completed',
        'completedAt': FieldValue.serverTimestamp(),
      });
    }
    
    // Get challenge to award points
    final challenge = await getChallengeById(challengeId);
    
    // Update user progress
    final userProgress = await getUserProgress(userId);
    await _userProgressCollection.doc(userId).set(
      userProgress.completeChallenge(challengeId).toJson(),
      SetOptions(merge: true),
    );
    
    // Award points
    await updateUserPoints(userId, challenge.pointsReward);
  }

  @override
  Future<String> createChallenge(ChallengeModel challenge) async {
    final docRef = await _challengesCollection.add(challenge.toJson());
    return docRef.id;
  }

  @override
  Future<UserProgressModel> getUserProgress(String userId) async {
    final doc = await _userProgressCollection.doc(userId).get();
    
    if (!doc.exists) {
      // Create new progress document if it doesn't exist
      final newProgress = UserProgressModel(userId: userId);
      await _userProgressCollection.doc(userId).set(newProgress.toJson());
      return newProgress;
    }
    
    return UserProgressModel.fromJson({
      'userId': userId,
      ...doc.data() as Map<String, dynamic>,
    });
  }

  @override
  Future<void> updateUserPoints(String userId, int points) async {
    final userProgress = await getUserProgress(userId);
    final updatedProgress = userProgress.addPoints(points);
    
    await _userProgressCollection.doc(userId).set(
      updatedProgress.toJson(),
      SetOptions(merge: true),
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getChallengeLeaderboard(String challengeId) async {
    final snapshot = await _userChallengesCollection
        .where('challengeId', isEqualTo: challengeId)
        .orderBy('progress', descending: true)
        .limit(20)
        .get();
    
    final leaderboard = <Map<String, dynamic>>[];
    
    for (final doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final userId = data['userId'] as String;
      
      // Get user details (in a real app, you'd have a user repository)
      // This is simplified for the example
      leaderboard.add({
        'userId': userId,
        'progress': data['progress'] ?? 0.0,
        'rank': leaderboard.length + 1,
      });
    }
    
    return leaderboard;
  }

  @override
  Future<List<Map<String, dynamic>>> getGlobalLeaderboard({int limit = 10}) async {
    final snapshot = await _userProgressCollection
        .orderBy('totalPoints', descending: true)
        .limit(limit)
        .get();
    
    final leaderboard = <Map<String, dynamic>>[];
    
    for (final doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final userId = doc.id;
      
      // Get user details (in a real app, you'd have a user repository)
      // This is simplified for the example
      leaderboard.add({
        'userId': userId,
        'totalPoints': data['totalPoints'] ?? 0,
        'level': data['level'] ?? 1,
        'rank': leaderboard.length + 1,
      });
    }
    
    return leaderboard;
  }

  @override
  Future<List<AchievementModel>> checkAndUpdateAchievements(
      String userId, Map<String, dynamic> activityData) async {
    // Get all achievements
    final achievements = await getAchievements();
    
    // Get user's unlocked achievements
    final userAchievements = await getUserAchievements(userId);
    final unlockedIds = userAchievements.map((a) => a.id).toList();
    
    // Filter out already unlocked achievements
    final availableAchievements = achievements
        .where((a) => !unlockedIds.contains(a.id))
        .toList();
    
    // Check each achievement criteria against activity data
    final newlyUnlocked = <AchievementModel>[];
    
    for (final achievement in availableAchievements) {
      final criteria = achievement.criteria;
      bool isUnlocked = true;
      
      // Check each criterion
      for (final entry in criteria.entries) {
        final key = entry.key;
        final requiredValue = entry.value;
        
        if (!activityData.containsKey(key) || 
            activityData[key] < requiredValue) {
          isUnlocked = false;
          break;
        }
      }
      
      if (isUnlocked) {
        // Unlock the achievement
        await unlockAchievement(userId, achievement.id);
        newlyUnlocked.add(achievement);
      }
    }
    
    return newlyUnlocked;
  }
}