import 'package:peer_connects/features/gamification/domain/entities/challenge_entity.dart';
import 'package:peer_connects/features/gamification/domain/repositories/gamification_repository.dart';

/// Use case for getting challenges
class GetChallenges {
  final GamificationRepository repository;

  GetChallenges(this.repository);

  /// Get active challenges
  Future<List<ChallengeEntity>> active() async {
    return await repository.getActiveChallenges();
  }
  
  /// Get upcoming challenges
  Future<List<ChallengeEntity>> upcoming() async {
    return await repository.getUpcomingChallenges();
  }
  
  /// Get completed challenges for a user
  Future<List<ChallengeEntity>> completed(String userId) async {
    return await repository.getUserCompletedChallenges(userId);
  }
  
  /// Get a specific challenge by ID
  Future<ChallengeEntity> byId(String challengeId) async {
    return await repository.getChallengeById(challengeId);
  }
}