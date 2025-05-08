import 'package:peer_connects/features/gamification/domain/entities/challenge_entity.dart';
import 'package:peer_connects/features/gamification/domain/repositories/gamification_repository.dart';

/// Use case for managing challenges
class ManageChallenges {
  final GamificationRepository repository;

  ManageChallenges(this.repository);

  /// Join a challenge
  Future<void> join(String userId, String challengeId) async {
    await repository.joinChallenge(userId, challengeId);
  }
  
  /// Leave a challenge
  Future<void> leave(String userId, String challengeId) async {
    await repository.leaveChallenge(userId, challengeId);
  }
  
  /// Update progress for a challenge
  Future<void> updateProgress(String userId, String challengeId, double progress) async {
    await repository.updateChallengeProgress(userId, challengeId, progress);
  }
  
  /// Complete a challenge
  Future<void> complete(String userId, String challengeId) async {
    await repository.completeChallenge(userId, challengeId);
  }
  
  /// Create a new challenge
  Future<String> create(ChallengeEntity challenge) async {
    return await repository.createChallenge(challenge);
  }
  
  /// Get leaderboard for a specific challenge
  Future<List<Map<String, dynamic>>> getLeaderboard(String challengeId) async {
    return await repository.getChallengeLeaderboard(challengeId);
  }
}