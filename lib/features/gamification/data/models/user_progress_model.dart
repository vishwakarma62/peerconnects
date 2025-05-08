import 'package:peer_connects/features/gamification/domain/entities/user_progress_entity.dart';

/// Model class for UserProgress
class UserProgressModel extends UserProgressEntity {
  const UserProgressModel({
    required String userId,
    int totalPoints = 0,
    int level = 1,
    List<String> unlockedAchievements = const [],
    List<String> activeChallenges = const [],
    List<String> completedChallenges = const [],
    Map<String, double> challengeProgress = const {},
    Map<String, dynamic> stats = const {},
  }) : super(
          userId: userId,
          totalPoints: totalPoints,
          level: level,
          unlockedAchievements: unlockedAchievements,
          activeChallenges: activeChallenges,
          completedChallenges: completedChallenges,
          challengeProgress: challengeProgress,
          stats: stats,
        );

  /// Create from JSON map
  factory UserProgressModel.fromJson(Map<String, dynamic> json) {
    return UserProgressModel(
      userId: json['userId'],
      totalPoints: json['totalPoints'] ?? 0,
      level: json['level'] ?? 1,
      unlockedAchievements: json['unlockedAchievements'] != null
          ? List<String>.from(json['unlockedAchievements'])
          : const [],
      activeChallenges: json['activeChallenges'] != null
          ? List<String>.from(json['activeChallenges'])
          : const [],
      completedChallenges: json['completedChallenges'] != null
          ? List<String>.from(json['completedChallenges'])
          : const [],
      challengeProgress: json['challengeProgress'] != null
          ? Map<String, double>.from(json['challengeProgress'])
          : const {},
      stats: json['stats'] ?? const {},
    );
  }

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'totalPoints': totalPoints,
      'level': level,
      'unlockedAchievements': unlockedAchievements,
      'activeChallenges': activeChallenges,
      'completedChallenges': completedChallenges,
      'challengeProgress': challengeProgress,
      'stats': stats,
    };
  }

  /// Create from entity
  factory UserProgressModel.fromEntity(UserProgressEntity entity) {
    return UserProgressModel(
      userId: entity.userId,
      totalPoints: entity.totalPoints,
      level: entity.level,
      unlockedAchievements: entity.unlockedAchievements,
      activeChallenges: entity.activeChallenges,
      completedChallenges: entity.completedChallenges,
      challengeProgress: entity.challengeProgress,
      stats: entity.stats,
    );
  }
}