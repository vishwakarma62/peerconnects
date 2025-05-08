import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Entity representing a challenge in the application
class ChallengeEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final ChallengeType type;
  final ChallengeStatus status;
  final double targetValue;
  final String unit;
  final double? currentValue;
  final List<String>? participants;
  final String? rewardId;
  final int pointsReward;
  final String? creatorId;
  final bool isGlobal;

  const ChallengeEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.type,
    required this.status,
    required this.targetValue,
    required this.unit,
    this.currentValue,
    this.participants,
    this.rewardId,
    this.pointsReward = 100,
    this.creatorId,
    this.isGlobal = false,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        startDate,
        endDate,
        type,
        status,
        targetValue,
        unit,
        currentValue,
        participants,
        rewardId,
        pointsReward,
        creatorId,
        isGlobal,
      ];

  bool get isActive => status == ChallengeStatus.active;
  bool get isCompleted => status == ChallengeStatus.completed;
  bool get isUpcoming => status == ChallengeStatus.upcoming;
  bool get isExpired => status == ChallengeStatus.expired;

  double get progress {
    if (currentValue == null || currentValue == 0) return 0.0;
    double progress = currentValue! / targetValue;
    return progress > 1.0 ? 1.0 : progress;
  }

  int get participantCount => participants?.length ?? 0;

  int get daysLeft {
    final now = DateTime.now();
    if (now.isAfter(endDate)) return 0;
    return endDate.difference(now).inDays;
  }

  int get totalDays => endDate.difference(startDate).inDays;

  bool get isIndividual => type == ChallengeType.individual;
  bool get isGroup => type == ChallengeType.group;
  bool get isCommunity => type == ChallengeType.community;

  IconData get typeIcon {
    switch (type) {
      case ChallengeType.individual:
        return Icons.person;
      case ChallengeType.group:
        return Icons.group;
      case ChallengeType.community:
        return Icons.public;
      case ChallengeType.distance:
        return Icons.straighten;
      case ChallengeType.duration:
        return Icons.timer;
      case ChallengeType.frequency:
        return Icons.calendar_today;
      case ChallengeType.steps:
        return Icons.directions_walk;
      default:
        return Icons.emoji_events;
    }
  }

  Color get typeColor {
    switch (type) {
      case ChallengeType.individual:
        return Colors.blue;
      case ChallengeType.group:
        return Colors.green;
      case ChallengeType.community:
        return Colors.purple;
      case ChallengeType.distance:
        return Colors.orange;
      case ChallengeType.duration:
        return Colors.red;
      case ChallengeType.frequency:
        return Colors.teal;
      case ChallengeType.steps:
        return Colors.amber;
      default:
        return Colors.blue;
    }
  }

  ChallengeEntity copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    ChallengeType? type,
    ChallengeStatus? status,
    double? targetValue,
    String? unit,
    double? currentValue,
    List<String>? participants,
    String? rewardId,
    int? pointsReward,
    String? creatorId,
    bool? isGlobal,
  }) {
    return ChallengeEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      type: type ?? this.type,
      status: status ?? this.status,
      targetValue: targetValue ?? this.targetValue,
      unit: unit ?? this.unit,
      currentValue: currentValue ?? this.currentValue,
      participants: participants ?? this.participants,
      rewardId: rewardId ?? this.rewardId,
      pointsReward: pointsReward ?? this.pointsReward,
      creatorId: creatorId ?? this.creatorId,
      isGlobal: isGlobal ?? this.isGlobal,
    );
  }
}

/// Types of challenges
enum ChallengeType {
  individual, // Personal challenge
  group,      // Challenge for a specific group
  community,  // Challenge for the entire community
  distance,   // Distance-based challenge
  duration,   // Time-based challenge
  frequency,  // Frequency-based challenge (e.g., walk X times per week)
  steps,  
  social    // Steps-based challenge
}

/// Status of a challenge
enum ChallengeStatus {
  upcoming,   // Challenge hasn't started yet
  active,     // Challenge is currently active
  completed,  // Challenge has been completed
  expired,    // Challenge has expired without completion
}