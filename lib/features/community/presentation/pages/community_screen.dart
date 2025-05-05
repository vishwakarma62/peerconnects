import 'package:flutter/material.dart';
import 'package:peer_connects/config/theme.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Community'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // Search functionality
              },
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Groups'),
              Tab(text: 'Events'),
              Tab(text: 'Nearby'),
            ],
            labelColor: AppTheme.primaryColor,
            unselectedLabelColor: AppTheme.secondaryTextColor,
            indicatorColor: AppTheme.primaryColor,
          ),
        ),
        body: TabBarView(
          children: [
            _buildGroupsTab(),
            _buildEventsTab(),
            _buildNearbyTab(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Create new group or event
          },
          backgroundColor: AppTheme.primaryColor,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildGroupsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildGroupCard(
          'Morning Walk Group',
          'For early risers who enjoy morning walks',
          24,
          true,
        ),
        const SizedBox(height: 16),
        _buildGroupCard(
          'Senior Citizens Walk',
          'Gentle walks for seniors in the community',
          18,
          false,
        ),
        const SizedBox(height: 16),
        _buildGroupCard(
          'Weekend Walkers',
          'Group for weekend walking enthusiasts',
          32,
          true,
        ),
        const SizedBox(height: 16),
        _buildGroupCard(
          'Nature Trails',
          'Explore nature trails and parks together',
          15,
          false,
        ),
        const SizedBox(height: 16),
        _buildGroupCard(
          'Evening Strollers',
          'Relaxing evening walks after work',
          22,
          false,
        ),
      ],
    );
  }

  Widget _buildEventsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildEventCard(
          'Community Walkathon',
          'Saturday, 8:00 AM',
          'Central Park',
          'A 5km walkathon to promote fitness in the community',
          45,
        ),
        const SizedBox(height: 16),
        _buildEventCard(
          'Sunrise Walk',
          'Sunday, 6:30 AM',
          'Riverside Park',
          'Enjoy the beautiful sunrise while walking with friends',
          12,
        ),
        const SizedBox(height: 16),
        _buildEventCard(
          'Charity Walk',
          'Next Friday, 9:00 AM',
          'Downtown',
          'Walk to raise funds for the local children\'s hospital',
          78,
        ),
        const SizedBox(height: 16),
        _buildEventCard(
          'Nature Trail Exploration',
          'Next Saturday, 10:00 AM',
          'Forest Hills',
          'Explore the hidden trails of Forest Hills',
          20,
        ),
      ],
    );
  }

  Widget _buildNearbyTab() {
    return Column(
      children: [
        // Map view
        Container(
          height: 200,
          color: Colors.grey[300],
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.map,
                  size: 48,
                  color: Colors.grey,
                ),
                SizedBox(height: 8),
                Text(
                  'Map View',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Nearby walkers and events',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Nearby walkers list
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 16.0),
                child: Text(
                  'Walkers Nearby',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildNearbyPersonCard('John Smith', '0.5 km away', '4.8'),
              _buildNearbyPersonCard('Sarah Johnson', '0.8 km away', '4.9'),
              _buildNearbyPersonCard('Michael Brown', '1.2 km away', '4.7'),
              _buildNearbyPersonCard('Emma Wilson', '1.5 km away', '4.6'),
              _buildNearbyPersonCard('David Lee', '2.0 km away', '4.8'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGroupCard(
    String name,
    String description,
    int members,
    bool isJoined,
  ) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.group,
                    color: AppTheme.primaryColor,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.people,
                            size: 16,
                            color: AppTheme.secondaryTextColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$members members',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppTheme.secondaryTextColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.secondaryTextColor,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    // View group details
                  },
                  icon: const Icon(Icons.visibility),
                  label: const Text('View'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryColor,
                    side: const BorderSide(color: AppTheme.primaryColor),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Join or leave group
                  },
                  icon: Icon(isJoined ? Icons.check : Icons.add),
                  label: Text(isJoined ? 'Joined' : 'Join'),
                  style: isJoined
                      ? ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.black87,
                        )
                      : AppTheme.primaryButtonStyle,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventCard(
    String name,
    String time,
    String location,
    String description,
    int participants,
  ) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.event,
                    color: Colors.orange,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 16,
                            color: AppTheme.secondaryTextColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            time,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppTheme.secondaryTextColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  size: 16,
                  color: AppTheme.secondaryTextColor,
                ),
                const SizedBox(width: 4),
                Text(
                  location,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.secondaryTextColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.secondaryTextColor,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.people,
                      size: 16,
                      color: AppTheme.secondaryTextColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$participants going',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.secondaryTextColor,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Join event
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Join'),
                  style: AppTheme.primaryButtonStyle,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNearbyPersonCard(
    String name,
    String distance,
    String rating,
  ) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: AppTheme.primaryColor.withOpacity(0.2),
              child: Text(
                name[0],
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 14,
                        color: AppTheme.secondaryTextColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        distance,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.secondaryTextColor,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Icon(
                        Icons.star,
                        size: 14,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        rating,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            OutlinedButton(
              onPressed: () {
                // Connect with person
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.primaryColor,
                side: const BorderSide(color: AppTheme.primaryColor),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                minimumSize: const Size(0, 36),
              ),
              child: const Text('Connect'),
            ),
          ],
        ),
      ),
    );
  }
}