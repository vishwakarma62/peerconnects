import 'package:flutter/material.dart';
import 'package:peer_connects/config/theme.dart';
import 'package:peer_connects/features/gamification/domain/entities/challenge_entity.dart';

/// A widget that displays a challenge card
class ChallengeCard extends StatelessWidget {
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final IconData icon;
  final Color color;
  final double? progress;
  final String? currentValue;
  final String? targetValue;
  final String? unit;
  final int? participants;
  final ChallengeStatus status;
  final VoidCallback? onJoin;
  final VoidCallback? onLeave;
  final VoidCallback? onDetails;
  final VoidCallback? onLogProgress;

  const ChallengeCard({
    super.key,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.icon,
    required this.color,
    this.progress,
    this.currentValue,
    this.targetValue,
    this.unit,
    this.participants,
    required this.status,
    this.onJoin,
    this.onLeave,
    this.onDetails,
    this.onLogProgress,
  });

  /// Create from a ChallengeEntity
  factory ChallengeCard.fromEntity(
    ChallengeEntity challenge, {
    VoidCallback? onJoin,
    VoidCallback? onLeave,
    VoidCallback? onDetails,
    VoidCallback? onLogProgress,
  }) {
    return ChallengeCard(
      title: challenge.title,
      description: challenge.description,
      startDate: challenge.startDate,
      endDate: challenge.endDate,
      icon: challenge.typeIcon,
      color: challenge.typeColor,
      progress: challenge.progress,
      currentValue: challenge.currentValue?.toString(),
      targetValue: challenge.targetValue.toString(),
      unit: challenge.unit,
      participants: challenge.participantCount,
      status: challenge.status,
      onJoin: onJoin,
      onLeave: onLeave,
      onDetails: onDetails,
      onLogProgress: onLogProgress,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isActive = status == ChallengeStatus.active;
    final bool isUpcoming = status == ChallengeStatus.upcoming;
    final bool isCompleted = status == ChallengeStatus.completed;
    
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
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
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
            
            // Progress section for active challenges
            if (isActive && progress != null) ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Progress: ${(progress! * 100).toInt()}%',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (currentValue != null && targetValue != null)
                        Text(
                          '$currentValue/$targetValue ${unit ?? ''}',
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
                      value: progress,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
            
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
                      _formatDateRange(startDate, endDate),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.secondaryTextColor,
                      ),
                    ),
                  ],
                ),
                if (participants != null)
                  Row(
                    children: [
                      const Icon(
                        Icons.people,
                        size: 16,
                        color: AppTheme.secondaryTextColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$participants participants',
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
                  onPressed: onDetails,
                  icon: const Icon(Icons.info_outline),
                  label: const Text('Details'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: color,
                    side: BorderSide(color: color),
                  ),
                ),
                if (isActive)
                  ElevatedButton.icon(
                    onPressed: onLogProgress,
                    icon: const Icon(Icons.add),
                    label: const Text('Log Progress'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.white,
                    ),
                  )
                else if (isUpcoming)
                  ElevatedButton.icon(
                    onPressed: onJoin,
                    icon: const Icon(Icons.add),
                    label: const Text('Join Challenge'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.white,
                    ),
                  )
                else if (isCompleted)
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.share),
                    label: const Text('Share Results'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: color,
                      side: BorderSide(color: color),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  /// Format date range as a string
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
  
  /// Get month name from month number
  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}