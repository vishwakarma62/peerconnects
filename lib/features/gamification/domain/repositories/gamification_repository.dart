import 'package:peer_connects/features/gamification/domain/entities/achievement_entity.dart';
import 'package:peer_connects/features/gamification/domain/entities/challenge_entity.dart';
import 'package:peer_connects/features/gamification/domain/entities/user_progress_entity.dart';

/// Repository interface for gamification features
abstract class GamificationRepository {
  /// Get all available achievements
  Future<List<AchievementEntity>> getAchievements();
  
  /// Get a specific achievement by ID
  Future<AchievementEntity> getAchievementById(String id);
  
  /// Get achievements by category
  Future<List<AchievementEntity>> getAchievementsByCategory(AchievementCategory category);
  
  /// Get user's unlocked achievements
  Future<List<AchievementEntity>> getUserAchievements(String userId);
  
  /// Unlock an achievement for a user
  Future<void> unlockAchievement(String userId, String achievementId);
  
  /// Check if a user has unlocked a specific achievement
  Future<bool> hasUnlockedAchievement(String userId, String achievementId);
  
  /// Get all active challenges
  Future<List<ChallengeEntity>> getActiveChallenges();
  
  /// Get all upcoming challenges
  Future<List<ChallengeEntity>> getUpcomingChallenges();
  
  /// Get all completed challenges for a user
  Future<List<ChallengeEntity>> getUserCompletedChallenges(String userId);
  
  /// Get a specific challenge by ID
  Future<ChallengeEntity> getChallengeById(String id);
  
  /// Join a challenge
  Future<void> joinChallenge(String userId, String challengeId);
  
  /// Leave a challenge
  Future<void> leaveChallenge(String userId, String challengeId);
  
  /// Update progress for a challenge
  Future<void> updateChallengeProgress(String userId, String challengeId, double progress);
  
  /// Complete a challenge
  Future<void> completeChallenge(String userId, String challengeId);
  
  /// Create a new challenge (for community or group challenges)
  Future<String> createChallenge(ChallengeEntity challenge);
  
  /// Get user's gamification progress
  Future<UserProgressEntity> getUserProgress(String userId);
  
  /// Update user's points
  Future<void> updateUserPoints(String userId, int points);
  
  /// Get leaderboard for a specific challenge
  Future<List<Map<String, dynamic>>> getChallengeLeaderboard(String challengeId);
  
  /// Get global leaderboard (based on total points)
  Future<List<Map<String, dynamic>>> getGlobalLeaderboard({int limit = 10});
  
  /// Check and update achievements based on user activity
  /// This should be called after significant user actions (completing walks, etc.)
  Future<List<AchievementEntity>> checkAndUpdateAchievements(String userId, Map<String, dynamic> activityData);
}