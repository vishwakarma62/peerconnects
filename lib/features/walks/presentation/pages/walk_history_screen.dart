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
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Show filter options
              _showFilterBottomSheet(context);
            },
          ),
        ],
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            // Stats summary card with enhanced design
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                shadowColor: AppTheme.primaryColor.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [
                        Colors.white,
                        AppTheme.primaryColor.withOpacity(0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'This Month',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 14,
                                  color: AppTheme.primaryColor,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'May 2023',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem(
                            context,
                            '12',
                            'Walks',
                            Icons.directions_walk,
                          ),
                          _buildDivider(),
                          _buildStatItem(
                            context,
                            '24.5',
                            'Kilometers',
                            Icons.straighten,
                          ),
                          _buildDivider(),
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
            
            // Enhanced Tab bar
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TabBar(
                tabs: [
                  _buildTab('All', Icons.list_alt),
                  _buildTab('Solo', Icons.person),
                  _buildTab('Group', Icons.group),
                ],
                labelColor: AppTheme.primaryColor,
                unselectedLabelColor: AppTheme.secondaryTextColor,
                indicatorColor: AppTheme.primaryColor,
                indicatorWeight: 3,
                indicatorSize: TabBarIndicatorSize.label,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
              ),
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

  Widget _buildTab(String text, IconData icon) {
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 6),
          Text(text),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.grey.withOpacity(0.3),
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
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryColor.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
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
            fontSize: 20,
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
        'calories': '245',
        'steps': '4,320',
      },
      {
        'date': 'Yesterday',
        'time': '6:15 PM',
        'distance': '2.8',
        'duration': '28:12',
        'type': 'group',
        'route': 'Evening Group Walk',
        'calories': '210',
        'steps': '3,850',
      },
      {
        'date': '2 days ago',
        'time': '8:00 AM',
        'distance': '4.5',
        'duration': '45:30',
        'type': 'solo',
        'route': 'Park Loop',
        'calories': '340',
        'steps': '6,100',
      },
      {
        'date': '3 days ago',
        'time': '7:00 AM',
        'distance': '3.0',
        'duration': '30:15',
        'type': 'group',
        'route': 'Community Walk',
        'calories': '225',
        'steps': '4,050',
      },
      {
        'date': '5 days ago',
        'time': '6:30 AM',
        'distance': '5.2',
        'duration': '52:40',
        'type': 'solo',
        'route': 'Long Route',
        'calories': '395',
        'steps': '7,200',
      },
    ];

    // Filter walks based on type
    final filteredWalks = type == 'all'
        ? walks
        : walks.where((walk) => walk['type'] == type).toList();

    return filteredWalks.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.directions_walk_outlined,
                  size: 64,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 16),
                Text(
                  'No walks found',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Start walking to see your history here',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredWalks.length,
            itemBuilder: (context, index) {
              final walk = filteredWalks[index];
              return _buildEnhancedWalkCard(context, walk);
            },
          );
  }

  Widget _buildEnhancedWalkCard(BuildContext context, Map<String, dynamic> walk) {
    final bool isGroupWalk = walk['type'] == 'group';
    final Color cardColor = isGroupWalk ? Colors.orange : Colors.blue;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WalkDetailsScreen(walkData: walk),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: cardColor.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Card(
            margin: EdgeInsets.zero,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: cardColor.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with gradient
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        cardColor,
                        cardColor.withOpacity(0.7),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                ),
                
                Padding(
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
                              Icon(
                                Icons.calendar_today,
                                size: 16,
                                color: cardColor,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${walk['date']} at ${walk['time']}',
                                style: TextStyle(
                                  color: cardColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: cardColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isGroupWalk ? Icons.group : Icons.person,
                                  size: 14,
                                  color: cardColor,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  isGroupWalk ? 'Group' : 'Solo',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: cardColor,
                                  ),
                                ),
                              ],
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
                      const SizedBox(height: 16),
                      
                      // Stats
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildWalkStat(
                            context,
                            '${walk['distance']} km',
                            'Distance',
                            Icons.straighten,
                            cardColor,
                          ),
                          _buildWalkStat(
                            context,
                            walk['duration'],
                            'Duration',
                            Icons.timer,
                            cardColor,
                          ),
                          _buildWalkStat(
                            context,
                            '${walk['calories']}',
                            'Calories',
                            Icons.local_fire_department,
                            cardColor,
                          ),
                          _buildWalkStat(
                            context,
                            walk['steps'],
                            'Steps',
                            Icons.directions_walk,
                            cardColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
    Color color,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 20,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filter Walks',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Date Range',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _buildFilterChip('This Week', true),
                  const SizedBox(width: 8),
                  _buildFilterChip('This Month', false),
                  const SizedBox(width: 8),
                  _buildFilterChip('Custom', false),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Walk Type',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _buildFilterChip('All', true),
                  const SizedBox(width: 8),
                  _buildFilterChip('Solo', false),
                  const SizedBox(width: 8),
                  _buildFilterChip('Group', false),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Distance',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _buildFilterChip('All', true),
                  const SizedBox(width: 8),
                  _buildFilterChip('< 3 km', false),
                  const SizedBox(width: 8),
                  _buildFilterChip('3-5 km', false),
                  const SizedBox(width: 8),
                  _buildFilterChip('> 5 km', false),
                ],
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: AppTheme.primaryButtonStyle,
                  child: const Text('Apply Filters'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (bool selected) {},
      backgroundColor: Colors.grey.shade200,
      selectedColor: AppTheme.primaryColor.withOpacity(0.2),
      checkmarkColor: AppTheme.primaryColor,
      labelStyle: TextStyle(
        color: isSelected ? AppTheme.primaryColor : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}