import 'package:peer_connects/features/gamification/domain/entities/challenge_entity.dart';

/// Model class for Challenge
class ChallengeModel extends ChallengeEntity {
  const ChallengeModel({
    required String id,
    required String title,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
    required ChallengeType type,
    required ChallengeStatus status,
    required double targetValue,
    required String unit,
    double? currentValue,
    List<String>? participants,
    String? rewardId,
    int pointsReward = 100,
    String? creatorId,
    bool isGlobal = false,
  }) : super(
          id: id,
          title: title,
          description: description,
          startDate: startDate,
          endDate: endDate,
          type: type,
          status: status,
          targetValue: targetValue,
          unit: unit,
          currentValue: currentValue,
          participants: participants,
          rewardId: rewardId,
          pointsReward: pointsReward,
          creatorId: creatorId,
          isGlobal: isGlobal,
        );

  /// Create from JSON map
  factory ChallengeModel.fromJson(Map<String, dynamic> json) {
    return ChallengeModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      type: _typeFromString(json['type']),
      status: _statusFromString(json['status']),
      targetValue: json['targetValue'].toDouble(),
      unit: json['unit'],
      currentValue: json['currentValue']?.toDouble(),
      participants: json['participants'] != null
          ? List<String>.from(json['participants'])
          : null,
      rewardId: json['rewardId'],
      pointsReward: json['pointsReward'] ?? 100,
      creatorId: json['creatorId'],
      isGlobal: json['isGlobal'] ?? false,
    );
  }

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'type': type.toString().split('.').last,
      'status': status.toString().split('.').last,
      'targetValue': targetValue,
      'unit': unit,
      'currentValue': currentValue,
      'participants': participants,
      'rewardId': rewardId,
      'pointsReward': pointsReward,
      'creatorId': creatorId,
      'isGlobal': isGlobal,
    };
  }

  /// Create from entity
  factory ChallengeModel.fromEntity(ChallengeEntity entity) {
    return ChallengeModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      startDate: entity.startDate,
      endDate: entity.endDate,
      type: entity.type,
      status: entity.status,
      targetValue: entity.targetValue,
      unit: entity.unit,
      currentValue: entity.currentValue,
      participants: entity.participants,
      rewardId: entity.rewardId,
      pointsReward: entity.pointsReward,
      creatorId: entity.creatorId,
      isGlobal: entity.isGlobal,
    );
  }

  /// Helper method to convert string to ChallengeType
  static ChallengeType _typeFromString(String type) {
    switch (type) {
      case 'individual':
        return ChallengeType.individual;
      case 'group':
        return ChallengeType.group;
      case 'community':
        return ChallengeType.community;
      case 'distance':
        return ChallengeType.distance;
      case 'duration':
        return ChallengeType.duration;
      case 'frequency':
        return ChallengeType.frequency;
      case 'steps':
        return ChallengeType.steps;
      default:
        return ChallengeType.individual;
    }
  }

  /// Helper method to convert string to ChallengeStatus
  static ChallengeStatus _statusFromString(String status) {
    switch (status) {
      case 'upcoming':
        return ChallengeStatus.upcoming;
      case 'active':
        return ChallengeStatus.active;
      case 'completed':
        return ChallengeStatus.completed;
      case 'expired':
        return ChallengeStatus.expired;
      default:
        return ChallengeStatus.upcoming;
    }
  }
}