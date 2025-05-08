import 'package:flutter/material.dart';
import 'package:peer_connects/config/theme.dart';

class ChallengesScreen extends StatefulWidget {
  const ChallengesScreen({super.key});

  @override
  State<ChallengesScreen> createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends State<ChallengesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  final List<Map<String, dynamic>> _activeChallenges = [
    {
      'id': '1',
      'title': '30-Day Walking Streak',
      'description': 'Walk at least 1 km every day for 30 days',
      'startDate': 'May 1, 2023',
      'endDate': 'May 30, 2023',
      'progress': 0.6, // 60% complete
      'currentValue': '18',
      'targetValue': '30',
      'unit': 'days',
      'participants': 245,
      'type': 'streak',
      'icon': Icons.calendar_today,
      'color': Colors.blue,
    },
    {
      'id': '2',
      'title': 'Weekly Distance Challenge',
      'description': 'Walk 25 km this week',
      'startDate': 'May 15, 2023',
      'endDate': 'May 21, 2023',
      'progress': 0.72, // 72% complete
      'currentValue': '18.1',
      'targetValue': '25',
      'unit': 'km',
      'participants': 156,
      'type': 'distance',
      'icon': Icons.straighten,
      'color': AppTheme.primaryColor,
    },
    {
      'id': '3',
      'title': 'Community Explorer',
      'description': 'Join 3 different community walks this month',
      'startDate': 'May 1, 2023',
      'endDate': 'May 31, 2023',
      'progress': 0.33, // 33% complete
      'currentValue': '1',
      'targetValue': '3',
      'unit': 'walks',
      'participants': 89,
      'type': 'social',
      'icon': Icons.groups,
      'color': Colors.orange,
    },
  ];
  
  final List<Map<String, dynamic>> _upcomingChallenges = [
    {
      'id': '4',
      'title': 'Summer Step Challenge',
      'description': 'Reach 300,000 steps in June',
      'startDate': 'June 1, 2023',
      'endDate': 'June 30, 2023',
      'participants': 312,
      'type': 'steps',
      'icon': Icons.directions_walk,
      'color': Colors.purple,
    },
    {
      'id': '5',
      'title': 'Sunrise Walkers',
      'description': 'Complete 10 morning walks before 8 AM',
      'startDate': 'June 1, 2023',
      'endDate': 'June 30, 2023',
      'participants': 78,
      'type': 'time',
      'icon': Icons.wb_sunny,
      'color': Colors.amber,
    },
  ];
  
  final List<Map<String, dynamic>> _completedChallenges = [
    {
      'id': '6',
      'title': 'Spring Step Up',
      'description': 'Walk 100 km in April',
      'startDate': 'April 1, 2023',
      'endDate': 'April 30, 2023',
      'result': 'Completed: 112.5 km',
      'rank': '24th',
      'participants': 189,
      'reward': 'Gold Badge',
      'type': 'distance',
      'icon': Icons.straighten,
      'color': Colors.green,
    },
    {
      'id': '7',
      'title': 'Weekend Warrior',
      'description': 'Complete a walk every weekend in March',
      'startDate': 'March 1, 2023',
      'endDate': 'March 31, 2023',
      'result': 'Completed: 8/8 weekends',
      'rank': '5th',
      'participants': 134,
      'reward': 'Platinum Badge',
      'type': 'streak',
      'icon': Icons.calendar_today,
      'color': Colors.blue,
    },
  ];

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
          _buildActiveChallenges(),
          _buildUpcomingChallenges(),
          _buildCompletedChallenges(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Create or join a challenge
        },
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildActiveChallenges() {
    return _activeChallenges.isEmpty
        ? _buildEmptyState('No active challenges', 'Join a challenge to get started')
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _activeChallenges.length,
            itemBuilder: (context, index) {
              final challenge = _activeChallenges[index];
              return _buildActiveChallengeCard(challenge);
            },
          );
  }

  Widget _buildUpcomingChallenges() {
    return _upcomingChallenges.isEmpty
        ? _buildEmptyState('No upcoming challenges', 'Check back later for new challenges')
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _upcomingChallenges.length,
            itemBuilder: (context, index) {
              final challenge = _upcomingChallenges[index];
              return _buildUpcomingChallengeCard(challenge);
            },
          );
  }

  Widget _buildCompletedChallenges() {
    return _completedChallenges.isEmpty
        ? _buildEmptyState('No completed challenges', 'Complete challenges to see them here')
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _completedChallenges.length,
            itemBuilder: (context, index) {
              final challenge = _completedChallenges[index];
              return _buildCompletedChallengeCard(challenge);
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
            },
            style: AppTheme.primaryButtonStyle,
            child: const Text('Browse Challenges'),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveChallengeCard(Map<String, dynamic> challenge) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Challenge header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: challenge['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    challenge['icon'],
                    color: challenge['color'],
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        challenge['title'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        challenge['description'],
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
            
            const SizedBox(height: 16),
            
            // Progress section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Progress: ${(challenge['progress'] * 100).toInt()}%',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${challenge['currentValue']}/${challenge['targetValue']} ${challenge['unit']}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: challenge['progress'],
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(challenge['color']),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Date and participants
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: AppTheme.secondaryTextColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${challenge['startDate']} - ${challenge['endDate']}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.secondaryTextColor,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.people,
                      size: 16,
                      color: AppTheme.secondaryTextColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${challenge['participants']} participants',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    // View challenge details
                  },
                  icon: const Icon(Icons.info_outline),
                  label: const Text('Details'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: challenge['color'],
                    side: BorderSide(color: challenge['color']),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Log progress
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Log Progress'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: challenge['color'],
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingChallengeCard(Map<String, dynamic> challenge) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Challenge header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: challenge['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    challenge['icon'],
                    color: challenge['color'],
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        challenge['title'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        challenge['description'],
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
            
            const SizedBox(height: 16),
            
            // Date and participants
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: AppTheme.secondaryTextColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${challenge['startDate']} - ${challenge['endDate']}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.secondaryTextColor,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.people,
                      size: 16,
                      color: AppTheme.secondaryTextColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${challenge['participants']} participants',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Countdown
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.access_time,
                    size: 16,
                    color: AppTheme.secondaryTextColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Starts in 7 days',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    // View challenge details
                  },
                  icon: const Icon(Icons.info_outline),
                  label: const Text('Details'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: challenge['color'],
                    side: BorderSide(color: challenge['color']),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Join challenge
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Join Challenge'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: challenge['color'],
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletedChallengeCard(Map<String, dynamic> challenge) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Challenge header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: challenge['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    challenge['icon'],
                    color: challenge['color'],
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        challenge['title'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        challenge['description'],
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
            
            const SizedBox(height: 16),
            
            // Result and rank
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Result',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.secondaryTextColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          challenge['result'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Rank',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.secondaryTextColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          challenge['rank'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Reward
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.emoji_events,
                    color: Colors.amber,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Reward Earned',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.secondaryTextColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        challenge['reward'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Date and participants
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: AppTheme.secondaryTextColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${challenge['startDate']} - ${challenge['endDate']}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.secondaryTextColor,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.people,
                      size: 16,
                      color: AppTheme.secondaryTextColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${challenge['participants']} participants',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    // View challenge details
                  },
                  icon: const Icon(Icons.info_outline),
                  label: const Text('Details'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: challenge['color'],
                    side: BorderSide(color: challenge['color']),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    // Share results
                  },
                  icon: const Icon(Icons.share),
                  label: const Text('Share Results'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: challenge['color'],
                    side: BorderSide(color: challenge['color']),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}