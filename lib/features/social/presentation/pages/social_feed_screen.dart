import 'package:flutter/material.dart';
import 'package:peer_connects/config/theme.dart';

class SocialFeedScreen extends StatefulWidget {
  const SocialFeedScreen({super.key});

  @override
  State<SocialFeedScreen> createState() => _SocialFeedScreenState();
}

class _SocialFeedScreenState extends State<SocialFeedScreen> {
  final List<Map<String, dynamic>> _posts = [
    {
      'userId': '1',
      'userName': 'Sarah Johnson',
      'userAvatar': null,
      'timeAgo': '15 minutes ago',
      'content': 'Just completed my morning 5K walk! Beautiful sunrise today.',
      'image': 'assets/images/sample_walk_1.jpg',
      'walkStats': {
        'distance': '5.2 km',
        'duration': '52:30',
        'steps': '6,845',
      },
      'likes': 24,
      'comments': 5,
      'isLiked': false,
    },
    {
      'userId': '2',
      'userName': 'Mike Peterson',
      'userAvatar': null,
      'timeAgo': '1 hour ago',
      'content': 'Joined the "Weekend Walkers" group today. Looking forward to meeting new walking buddies!',
      'image': null,
      'walkStats': null,
      'likes': 18,
      'comments': 3,
      'isLiked': true,
    },
    {
      'userId': '3',
      'userName': 'Emma Wilson',
      'userAvatar': null,
      'timeAgo': '3 hours ago',
      'content': 'Reached my 100km monthly goal! So proud of my progress.',
      'image': 'assets/images/sample_achievement.jpg',
      'walkStats': {
        'achievement': 'Monthly 100K',
        'level': 'Gold',
      },
      'likes': 42,
      'comments': 8,
      'isLiked': false,
    },
    {
      'userId': '4',
      'userName': 'David Lee',
      'userAvatar': null,
      'timeAgo': 'Yesterday',
      'content': 'Found this amazing trail in the city park. Perfect for morning walks!',
      'image': 'assets/images/sample_trail.jpg',
      'walkStats': {
        'location': 'City Park Trail',
        'difficulty': 'Easy',
        'length': '3.5 km',
      },
      'likes': 31,
      'comments': 12,
      'isLiked': false,
    },
    {
      'userId': '5',
      'userName': 'Morning Walk Group',
      'userAvatar': null,
      'timeAgo': 'Yesterday',
      'content': 'Join us for our weekly sunrise walk this Saturday at 6:30 AM. Meeting point: Central Park entrance.',
      'image': 'assets/images/sample_group_walk.jpg',
      'walkStats': {
        'event': 'Weekly Sunrise Walk',
        'time': 'Saturday, 6:30 AM',
        'location': 'Central Park',
        'participants': '15',
      },
      'likes': 27,
      'comments': 9,
      'isLiked': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Social Feed'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Search functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Filter posts
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Refresh feed
          await Future.delayed(const Duration(seconds: 1));
          setState(() {
            // In a real app, you would fetch new posts here
          });
        },
        child: ListView.builder(
          itemCount: _posts.length,
          itemBuilder: (context, index) {
            final post = _posts[index];
            return _buildPostCard(post);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Create new post
        },
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildPostCard(Map<String, dynamic> post) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post header
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // User avatar
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppTheme.primaryColor.withOpacity(0.2),
                  child: Text(
                    post['userName'][0],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // User name and time
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post['userName'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        post['timeAgo'],
                        style: const TextStyle(
                          color: AppTheme.secondaryTextColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                // More options
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {
                    // Show post options
                  },
                ),
              ],
            ),
          ),

          // Post content
          if (post['content'] != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                post['content'],
                style: const TextStyle(fontSize: 16),
              ),
            ),

          // Post image
          if (post['image'] != null)
            Container(
              height: 200,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 8),
              color: Colors.grey[300],
              child: const Center(
                child: Icon(
                  Icons.image,
                  size: 48,
                  color: Colors.grey,
                ),
              ),
            ),

          // Walk stats
          if (post['walkStats'] != null)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: _buildWalkStats(post['walkStats']),
            ),

          // Post actions
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton(
                  icon: post['isLiked'] ? Icons.favorite : Icons.favorite_border,
                  label: '${post['likes']}',
                  color: post['isLiked'] ? Colors.red : null,
                  onPressed: () {
                    setState(() {
                      final isLiked = post['isLiked'] as bool;
                      post['isLiked'] = !isLiked;
                      post['likes'] = isLiked ? post['likes'] - 1 : post['likes'] + 1;
                    });
                  },
                ),
                _buildActionButton(
                  icon: Icons.comment_outlined,
                  label: '${post['comments']}',
                  onPressed: () {
                    // Show comments
                  },
                ),
                _buildActionButton(
                  icon: Icons.share_outlined,
                  label: 'Share',
                  onPressed: () {
                    // Share post
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWalkStats(Map<String, dynamic> stats) {
    if (stats.containsKey('distance')) {
      // Regular walk stats
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(Icons.straighten, stats['distance'], 'Distance'),
          _buildStatItem(Icons.timer, stats['duration'], 'Duration'),
          _buildStatItem(Icons.directions_walk, stats['steps'], 'Steps'),
        ],
      );
    } else if (stats.containsKey('achievement')) {
      // Achievement stats
      return Row(
        children: [
          const Icon(
            Icons.emoji_events,
            color: Colors.amber,
            size: 36,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                stats['achievement'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                '${stats['level']} Achievement',
                style: const TextStyle(
                  color: AppTheme.secondaryTextColor,
                ),
              ),
            ],
          ),
        ],
      );
    } else if (stats.containsKey('location') && stats.containsKey('length')) {
      // Trail stats
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.place,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(width: 8),
              Text(
                stats['location'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildStatItem(Icons.straighten, stats['length'], 'Length'),
              const SizedBox(width: 16),
              _buildStatItem(Icons.signal_cellular_alt, stats['difficulty'], 'Difficulty'),
            ],
          ),
        ],
      );
    } else if (stats.containsKey('event')) {
      // Event stats
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.event,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(width: 8),
              Text(
                stats['event'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildStatItem(Icons.access_time, stats['time'], 'Time'),
              const SizedBox(width: 16),
              _buildStatItem(Icons.place, stats['location'], 'Location'),
              const SizedBox(width: 16),
              _buildStatItem(Icons.people, stats['participants'], 'Participants'),
            ],
          ),
        ],
      );
    }
    
    return const SizedBox.shrink();
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
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
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.secondaryTextColor,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    Color? color,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: color ?? AppTheme.secondaryTextColor,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: color ?? AppTheme.secondaryTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}