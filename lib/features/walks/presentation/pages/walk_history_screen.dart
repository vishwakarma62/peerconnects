import 'package:flutter/material.dart';
import 'package:peer_connects/config/theme.dart';
import 'package:peer_connects/features/walks/presentation/pages/walk_details_screen.dart';

class WalkHistoryScreen extends StatelessWidget {
  const WalkHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Walk History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Show filter options
            },
          ),
        ],
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            // Stats summary card
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'This Month',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem(
                            context,
                            '12',
                            'Walks',
                            Icons.directions_walk,
                          ),
                          _buildStatItem(
                            context,
                            '24.5',
                            'Kilometers',
                            Icons.straighten,
                          ),
                          _buildStatItem(
                            context,
                            '4:30',
                            'Hours',
                            Icons.timer,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Tab bar
            const TabBar(
              tabs: [
                Tab(text: 'All'),
                Tab(text: 'Solo'),
                Tab(text: 'Group'),
              ],
              labelColor: AppTheme.primaryColor,
              unselectedLabelColor: AppTheme.secondaryTextColor,
              indicatorColor: AppTheme.primaryColor,
            ),
            
            // Tab content
            Expanded(
              child: TabBarView(
                children: [
                  _buildWalksList(context, 'all'),
                  _buildWalksList(context, 'solo'),
                  _buildWalksList(context, 'group'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String value,
    String label,
    IconData icon,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: AppTheme.primaryColor,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: AppTheme.secondaryTextColor,
          ),
        ),
      ],
    );
  }

  Widget _buildWalksList(BuildContext context, String type) {
    // Sample data - in a real app, this would come from a database
    final List<Map<String, dynamic>> walks = [
      {
        'date': 'Today',
        'time': '7:30 AM',
        'distance': '3.2',
        'duration': '32:45',
        'type': 'solo',
        'route': 'Morning Route',
      },
      {
        'date': 'Yesterday',
        'time': '6:15 PM',
        'distance': '2.8',
        'duration': '28:12',
        'type': 'group',
        'route': 'Evening Group Walk',
      },
      {
        'date': '2 days ago',
        'time': '8:00 AM',
        'distance': '4.5',
        'duration': '45:30',
        'type': 'solo',
        'route': 'Park Loop',
      },
      {
        'date': '3 days ago',
        'time': '7:00 AM',
        'distance': '3.0',
        'duration': '30:15',
        'type': 'group',
        'route': 'Community Walk',
      },
      {
        'date': '5 days ago',
        'time': '6:30 AM',
        'distance': '5.2',
        'duration': '52:40',
        'type': 'solo',
        'route': 'Long Route',
      },
    ];

    // Filter walks based on type
    final filteredWalks = type == 'all'
        ? walks
        : walks.where((walk) => walk['type'] == type).toList();

    return filteredWalks.isEmpty
        ? const Center(
            child: Text(
              'No walks found',
              style: TextStyle(color: AppTheme.secondaryTextColor),
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredWalks.length,
            itemBuilder: (context, index) {
              final walk = filteredWalks[index];
              return _buildWalkCard(context, walk);
            },
          );
  }

  Widget _buildWalkCard(BuildContext context, Map<String, dynamic> walk) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WalkDetailsScreen(walkData: walk),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date and type
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
                      const SizedBox(width: 8),
                      Text(
                        '${walk['date']} at ${walk['time']}',
                        style: const TextStyle(
                          color: AppTheme.secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: walk['type'] == 'solo'
                          ? Colors.blue.withOpacity(0.1)
                          : Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      walk['type'] == 'solo' ? 'Solo' : 'Group',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: walk['type'] == 'solo'
                            ? Colors.blue
                            : Colors.orange,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Route name
              Text(
                walk['route'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              
              // Stats
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildWalkStat(
                    context,
                    '${walk['distance']} km',
                    'Distance',
                    Icons.straighten,
                  ),
                  _buildWalkStat(
                    context,
                    walk['duration'],
                    'Duration',
                    Icons.timer,
                  ),
                  _buildWalkStat(
                    context,
                    '${(double.parse(walk['distance']) / (double.parse(walk['duration'].split(':')[0]) / 60 + double.parse(walk['duration'].split(':')[1]) / 3600)).toStringAsFixed(1)} km/h',
                    'Avg. Speed',
                    Icons.speed,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWalkStat(
    BuildContext context,
    String value,
    String label,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppTheme.primaryColor,
          size: 20,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.secondaryTextColor,
          ),
        ),
      ],
    );
  }
}