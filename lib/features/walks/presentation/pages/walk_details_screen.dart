import 'package:flutter/material.dart';
import 'package:peer_connects/config/theme.dart';

class WalkDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> walkData;

  const WalkDetailsScreen({
    super.key,
    required this.walkData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Walk Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Share walk details
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Show more options
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Map view
            Container(
              height: 200,
              color: Colors.grey[300],
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.map,
                      size: 48,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Map View',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      walkData['route'],
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Walk summary
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Walk name and date
                  Text(
                    walkData['route'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: AppTheme.secondaryTextColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${walkData['date']} at ${walkData['time']}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppTheme.secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Stats cards
                  Row(
                    children: [
                      _buildStatCard(
                        context,
                        '${walkData['distance']} km',
                        'Distance',
                        Icons.straighten,
                      ),
                      const SizedBox(width: 16),
                      _buildStatCard(
                        context,
                        walkData['duration'],
                        'Duration',
                        Icons.timer,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildStatCard(
                        context,
                        '${(double.parse(walkData['distance']) / (double.parse(walkData['duration'].split(':')[0]) / 60 + double.parse(walkData['duration'].split(':')[1]) / 3600)).toStringAsFixed(1)} km/h',
                        'Avg. Speed',
                        Icons.speed,
                      ),
                      const SizedBox(width: 16),
                      _buildStatCard(
                        context,
                        '${(double.parse(walkData['distance']) * 60).toInt()}',
                        'Calories',
                        Icons.local_fire_department,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Walk type
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: walkData['type'] == 'solo'
                          ? Colors.blue.withOpacity(0.1)
                          : Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          walkData['type'] == 'solo'
                              ? Icons.person
                              : Icons.group,
                          color: walkData['type'] == 'solo'
                              ? Colors.blue
                              : Colors.orange,
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              walkData['type'] == 'solo'
                                  ? 'Solo Walk'
                                  : 'Group Walk',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: walkData['type'] == 'solo'
                                    ? Colors.blue
                                    : Colors.orange,
                              ),
                            ),
                            Text(
                              walkData['type'] == 'solo'
                                  ? 'You walked alone'
                                  : 'You walked with 3 others',
                              style: TextStyle(
                                fontSize: 14,
                                color: walkData['type'] == 'solo'
                                    ? Colors.blue.withOpacity(0.7)
                                    : Colors.orange.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Elevation chart
                  const Text(
                    'Elevation',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        'Elevation Chart',
                        style: TextStyle(
                          color: AppTheme.secondaryTextColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Pace chart
                  const Text(
                    'Pace',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        'Pace Chart',
                        style: TextStyle(
                          color: AppTheme.secondaryTextColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Notes section
                  const Text(
                    'Notes',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: const Text(
                      'No notes added for this walk. Tap to add notes.',
                      style: TextStyle(
                        color: AppTheme.secondaryTextColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String value,
    String label,
    IconData icon,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
    );
  }
}