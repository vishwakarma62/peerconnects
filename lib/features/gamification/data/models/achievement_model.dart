import 'package:peer_connects/features/gamification/domain/entities/achievement_entity.dart';

/// Model class for Achievement
class AchievementModel extends AchievementEntity {
  const AchievementModel({
    required String id,
    required String title,
    required String description,
    required String iconName,
    required AchievementCategory category,
    required AchievementRarity rarity,
    required int pointsValue,
    required Map<String, dynamic> criteria,
    bool isSecret = false,
    DateTime? unlockedAt,
    double? progress,
  }) : super(
          id: id,
          title: title,
          description: description,
          iconName: iconName,
          category: category,
          rarity: rarity,
          pointsValue: pointsValue,
          criteria: criteria,
          isSecret: isSecret,
          unlockedAt: unlockedAt,
          progress: progress,
        );

  /// Create from JSON map
  factory AchievementModel.fromJson(Map<String, dynamic> json) {
    return AchievementModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      iconName: json['iconName'],
      category: _categoryFromString(json['category']),
      rarity: _rarityFromString(json['rarity']),
      pointsValue: json['pointsValue'],
      criteria: json['criteria'],
      isSecret: json['isSecret'] ?? false,
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.parse(json['unlockedAt'])
          : null,
      progress: json['progress']?.toDouble(),
    );
  }

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'iconName': iconName,
      'category': category.toString().split('.').last,
      'rarity': rarity.toString().split('.').last,
      'pointsValue': pointsValue,
      'criteria': criteria,
      'isSecret': isSecret,
      'unlockedAt': unlockedAt?.toIso8601String(),
      'progress': progress,
    };
  }

  /// Create from entity
  factory AchievementModel.fromEntity(AchievementEntity entity) {
    return AchievementModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      iconName: entity.iconName,
      category: entity.category,
      rarity: entity.rarity,
      pointsValue: entity.pointsValue,
      criteria: entity.criteria,
      isSecret: entity.isSecret,
      unlockedAt: entity.unlockedAt,
      progress: entity.progress,
    );
  }

  /// Helper method to convert string to AchievementCategory
  static AchievementCategory _categoryFromString(String category) {
    switch (category) {
      case 'distance':
        return AchievementCategory.distance;
      case 'duration':
        return AchievementCategory.duration;
      case 'frequency':
        return AchievementCategory.frequency;
      case 'social':
        return AchievementCategory.social;
      case 'exploration':
        return AchievementCategory.exploration;
      case 'special':
        return AchievementCategory.special;
      default:
        return AchievementCategory.special;
    }
  }

  /// Helper method to convert string to AchievementRarity
  static AchievementRarity _rarityFromString(String rarity) {
    switch (rarity) {
      case 'common':
        return AchievementRarity.common;
      case 'uncommon':
        return AchievementRarity.uncommon;
      case 'rare':
        return AchievementRarity.rare;
      case 'epic':
        return AchievementRarity.epic;
      case 'legendary':
        return AchievementRarity.legendary;
      default:
        return AchievementRarity.common;
    }
  }
}