import 'package:peer_connects/features/gamification/data/datasources/gamification_datasource.dart';
import 'package:peer_connects/features/gamification/data/models/achievement_model.dart';
import 'package:peer_connects/features/gamification/data/models/challenge_model.dart';
import 'package:peer_connects/features/gamification/domain/entities/achievement_entity.dart';
import 'package:peer_connects/features/gamification/domain/entities/challenge_entity.dart';
import 'package:peer_connects/features/gamification/domain/entities/user_progress_entity.dart';
import 'package:peer_connects/features/gamification/domain/repositories/gamification_repository.dart';

/// Implementation of the GamificationRepository
class GamificationRepositoryImpl implements GamificationRepository {
  final GamificationDataSource _dataSource;

  GamificationRepositoryImpl(this._dataSource);

  @override
  Future<List<AchievementEntity>> getAchievements() async {
    return await _dataSource.getAchievements();
  }

  @override
  Future<AchievementEntity> getAchievementById(String id) async {
    return await _dataSource.getAchievementById(id);
  }

  @override
  Future<List<AchievementEntity>> getAchievementsByCategory(
      AchievementCategory category) async {
    return await _dataSource.getAchievementsByCategory(category);
  }

  @override
  Future<List<AchievementEntity>> getUserAchievements(String userId) async {
    return await _dataSource.getUserAchievements(userId);
  }

  @override
  Future<void> unlockAchievement(String userId, String achievementId) async {
    await _dataSource.unlockAchievement(userId, achievementId);
  }

  @override
  Future<bool> hasUnlockedAchievement(String userId, String achievementId) async {
    return await _dataSource.hasUnlockedAchievement(userId, achievementId);
  }

  @override
  Future<List<ChallengeEntity>> getActiveChallenges() async {
    return await _dataSource.getActiveChallenges();
  }

  @override
  Future<List<ChallengeEntity>> getUpcomingChallenges() async {
    return await _dataSource.getUpcomingChallenges();
  }

  @override
  Future<List<ChallengeEntity>> getUserCompletedChallenges(String userId) async {
    return await _dataSource.getUserCompletedChallenges(userId);
  }

  @override
  Future<ChallengeEntity> getChallengeById(String id) async {
    return await _dataSource.getChallengeById(id);
  }

  @override
  Future<void> joinChallenge(String userId, String challengeId) async {
    await _dataSource.joinChallenge(userId, challengeId);
  }

  @override
  Future<void> leaveChallenge(String userId, String challengeId) async {
    await _dataSource.leaveChallenge(userId, challengeId);
  }

  @override
  Future<void> updateChallengeProgress(
      String userId, String challengeId, double progress) async {
    await _dataSource.updateChallengeProgress(userId, challengeId, progress);
  }

  @override
  Future<void> completeChallenge(String userId, String challengeId) async {
    await _dataSource.completeChallenge(userId, challengeId);
  }

  @override
  Future<String> createChallenge(ChallengeEntity challenge) async {
    return await _dataSource.createChallenge(
        ChallengeModel.fromEntity(challenge));
  }

  @override
  Future<UserProgressEntity> getUserProgress(String userId) async {
    return await _dataSource.getUserProgress(userId);
  }

  @override
  Future<void> updateUserPoints(String userId, int points) async {
    await _dataSource.updateUserPoints(userId, points);
  }

  @override
  Future<List<Map<String, dynamic>>> getChallengeLeaderboard(
      String challengeId) async {
    return await _dataSource.getChallengeLeaderboard(challengeId);
  }

  @override
  Future<List<Map<String, dynamic>>> getGlobalLeaderboard({int limit = 10}) async {
    return await _dataSource.getGlobalLeaderboard(limit: limit);
  }

  @override
  Future<List<AchievementEntity>> checkAndUpdateAchievements(
      String userId, Map<String, dynamic> activityData) async {
    return await _dataSource.checkAndUpdateAchievements(userId, activityData);
  }
}