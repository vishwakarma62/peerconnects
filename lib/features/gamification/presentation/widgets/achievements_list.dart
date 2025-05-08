import 'package:flutter/material.dart';
import 'package:peer_connects/features/gamification/domain/entities/achievement_entity.dart';
import 'package:peer_connects/features/gamification/presentation/widgets/achievement_item.dart';

/// A widget that displays a horizontal list of achievements
class AchievementsList extends StatelessWidget {
  final List<AchievementEntity> achievements;
  final String title;
  final VoidCallback? onSeeAll;
  final Function(AchievementEntity)? onAchievementTap;
  final bool showUnlocked;
  final bool showLocked;

  const AchievementsList({
    super.key,
    required this.achievements,
    required this.title,
    this.onSeeAll,
    this.onAchievementTap,
    this.showUnlocked = true,
    this.showLocked = true,
  });

  @override
  Widget build(BuildContext context) {
    // Filter achievements based on locked/unlocked preferences
    final filteredAchievements = achievements.where((achievement) {
      if (showUnlocked && achievement.isUnlocked) return true;
      if (showLocked && !achievement.isUnlocked) return true;
      return false;
    }).toList();

    if (filteredAchievements.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title row with "See All" button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (onSeeAll != null)
              GestureDetector(
                onTap: onSeeAll,
                child: const Text(
                  'See All',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Horizontal list of achievements
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: filteredAchievements.length,
            itemBuilder: (context, index) {
              final achievement = filteredAchievements[index];
              return AchievementItem.fromEntity(
                achievement,
                onTap: onAchievementTap != null
                    ? () => onAchievementTap!(achievement)
                    : null,
              );
            },
          ),
        ),
      ],
    );
  }
}