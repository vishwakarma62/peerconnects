import 'package:peer_connects/features/gamification/data/models/achievement_model.dart';
import 'package:peer_connects/features/gamification/data/models/challenge_model.dart';
import 'package:peer_connects/features/gamification/data/models/user_progress_model.dart';
import 'package:peer_connects/features/gamification/domain/entities/achievement_entity.dart';

/// Data source interface for gamification features
abstract class GamificationDataSource {
  /// Get all available achievements
  Future<List<AchievementModel>> getAchievements();
  
  /// Get a specific achievement by ID
  Future<AchievementModel> getAchievementById(String id);
  
  /// Get achievements by category
  Future<List<AchievementModel>> getAchievementsByCategory(AchievementCategory category);
  
  /// Get user's unlocked achievements
  Future<List<AchievementModel>> getUserAchievements(String userId);
  
  /// Unlock an achievement for a user
  Future<void> unlockAchievement(String userId, String achievementId);
  
  /// Check if a user has unlocked a specific achievement
  Future<bool> hasUnlockedAchievement(String userId, String achievementId);
  
  /// Get all active challenges
  Future<List<ChallengeModel>> getActiveChallenges();
  
  /// Get all upcoming challenges
  Future<List<ChallengeModel>> getUpcomingChallenges();
  
  /// Get all completed challenges for a user
  Future<List<ChallengeModel>> getUserCompletedChallenges(String userId);
  
  /// Get a specific challenge by ID
  Future<ChallengeModel> getChallengeById(String id);
  
  /// Join a challenge
  Future<void> joinChallenge(String userId, String challengeId);
  
  /// Leave a challenge
  Future<void> leaveChallenge(String userId, String challengeId);
  
  /// Update progress for a challenge
  Future<void> updateChallengeProgress(String userId, String challengeId, double progress);
  
  /// Complete a challenge
  Future<void> completeChallenge(String userId, String challengeId);
  
  /// Create a new challenge
  Future<String> createChallenge(ChallengeModel challenge);
  
  /// Get user's gamification progress
  Future<UserProgressModel> getUserProgress(String userId);
  
  /// Update user's points
  Future<void> updateUserPoints(String userId, int points);
  
  /// Get leaderboard for a specific challenge
  Future<List<Map<String, dynamic>>> getChallengeLeaderboard(String challengeId);
  
  /// Get global leaderboard (based on total points)
  Future<List<Map<String, dynamic>>> getGlobalLeaderboard({int limit = 10});
  
  /// Check and update achievements based on user activity
  Future<List<AchievementModel>> checkAndUpdateAchievements(
    String userId, 
    Map<String, dynamic> activityData
  );
}