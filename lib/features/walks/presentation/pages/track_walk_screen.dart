import 'package:flutter/material.dart';
import 'package:peer_connects/config/theme.dart';

class TrackWalkScreen extends StatefulWidget {
  const TrackWalkScreen({super.key});

  @override
  State<TrackWalkScreen> createState() => _TrackWalkScreenState();
}

class _TrackWalkScreenState extends State<TrackWalkScreen> {
  bool _isWalking = false;
  String _duration = '00:00:00';
  String _distance = '0.0';
  String _pace = '0\'00"';
  String _calories = '0';

  void _toggleWalking() {
    setState(() {
      _isWalking = !_isWalking;
      if (_isWalking) {
        // Start tracking walk
        // In a real app, you would start location tracking here
        _duration = '00:00:01';
        _distance = '0.1';
        _pace = '10\'00"';
        _calories = '5';
      } else {
        // Stop tracking and save walk
        _showWalkSummaryDialog();
      }
    });
  }

  void _showWalkSummaryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Walk Summary'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSummaryItem('Duration', _duration, Icons.timer),
            const SizedBox(height: 16),
            _buildSummaryItem('Distance', '$_distance km', Icons.straighten),
            const SizedBox(height: 16),
            _buildSummaryItem('Avg. Pace', '$_pace /km', Icons.speed),
            const SizedBox(height: 16),
            _buildSummaryItem('Calories', '$_calories kcal', Icons.local_fire_department),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Discard'),
          ),
          ElevatedButton(
            onPressed: () {
              // Save walk data
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: AppTheme.primaryButtonStyle,
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.secondaryTextColor,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Walk'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Open walk settings
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Map placeholder
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.grey[300],
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.map,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Map View',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isWalking ? 'Tracking your walk...' : 'Ready to start walking',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Stats panel
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Stats row
                  Expanded(
                    child: Row(
                      children: [
                        _buildStatCard('Duration', _duration, Icons.timer),
                        const SizedBox(width: 16),
                        _buildStatCard('Distance', '$_distance km', Icons.straighten),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Stats row
                  Expanded(
                    child: Row(
                      children: [
                        _buildStatCard('Avg. Pace', _pace, Icons.speed),
                        const SizedBox(width: 16),
                        _buildStatCard('Calories', '$_calories kcal', Icons.local_fire_department),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Control buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Pause button (only shown when walking)
                      if (_isWalking)
                        FloatingActionButton(
                          onPressed: () {
                            // Pause walk
                          },
                          backgroundColor: Colors.orange,
                          child: const Icon(Icons.pause),
                        ),
                      // Start/Stop button
                      FloatingActionButton.large(
                        onPressed: _toggleWalking,
                        backgroundColor: _isWalking ? Colors.red : AppTheme.primaryColor,
                        child: Icon(_isWalking ? Icons.stop : Icons.play_arrow),
                      ),
                      // Add marker button (only shown when walking)
                      if (_isWalking)
                        FloatingActionButton(
                          onPressed: () {
                            // Add marker at current location
                          },
                          backgroundColor: Colors.blue,
                          child: const Icon(Icons.add_location),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: AppTheme.primaryColor,
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
          ),
        ),
      ),
    );
  }
}