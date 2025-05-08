import 'package:flutter/material.dart';
import 'package:peer_connects/config/theme.dart';
import 'package:peer_connects/features/gamification/domain/entities/achievement_entity.dart';
import 'package:peer_connects/features/gamification/presentation/widgets/achievement_item.dart';

/// A screen that displays all achievements, categorized by type
class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showUnlockedOnly = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: AchievementCategory.values.length + 1, // +1 for "All" tab
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // In a real app, you would get this from a BLoC or provider
    final achievements = _getMockAchievements();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements'),
        actions: [
          // Filter toggle
          IconButton(
            icon: Icon(
              _showUnlockedOnly ? Icons.lock_open : Icons.lock_open_outlined,
              color: _showUnlockedOnly ? AppTheme.primaryColor : null,
            ),
            onPressed: () {
              setState(() {
                _showUnlockedOnly = !_showUnlockedOnly;
              });
            },
            tooltip: _showUnlockedOnly ? 'Show All' : 'Show Unlocked Only',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [
            const Tab(text: 'All'),
            ...AchievementCategory.values.map((category) {
              return Tab(text: _getCategoryName(category));
            }).toList(),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // All achievements tab
          _buildAchievementsGrid(achievements),
          // Category tabs
          ...AchievementCategory.values.map((category) {
            final categoryAchievements = achievements
                .where((a) => a.category == category)
                .toList();
            return _buildAchievementsGrid(categoryAchievements);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildAchievementsGrid(List<AchievementEntity> achievements) {
    // Filter based on unlocked status if needed
    final filteredAchievements = _showUnlockedOnly
        ? achievements.where((a) => a.isUnlocked).toList()
        : achievements;
    
    if (filteredAchievements.isEmpty) {
      return const Center(
        child: Text('No achievements found'),
      );
    }
    
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: filteredAchievements.length,
      itemBuilder: (context, index) {
        final achievement = filteredAchievements[index];
        return _buildAchievementCard(achievement);
      },
    );
  }

  Widget _buildAchievementCard(AchievementEntity achievement) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: achievement.isUnlocked
              ? achievement.rarityColor.withOpacity(0.5)
              : Colors.grey.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () => _showAchievementDetails(achievement),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Achievement icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: achievement.isUnlocked
                      ? achievement.rarityColor.withOpacity(0.2)
                      : Colors.grey.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: achievement.isUnlocked
                        ? achievement.rarityColor
                        : Colors.grey,
                    width: 2,
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      achievement.categoryIcon,
                      size: 40,
                      color: achievement.isUnlocked
                          ? achievement.rarityColor
                          : Colors.grey,
                    ),
                    if (!achievement.isUnlocked)
                      Container(
                        width: 80,
                        height: 80,
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
                    if (achievement.progress != null &&
                        achievement.progress! > 0 &&
                        achievement.progress! < 1)
                      CircularProgressIndicator(
                        value: achievement.progress,
                        strokeWidth: 3,
                        backgroundColor: Colors.transparent,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          achievement.isUnlocked
                              ? achievement.rarityColor
                              : Colors.grey,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              // Achievement title
              Text(
                achievement.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: achievement.isUnlocked ? null : Colors.grey,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              
              // Achievement description
              Text(
                achievement.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: achievement.isUnlocked
                      ? AppTheme.secondaryTextColor
                      : Colors.grey,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 8),
              
              // Rarity badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: achievement.rarityColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: achievement.rarityColor.withOpacity(0.5),
                    width: 1,
                  ),
                ),
                child: Text(
                  achievement.rarityName,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: achievement.rarityColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAchievementDetails(AchievementEntity achievement) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Achievement icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: achievement.rarityColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: achievement.rarityColor,
                    width: 2,
                  ),
                ),
                child: Icon(
                  achievement.categoryIcon,
                  size: 50,
                  color: achievement.rarityColor,
                ),
              ),
              const SizedBox(height: 16),
              
              // Achievement title
              Text(
                achievement.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              
              // Rarity badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: achievement.rarityColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: achievement.rarityColor.withOpacity(0.5),
                    width: 1,
                  ),
                ),
                child: Text(
                  '${achievement.rarityName} • ${_getCategoryName(achievement.category)}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: achievement.rarityColor,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Achievement description
              Text(
                achievement.description,
                style: const TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              
              // Points value
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${achievement.pointsValue} points',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Unlock status
              if (achievement.isUnlocked)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Unlocked on ${_formatDate(achievement.unlockedAt!)}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.green,
                      ),
                    ),
                  ],
                )
              else if (achievement.progress != null)
                Column(
                  children: [
                    Text(
                      'Progress: ${(achievement.progress! * 100).toInt()}%',
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: achievement.progress,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        achievement.rarityColor,
                      ),
                    ),
                  ],
                )
              else
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lock,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Not yet unlocked',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 24),
              
              // Close button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: achievement.rarityColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getCategoryName(AchievementCategory category) {
    switch (category) {
      case AchievementCategory.distance:
        return 'Distance';
      case AchievementCategory.duration:
        return 'Duration';
      case AchievementCategory.frequency:
        return 'Frequency';
      case AchievementCategory.social:
        return 'Social';
      case AchievementCategory.exploration:
        return 'Exploration';
      case AchievementCategory.special:
        return 'Special';
      default:
        return 'Unknown';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  // Mock data for demonstration
  List<AchievementEntity> _getMockAchievements() {
    return [
      AchievementEntity(
        id: '1',
        title: 'Early Bird',
        description: 'Complete 10 morning walks before 8 AM',
        iconName: 'wb_sunny',
        category: AchievementCategory.frequency,
        rarity: AchievementRarity.common,
        pointsValue: 50,
        criteria: {'morningWalks': 10},
        unlockedAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      AchievementEntity(
        id: '2',
        title: 'Consistent Walker',
        description: 'Walk for 5 consecutive days',
        iconName: 'calendar_today',
        category: AchievementCategory.frequency,
        rarity: AchievementRarity.common,
        pointsValue: 50,
        criteria: {'consecutiveDays': 5},
        unlockedAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      AchievementEntity(
        id: '3',
        title: 'Explorer',
        description: 'Walk 5 different routes',
        iconName: 'explore',
        category: AchievementCategory.exploration,
        rarity: AchievementRarity.uncommon,
        pointsValue: 100,
        criteria: {'uniqueRoutes': 5},
        progress: 0.6,
      ),
      AchievementEntity(
        id: '4',
        title: 'Social Butterfly',
        description: 'Join 3 group walks',
        iconName: 'group',
        category: AchievementCategory.social,
        rarity: AchievementRarity.uncommon,
        pointsValue: 100,
        criteria: {'groupWalks': 3},
        progress: 0.33,
      ),
      AchievementEntity(
        id: '5',
        title: '5K Club',
        description: 'Walk 5 kilometers in a single walk',
        iconName: 'straighten',
        category: AchievementCategory.distance,
        rarity: AchievementRarity.uncommon,
        pointsValue: 100,
        criteria: {'singleWalkDistance': 5.0},
      ),
      AchievementEntity(
        id: '6',
        title: 'Marathon Walker',
        description: 'Walk a total of 42 kilometers',
        iconName: 'straighten',
        category: AchievementCategory.distance,
        rarity: AchievementRarity.rare,
        pointsValue: 200,
        criteria: {'totalDistance': 42.0},
        progress: 0.75,
      ),
      AchievementEntity(
        id: '7',
        title: 'Time Traveler',
        description: 'Walk for a total of 24 hours',
        iconName: 'timer',
        category: AchievementCategory.duration,
        rarity: AchievementRarity.rare,
        pointsValue: 200,
        criteria: {'totalDuration': 24.0},
        progress: 0.5,
      ),
      AchievementEntity(
        id: '8',
        title: 'Community Leader',
        description: 'Create a walking group with 10+ members',
        iconName: 'people',
        category: AchievementCategory.social,
        rarity: AchievementRarity.epic,
        pointsValue: 300,
        criteria: {'groupMembers': 10},
      ),
      AchievementEntity(
        id: '9',
        title: 'Global Walker',
        description: 'Walk in 5 different cities',
        iconName: 'public',
        category: AchievementCategory.exploration,
        rarity: AchievementRarity.epic,
        pointsValue: 300,
        criteria: {'uniqueCities': 5},
      ),
      AchievementEntity(
        id: '10',
        title: 'Walking Legend',
        description: 'Walk 1000 kilometers in total',
        iconName: 'emoji_events',
        category: AchievementCategory.distance,
        rarity: AchievementRarity.legendary,
        pointsValue: 500,
        criteria: {'totalDistance': 1000.0},
        progress: 0.15,
      ),
    ];
  }
}