import 'package:flutter/material.dart';
import 'package:peer_connects/config/theme.dart';

/// A screen that displays the global leaderboard
class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  bool _isLoading = false;
  String _timeFilter = 'All Time';
  
  @override
  void initState() {
    super.initState();
    _loadLeaderboard();
  }
  
  Future<void> _loadLeaderboard() async {
    setState(() {
      _isLoading = true;
    });
    
    // In a real app, you would load the leaderboard from a repository
    await Future.delayed(const Duration(seconds: 1));
    
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _timeFilter = value;
                _loadLeaderboard();
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'All Time',
                child: Text('All Time'),
              ),
              const PopupMenuItem(
                value: 'This Week',
                child: Text('This Week'),
              ),
              const PopupMenuItem(
                value: 'This Month',
                child: Text('This Month'),
              ),
            ],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(_timeFilter),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildLeaderboard(),
    );
  }

  Widget _buildLeaderboard() {
    // In a real app, you would get this from a BLoC or provider
    final leaderboardEntries = _getMockLeaderboardEntries();
    
    return Column(
      children: [
        // Top 3 podium
        Container(
          padding: const EdgeInsets.symmetric(vertical: 24),
          color: AppTheme.primaryColor.withOpacity(0.1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // 2nd place
              if (leaderboardEntries.length > 1)
                _buildPodiumItem(
                  leaderboardEntries[1],
                  2,
                  Colors.grey[400]!,
                  120,
                )
              else
                const SizedBox(width: 80),
              
              // 1st place
              if (leaderboardEntries.isNotEmpty)
                _buildPodiumItem(
                  leaderboardEntries[0],
                  1,
                  Colors.amber,
                  150,
                )
              else
                const SizedBox(width: 80),
              
              // 3rd place
              if (leaderboardEntries.length > 2)
                _buildPodiumItem(
                  leaderboardEntries[2],
                  3,
                  Colors.brown[300]!,
                  100,
                )
              else
                const SizedBox(width: 80),
            ],
          ),
        ),
        
        // Rest of the leaderboard
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 16),
            itemCount: leaderboardEntries.length - 3,
            itemBuilder: (context, index) {
              final entry = leaderboardEntries[index + 3];
              final rank = index + 4;
              
              return ListTile(
                leading: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$rank',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
                title: Text(entry.name),
                subtitle: Text('Level ${entry.level}'),
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
                      '${entry.points}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  // View user profile
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPodiumItem(
    LeaderboardEntry entry,
    int rank,
    Color color,
    double height,
  ) {
    return Column(
      children: [
        // User avatar
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: rank == 1 ? 40 : 30,
              backgroundColor: color.withOpacity(0.3),
              child: CircleAvatar(
                radius: rank == 1 ? 36 : 26,
                backgroundColor: Colors.white,
                child: Text(
                  entry.initials,
                  style: TextStyle(
                    fontSize: rank == 1 ? 24 : 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Text(
                '$rank',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        
        // User name
        Text(
          entry.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        
        // Points
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.star,
              color: Colors.amber,
              size: 16,
            ),
            const SizedBox(width: 2),
            Text(
              '${entry.points}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        
        // Podium
        Container(
          width: 80,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          ),
          alignment: Alignment.center,
          child: Text(
            '$rank',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
      ],
    );
  }

  // Mock data for demonstration
  List<LeaderboardEntry> _getMockLeaderboardEntries() {
    return [
      LeaderboardEntry(
        id: 'user1',
        name: 'Sarah Johnson',
        initials: 'SJ',
        points: 3250,
        level: 8,
      ),
      LeaderboardEntry(
        id: 'user2',
        name: 'Mike Chen',
        initials: 'MC',
        points: 2980,
        level: 7,
      ),
      LeaderboardEntry(
        id: 'user3',
        name: 'Emma Wilson',
        initials: 'EW',
        points: 2750,
        level: 7,
      ),
      LeaderboardEntry(
        id: 'user4',
        name: 'David Kim',
        initials: 'DK',
        points: 2500,
        level: 6,
      ),
      LeaderboardEntry(
        id: 'user5',
        name: 'Lisa Garcia',
        initials: 'LG',
        points: 2350,
        level: 6,
      ),
      LeaderboardEntry(
        id: 'user6',
        name: 'John Smith',
        initials: 'JS',
        points: 2100,
        level: 5,
      ),
      LeaderboardEntry(
        id: 'user7',
        name: 'Alex Taylor',
        initials: 'AT',
        points: 1950,
        level: 5,
      ),
      LeaderboardEntry(
        id: 'user8',
        name: 'Olivia Brown',
        initials: 'OB',
        points: 1800,
        level: 4,
      ),
      LeaderboardEntry(
        id: 'user9',
        name: 'Ryan Lee',
        initials: 'RL',
        points: 1650,
        level: 4,
      ),
      LeaderboardEntry(
        id: 'user10',
        name: 'Sophia Martinez',
        initials: 'SM',
        points: 1500,
        level: 3,
      ),
    ];
  }
}

class LeaderboardEntry {
  final String id;
  final String name;
  final String initials;
  final int points;
  final int level;

  LeaderboardEntry({
    required this.id,
    required this.name,
    required this.initials,
    required this.points,
    required this.level,
  });
}