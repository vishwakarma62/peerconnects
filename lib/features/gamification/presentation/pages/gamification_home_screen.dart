import 'package:flutter/material.dart';
import 'package:peer_connects/config/theme.dart';
import 'package:peer_connects/features/gamification/domain/entities/achievement_entity.dart';
import 'package:peer_connects/features/gamification/domain/entities/challenge_entity.dart';
import 'package:peer_connects/features/gamification/domain/entities/user_progress_entity.dart';
import 'package:peer_connects/features/gamification/presentation/pages/achievements_screen.dart';
import 'package:peer_connects/features/gamification/presentation/pages/challenges_screen.dart';
import 'package:peer_connects/features/gamification/presentation/pages/leaderboard_screen.dart';
import 'package:peer_connects/features/gamification/presentation/widgets/achievement_item.dart';
import 'package:peer_connects/features/gamification/presentation/widgets/challenge_card.dart';
import 'package:peer_connects/features/gamification/presentation/widgets/user_level_indicator.dart';

/// The main screen for the gamification feature
class GamificationHomeScreen extends StatefulWidget {
  const GamificationHomeScreen({super.key});

  @override
  State<GamificationHomeScreen> createState() => _GamificationHomeScreenState();
}

class _GamificationHomeScreenState extends State<GamificationHomeScreen> {
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    _loadData();
  }
  
  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });
    
    // In a real app, you would load data from repositories
    await Future.delayed(const Duration(seconds: 1));
    
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // In a real app, you would get this from BLoCs or providers
    final userProgress = _getMockUserProgress();
    final recentAchievements = _getMockRecentAchievements();
    final activeChallenges = _getMockActiveChallenges();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gamification'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User level and progress
                    UserLevelIndicator.fromEntity(userProgress),
                    const SizedBox(height: 24),
                    
                    // Quick stats
                    _buildQuickStats(userProgress),
                    const SizedBox(height: 24),
                    
                    // Recent achievements
                    _buildSectionHeader(
                      'Recent Achievements',
                      onSeeAll: () => _navigateToAchievements(),
                    ),
                    const SizedBox(height: 16),
                    _buildRecentAchievements(recentAchievements),
                    const SizedBox(height: 24),
                    
                    // Active challenges
                    _buildSectionHeader(
                      'Active Challenges',
                      onSeeAll: () => _navigateToChallenges(),
                    ),
                    const SizedBox(height: 16),
                    _buildActiveChallenges(activeChallenges),
                    const SizedBox(height: 24),
                    
                    // Leaderboard preview
                    _buildSectionHeader(
                      'Leaderboard',
                      onSeeAll: () => _navigateToLeaderboard(),
                    ),
                    const SizedBox(height: 16),
                    _buildLeaderboardPreview(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildQuickStats(UserProgressEntity userProgress) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem(
          userProgress.achievementCount.toString(),
          'Achievements',
          Icons.emoji_events,
          Colors.amber,
          onTap: () => _navigateToAchievements(),
        ),
        _buildStatItem(
          userProgress.activeChallengeCount.toString(),
          'Challenges',
          Icons.flag,
          Colors.green,
          onTap: () => _navigateToChallenges(),
        ),
        _buildStatItem(
          userProgress.totalPoints.toString(),
          'Points',
          Icons.star,
          Colors.orange,
          onTap: () => _navigateToLeaderboard(),
        ),
      ],
    );
  }

  Widget _buildStatItem(
    String value,
    String label,
    IconData icon,
    Color color, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 32,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onSeeAll}) {
    return Row(
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
          TextButton(
            onPressed: onSeeAll,
            child: const Text('See All'),
          ),
      ],
    );
  }

  Widget _buildRecentAchievements(List<AchievementEntity> achievements) {
    if (achievements.isEmpty) {
      return const Center(
        child: Text('No achievements yet'),
      );
    }
    
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: achievements.length,
        itemBuilder: (context, index) {
          final achievement = achievements[index];
          return AchievementItem.fromEntity(
            achievement,
            onTap: () => _navigateToAchievements(),
          );
        },
      ),
    );
  }

  Widget _buildActiveChallenges(List<ChallengeEntity> challenges) {
    if (challenges.isEmpty) {
      return Center(
        child: Column(
          children: [
            const Text('No active challenges'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _navigateToChallenges(),
              style: AppTheme.primaryButtonStyle,
              child: const Text('Join a Challenge'),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: challenges.length > 2 ? 2 : challenges.length,
      itemBuilder: (context, index) {
        final challenge = challenges[index];
        return ChallengeCard.fromEntity(
          challenge,
          onDetails: () => _navigateToChallenges(),
          onLogProgress: () => _navigateToChallenges(),
        );
      },
    );
  }

  Widget _buildLeaderboardPreview() {
    // In a real app, you would get this from a repository
    final topUsers = _getMockTopUsers();
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            for (int i = 0; i < topUsers.length && i < 3; i++)
              ListTile(
                leading: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: i == 0
                        ? Colors.amber.withOpacity(0.2)
                        : i == 1
                            ? Colors.grey[400]!.withOpacity(0.2)
                            : Colors.brown[300]!.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${i + 1}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: i == 0
                          ? Colors.amber
                          : i == 1
                              ? Colors.grey[700]
                              : Colors.brown,
                    ),
                  ),
                ),
                title: Text(topUsers[i].name),
                subtitle: Text('Level ${topUsers[i].level}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${topUsers[i].points}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _navigateToLeaderboard(),
                style: AppTheme.primaryButtonStyle,
                child: const Text('View Full Leaderboard'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToAchievements() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AchievementsScreen(),
      ),
    );
  }

  void _navigateToChallenges() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ChallengesScreen(),
      ),
    );
  }

  void _navigateToLeaderboard() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LeaderboardScreen(),
      ),
    );
  }

  // Mock data for demonstration
  UserProgressEntity _getMockUserProgress() {
    return UserProgressEntity(
      userId: 'user123',
      totalPoints: 2100,
      level: 5,
      unlockedAchievements: ['1', '2', '3', '4'],
      activeChallenges: ['1', '2', '3'],
      completedChallenges: ['6', '7'],
      challengeProgress: {
        '1': 0.6,
        '2': 0.72,
        '3': 0.33,
      },
      stats: {
        'totalDistance': 156.8,
        'totalWalks': 42,
        'totalDuration': 24.5,
      },
    );
  }

  List<AchievementEntity> _getMockRecentAchievements() {
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
    ];
  }

  List<ChallengeEntity> _getMockActiveChallenges() {
    final now = DateTime.now();
    return [
      ChallengeEntity(
        id: '1',
        title: '30-Day Walking Streak',
        description: 'Walk at least 1 km every day for 30 days',
        startDate: now.subtract(const Duration(days: 18)),
        endDate: now.add(const Duration(days: 12)),
        type: ChallengeType.individual,
        status: ChallengeStatus.active,
        targetValue: 30,
        unit: 'days',
        currentValue: 18,
        participants: ['user1', 'user2', 'user3'],
        pointsReward: 300,
      ),
      ChallengeEntity(
        id: '2',
        title: 'Weekly Distance Challenge',
        description: 'Walk 25 km this week',
        startDate: now.subtract(const Duration(days: 3)),
        endDate: now.add(const Duration(days: 4)),
        type: ChallengeType.distance,
        status: ChallengeStatus.active,
        targetValue: 25,
        unit: 'km',
        currentValue: 18.1,
        participants: ['user1', 'user2', 'user3', 'user4'],
        pointsReward: 200,
      ),
      ChallengeEntity(
        id: '3',
        title: 'Community Explorer',
        description: 'Join 3 different community walks this month',
        startDate: now.subtract(const Duration(days: 15)),
        endDate: now.add(const Duration(days: 15)),
        type: ChallengeType.social,
        status: ChallengeStatus.active,
        targetValue: 3,
        unit: 'walks',
        currentValue: 1,
        participants: ['user1', 'user2'],
        pointsReward: 150,
      ),
    ];
  }

  List<LeaderboardUser> _getMockTopUsers() {
    return [
      LeaderboardUser(
        id: 'user1',
        name: 'Sarah Johnson',
        points: 3250,
        level: 8,
      ),
      LeaderboardUser(
        id: 'user2',
        name: 'Mike Chen',
        points: 2980,
        level: 7,
      ),
      LeaderboardUser(
        id: 'user3',
        name: 'Emma Wilson',
        points: 2750,
        level: 7,
      ),
    ];
  }
}

class LeaderboardUser {
  final String id;
  final String name;
  final int points;
  final int level;

  LeaderboardUser({
    required this.id,
    required this.name,
    required this.points,
    required this.level,
  });
}