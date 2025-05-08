import 'package:equatable/equatable.dart';

/// Entity representing a user's progress in the gamification system
class UserProgressEntity extends Equatable {
  final String userId;
  final int totalPoints;
  final int level;
  final List<String> unlockedAchievements;
  final List<String> activeChallenges;
  final List<String> completedChallenges;
  final Map<String, double> challengeProgress;
  final Map<String, dynamic> stats;

  const UserProgressEntity({
    required this.userId,
    this.totalPoints = 0,
    this.level = 1,
    this.unlockedAchievements = const [],
    this.activeChallenges = const [],
    this.completedChallenges = const [],
    this.challengeProgress = const {},
    this.stats = const {},
  });

  @override
  List<Object?> get props => [
        userId,
        totalPoints,
        level,
        unlockedAchievements,
        activeChallenges,
        completedChallenges,
        challengeProgress,
        stats,
      ];

  /// Calculate points needed for next level
  int get pointsForNextLevel => level * 100;

  /// Calculate progress to next level (0.0 to 1.0)
  double get levelProgress {
    final pointsInCurrentLevel = totalPoints - ((level - 1) * 100);
    return pointsInCurrentLevel / pointsForNextLevel;
  }

  /// Get achievement count
  int get achievementCount => unlockedAchievements.length;

  /// Get completed challenge count
  int get completedChallengeCount => completedChallenges.length;

  /// Get active challenge count
  int get activeChallengeCount => activeChallenges.length;

  /// Check if user has unlocked a specific achievement
  bool hasAchievement(String achievementId) => 
      unlockedAchievements.contains(achievementId);

  /// Check if user has completed a specific challenge
  bool hasCompletedChallenge(String challengeId) => 
      completedChallenges.contains(challengeId);

  /// Get progress for a specific challenge (0.0 to 1.0)
  double getChallengeProgress(String challengeId) => 
      challengeProgress[challengeId] ?? 0.0;

  /// Get a specific stat value
  dynamic getStat(String statKey) => stats[statKey];

  /// Create a copy with updated values
  UserProgressEntity copyWith({
    String? userId,
    int? totalPoints,
    int? level,
    List<String>? unlockedAchievements,
    List<String>? activeChallenges,
    List<String>? completedChallenges,
    Map<String, double>? challengeProgress,
    Map<String, dynamic>? stats,
  }) {
    return UserProgressEntity(
      userId: userId ?? this.userId,
      totalPoints: totalPoints ?? this.totalPoints,
      level: level ?? this.level,
      unlockedAchievements: unlockedAchievements ?? this.unlockedAchievements,
      activeChallenges: activeChallenges ?? this.activeChallenges,
      completedChallenges: completedChallenges ?? this.completedChallenges,
      challengeProgress: challengeProgress ?? this.challengeProgress,
      stats: stats ?? this.stats,
    );
  }

  /// Add points to user's total and update level if necessary
  UserProgressEntity addPoints(int points) {
    final newTotalPoints = totalPoints + points;
    final newLevel = (newTotalPoints / 100).floor() + 1;
    
    return copyWith(
      totalPoints: newTotalPoints,
      level: newLevel,
    );
  }

  /// Add an achievement to user's unlocked achievements
  UserProgressEntity unlockAchievement(String achievementId) {
    if (unlockedAchievements.contains(achievementId)) {
      return this;
    }
    
    return copyWith(
      unlockedAchievements: [...unlockedAchievements, achievementId],
    );
  }

  /// Add a challenge to user's active challenges
  UserProgressEntity addActiveChallenge(String challengeId) {
    if (activeChallenges.contains(challengeId)) {
      return this;
    }
    
    return copyWith(
      activeChallenges: [...activeChallenges, challengeId],
    );
  }

  /// Complete a challenge and move it from active to completed
  UserProgressEntity completeChallenge(String challengeId) {
    if (!activeChallenges.contains(challengeId) || 
        completedChallenges.contains(challengeId)) {
      return this;
    }
    
    final newActiveChallenges = [...activeChallenges];
    newActiveChallenges.remove(challengeId);
    
    return copyWith(
      activeChallenges: newActiveChallenges,
      completedChallenges: [...completedChallenges, challengeId],
    );
  }

  /// Update progress for a specific challenge
  UserProgressEntity updateChallengeProgress(String challengeId, double progress) {
    final newProgress = Map<String, double>.from(challengeProgress);
    newProgress[challengeId] = progress;
    
    return copyWith(
      challengeProgress: newProgress,
    );
  }

  /// Update a specific stat
  UserProgressEntity updateStat(String statKey, dynamic value) {
    final newStats = Map<String, dynamic>.from(stats);
    newStats[statKey] = value;
    
    return copyWith(
      stats: newStats,
    );
  }
  
  /// Convert to JSON map - added to fix the error
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
}