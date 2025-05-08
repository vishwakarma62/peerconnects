import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Entity representing an achievement in the application
class AchievementEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String iconName;
  final AchievementCategory category;
  final AchievementRarity rarity;
  final int pointsValue;
  final Map<String, dynamic> criteria;
  final bool isSecret;
  final DateTime? unlockedAt;
  final double? progress; // 0.0 to 1.0 for progress-based achievements

  const AchievementEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.iconName,
    required this.category,
    required this.rarity,
    required this.pointsValue,
    required this.criteria,
    this.isSecret = false,
    this.unlockedAt,
    this.progress,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        iconName,
        category,
        rarity,
        pointsValue,
        criteria,
        isSecret,
        unlockedAt,
        progress,
      ];

  bool get isUnlocked => unlockedAt != null;

  Color get rarityColor {
    switch (rarity) {
      case AchievementRarity.common:
        return Colors.grey.shade700;
      case AchievementRarity.uncommon:
        return Colors.green;
      case AchievementRarity.rare:
        return Colors.blue;
      case AchievementRarity.epic:
        return Colors.purple;
      case AchievementRarity.legendary:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData get categoryIcon {
    switch (category) {
      case AchievementCategory.distance:
        return Icons.straighten;
      case AchievementCategory.duration:
        return Icons.timer;
      case AchievementCategory.frequency:
        return Icons.calendar_today;
      case AchievementCategory.social:
        return Icons.people;
      case AchievementCategory.exploration:
        return Icons.explore;
      case AchievementCategory.special:
        return Icons.star;
      default:
        return Icons.emoji_events;
    }
  }

  String get rarityName {
    return rarity.toString().split('.').last;
  }

  String get categoryName {
    return category.toString().split('.').last;
  }

  AchievementEntity copyWith({
    String? id,
    String? title,
    String? description,
    String? iconName,
    AchievementCategory? category,
    AchievementRarity? rarity,
    int? pointsValue,
    Map<String, dynamic>? criteria,
    bool? isSecret,
    DateTime? unlockedAt,
    double? progress,
  }) {
    return AchievementEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      iconName: iconName ?? this.iconName,
      category: category ?? this.category,
      rarity: rarity ?? this.rarity,
      pointsValue: pointsValue ?? this.pointsValue,
      criteria: criteria ?? this.criteria,
      isSecret: isSecret ?? this.isSecret,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      progress: progress ?? this.progress,
    );
  }
}

/// Categories of achievements
enum AchievementCategory {
  distance,    // Related to distance walked
  duration,    // Related to time spent walking
  frequency,   // Related to consistency of walking
  social,      // Related to social interactions
  exploration, // Related to exploring new areas
  special,     // Special or seasonal achievements
}

/// Rarity levels for achievements
enum AchievementRarity {
  common,    // Easy to get
  uncommon,  // Requires some effort
  rare,      // Requires significant effort
  epic,      // Requires dedication
  legendary, // Requires exceptional dedication
}