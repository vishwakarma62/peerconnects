import 'package:flutter/material.dart';
import 'package:peer_connects/config/theme.dart';
import 'package:peer_connects/features/gamification/domain/entities/achievement_entity.dart';

/// A widget that displays an achievement item
class AchievementItem extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final bool isUnlocked;
  final double? progress;
  final VoidCallback? onTap;

  const AchievementItem({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    this.isUnlocked = true,
    this.progress,
    this.onTap,
  });

  /// Create from an AchievementEntity
  factory AchievementItem.fromEntity(
    AchievementEntity achievement, {
    VoidCallback? onTap,
  }) {
    return AchievementItem(
      title: achievement.title,
      description: achievement.description,
      icon: achievement.categoryIcon,
      color: achievement.isUnlocked 
          ? achievement.rarityColor 
          : Colors.grey,
      isUnlocked: achievement.isUnlocked,
      progress: achievement.progress,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            // Achievement icon with background
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: isUnlocked 
                    ? color.withOpacity(0.2) 
                    : Colors.grey.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isUnlocked ? color : Colors.grey,
                  width: 2,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Icon
                  Icon(
                    icon,
                    size: 36,
                    color: isUnlocked ? color : Colors.grey,
                  ),
                  
                  // Lock overlay for locked achievements
                  if (!isUnlocked)
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lock,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    
                  // Progress indicator if available
                  if (progress != null && progress! > 0 && progress! < 1)
                    CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 3,
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isUnlocked ? color : Colors.grey,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            
            // Achievement title
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isUnlocked ? null : Colors.grey,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            
            // Achievement description
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: isUnlocked 
                    ? AppTheme.secondaryTextColor 
                    : Colors.grey,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}