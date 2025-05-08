import 'package:peer_connects/features/gamification/domain/entities/achievement_entity.dart';
import 'package:peer_connects/features/gamification/domain/entities/user_progress_entity.dart';
import 'package:peer_connects/features/gamification/domain/repositories/gamification_repository.dart';

/// Use case for managing user progress in the gamification system
class ManageUserProgress {
  final GamificationRepository repository;

  ManageUserProgress(this.repository);

  /// Get user's gamification progress
  Future<UserProgressEntity> getUserProgress(String userId) async {
    return await repository.getUserProgress(userId);
  }
  
  /// Update user's points
  Future<void> updatePoints(String userId, int points) async {
    await repository.updateUserPoints(userId, points);
  }
  
  /// Unlock an achievement for a user
  Future<void> unlockAchievement(String userId, String achievementId) async {
    await repository.unlockAchievement(userId, achievementId);
  }
  
  /// Check if a user has unlocked a specific achievement
  Future<bool> hasUnlockedAchievement(String userId, String achievementId) async {
    return await repository.hasUnlockedAchievement(userId, achievementId);
  }
  
  /// Check and update achievements based on user activity
  Future<List<AchievementEntity>> checkAndUpdateAchievements(
    String userId, 
    Map<String, dynamic> activityData
  ) async {
    return await repository.checkAndUpdateAchievements(userId, activityData);
  }
  
  /// Get global leaderboard
  Future<List<Map<String, dynamic>>> getGlobalLeaderboard({int limit = 10}) async {
    return await repository.getGlobalLeaderboard(limit: limit);
  }
}