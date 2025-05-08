import 'package:flutter/material.dart';
import 'package:peer_connects/config/theme.dart';
import 'package:peer_connects/features/gamification/domain/entities/challenge_entity.dart';
import 'package:peer_connects/features/gamification/presentation/widgets/challenge_card.dart';

/// A screen that displays challenges with tabs for active, upcoming, and completed
class ChallengesScreen extends StatefulWidget {
  const ChallengesScreen({super.key});

  @override
  State<ChallengesScreen> createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends State<ChallengesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // In a real app, you would get this from a BLoC or provider
    final activeChallenges = _getMockActiveChallenges();
    final upcomingChallenges = _getMockUpcomingChallenges();
    final completedChallenges = _getMockCompletedChallenges();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Challenges'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'Upcoming'),
            Tab(text: 'Completed'),
          ],
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: AppTheme.secondaryTextColor,
          indicatorColor: AppTheme.primaryColor,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildActiveChallenges(activeChallenges),
          _buildUpcomingChallenges(upcomingChallenges),
          _buildCompletedChallenges(completedChallenges),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Create or join a challenge
          _showCreateChallengeDialog();
        },
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildActiveChallenges(List<ChallengeEntity> challenges) {
    if (challenges.isEmpty) {
      return _buildEmptyState(
        'No active challenges',
        'Join a challenge to get started',
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: challenges.length,
      itemBuilder: (context, index) {
        final challenge = challenges[index];
        return ChallengeCard.fromEntity(
          challenge,
          onDetails: () => _showChallengeDetails(challenge),
          onLogProgress: () => _showLogProgressDialog(challenge),
        );
      },
    );
  }

  Widget _buildUpcomingChallenges(List<ChallengeEntity> challenges) {
    if (challenges.isEmpty) {
      return _buildEmptyState(
        'No upcoming challenges',
        'Check back later for new challenges',
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: challenges.length,
      itemBuilder: (context, index) {
        final challenge = challenges[index];
        return ChallengeCard.fromEntity(
          challenge,
          onDetails: () => _showChallengeDetails(challenge),
          onJoin: () => _joinChallenge(challenge),
        );
      },
    );
  }

  Widget _buildCompletedChallenges(List<ChallengeEntity> challenges) {
    if (challenges.isEmpty) {
      return _buildEmptyState(
        'No completed challenges',
        'Complete challenges to see them here',
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: challenges.length,
      itemBuilder: (context, index) {
        final challenge = challenges[index];
        return ChallengeCard.fromEntity(
          challenge,
          onDetails: () => _showChallengeDetails(challenge),
        );
      },
    );
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.emoji_events_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Browse challenges
              _tabController.animateTo(1); // Switch to upcoming tab
            },
            style: AppTheme.primaryButtonStyle,
            child: const Text('Browse Challenges'),
          ),
        ],
      ),
    );
  }

  void _showChallengeDetails(ChallengeEntity challenge) {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Challenge header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: challenge.typeColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      challenge.typeIcon,
                      color: challenge.typeColor,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          challenge.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatDateRange(challenge.startDate, challenge.endDate),
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppTheme.secondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Challenge description
              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                challenge.description,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 24),
              
              // Challenge goal
              const Text(
                'Goal',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${challenge.targetValue} ${challenge.unit}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 24),
              
              // Progress (if active)
              if (challenge.isActive && challenge.currentValue != null) ...[
                const Text(
                  'Your Progress',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${challenge.currentValue} / ${challenge.targetValue} ${challenge.unit}',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '${(challenge.progress * 100).toInt()}%',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: challenge.progress,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(challenge.typeColor),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 24),
              ],
              
              // Participants
              if (challenge.participants != null && challenge.participants!.isNotEmpty) ...[
                const Text(
                  'Participants',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${challenge.participants!.length} people joined this challenge',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 24),
              ],
              
              // Action buttons
              Row(
                children: [
                  if (challenge.isActive)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _showLogProgressDialog(challenge),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: challenge.typeColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Log Progress'),
                      ),
                    )
                  else if (challenge.isUpcoming)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _joinChallenge(challenge),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: challenge.typeColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Join Challenge'),
                      ),
                    )
                  else if (challenge.isCompleted)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Share results
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: challenge.typeColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Share Results'),
                      ),
                    ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: challenge.typeColor,
                        side: BorderSide(color: challenge.typeColor),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Close'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLogProgressDialog(ChallengeEntity challenge) {
    final TextEditingController progressController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Progress'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current progress: ${challenge.currentValue ?? 0} ${challenge.unit}',
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.secondaryTextColor,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: progressController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'New progress (${challenge.unit})',
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Update progress
              final newProgress = double.tryParse(progressController.text);
              if (newProgress != null) {
                // In a real app, you would update the progress in the repository
                Navigator.pop(context);
                
                // Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Progress updated successfully'),
                    backgroundColor: AppTheme.primaryColor,
                  ),
                );
                
                // Refresh the UI
                setState(() {});
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _joinChallenge(ChallengeEntity challenge) {
    // In a real app, you would join the challenge in the repository
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('You joined the ${challenge.title} challenge'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
    
    // Switch to active tab
    _tabController.animateTo(0);
    
    // Refresh the UI
    setState(() {});
  }

  void _showCreateChallengeDialog() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController targetController = TextEditingController();
    String selectedUnit = 'km';
    ChallengeType selectedType = ChallengeType.individual;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Challenge'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Challenge Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: targetController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Target Value',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: DropdownButtonFormField<String>(
                      value: selectedUnit,
                      decoration: const InputDecoration(
                        labelText: 'Unit',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'km', child: Text('km')),
                        DropdownMenuItem(value: 'steps', child: Text('steps')),
                        DropdownMenuItem(value: 'days', child: Text('days')),
                        DropdownMenuItem(value: 'hours', child: Text('hours')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          selectedUnit = value;
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Challenge Type',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.secondaryTextColor,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<ChallengeType>(
                value: selectedType,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                items: [
                  DropdownMenuItem(
                    value: ChallengeType.individual,
                    child: Row(
                      children: [
                        const Icon(Icons.person),
                        const SizedBox(width: 8),
                        const Text('Individual'),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: ChallengeType.group,
                    child: Row(
                      children: [
                        const Icon(Icons.group),
                        const SizedBox(width: 8),
                        const Text('Group'),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: ChallengeType.community,
                    child: Row(
                      children: [
                        const Icon(Icons.public),
                        const SizedBox(width: 8),
                        const Text('Community'),
                      ],
                    ),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    selectedType = value;
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Create challenge
              if (titleController.text.isNotEmpty &&
                  descriptionController.text.isNotEmpty &&
                  targetController.text.isNotEmpty) {
                // In a real app, you would create the challenge in the repository
                Navigator.pop(context);
                
                // Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Challenge created successfully'),
                    backgroundColor: AppTheme.primaryColor,
                  ),
                );
                
                // Refresh the UI
                setState(() {});
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
            ),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  String _formatDateRange(DateTime start, DateTime end) {
    final startMonth = _getMonthName(start.month);
    final endMonth = _getMonthName(end.month);
    
    if (start.year == end.year) {
      if (start.month == end.month) {
        return '$startMonth ${start.day} - ${end.day}, ${start.year}';
      } else {
        return '$startMonth ${start.day} - $endMonth ${end.day}, ${start.year}';
      }
    } else {
      return '$startMonth ${start.day}, ${start.year} - $endMonth ${end.day}, ${end.year}';
    }
  }
  
  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  // Mock data for demonstration
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

  List<ChallengeEntity> _getMockUpcomingChallenges() {
    final now = DateTime.now();
    return [
      ChallengeEntity(
        id: '4',
        title: 'Summer Step Challenge',
        description: 'Reach 300,000 steps in June',
        startDate: now.add(const Duration(days: 10)),
        endDate: now.add(const Duration(days: 40)),
        type: ChallengeType.steps,
        status: ChallengeStatus.upcoming,
        targetValue: 300000,
        unit: 'steps',
        participants: ['user1', 'user2', 'user3', 'user4', 'user5'],
        pointsReward: 500,
      ),
      ChallengeEntity(
        id: '5',
        title: 'Sunrise Walkers',
        description: 'Complete 10 morning walks before 8 AM',
        startDate: now.add(const Duration(days: 5)),
        endDate: now.add(const Duration(days: 35)),
        type: ChallengeType.frequency,
        status: ChallengeStatus.upcoming,
        targetValue: 10,
        unit: 'walks',
        participants: ['user1', 'user2'],
        pointsReward: 200,
      ),
    ];
  }

  List<ChallengeEntity> _getMockCompletedChallenges() {
    final now = DateTime.now();
    return [
      ChallengeEntity(
        id: '6',
        title: 'Spring Step Up',
        description: 'Walk 100 km in April',
        startDate: now.subtract(const Duration(days: 60)),
        endDate: now.subtract(const Duration(days: 30)),
        type: ChallengeType.distance,
        status: ChallengeStatus.completed,
        targetValue: 100,
        unit: 'km',
        currentValue: 112.5,
        participants: ['user1', 'user2', 'user3'],
        pointsReward: 300,
      ),
      ChallengeEntity(
        id: '7',
        title: 'Weekend Warrior',
        description: 'Complete a walk every weekend in March',
        startDate: now.subtract(const Duration(days: 90)),
        endDate: now.subtract(const Duration(days: 60)),
        type: ChallengeType.frequency,
        status: ChallengeStatus.completed,
        targetValue: 8,
        unit: 'walks',
        currentValue: 8,
        participants: ['user1', 'user2'],
        pointsReward: 200,
      ),
    ];
  }
}