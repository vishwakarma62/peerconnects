import 'package:peer_connects/features/gamification/domain/entities/achievement_entity.dart';
import 'package:peer_connects/features/gamification/domain/repositories/gamification_repository.dart';

/// Use case for getting all available achievements
class GetAchievements {
  final GamificationRepository repository;

  GetAchievements(this.repository);

  /// Get all achievements
  Future<List<AchievementEntity>> call() async {
    return await repository.getAchievements();
  }
  
  /// Get achievements by category
  Future<List<AchievementEntity>> byCategory(AchievementCategory category) async {
    return await repository.getAchievementsByCategory(category);
  }
  
  /// Get user's unlocked achievements
  Future<List<AchievementEntity>> forUser(String userId) async {
    return await repository.getUserAchievements(userId);
  }
}