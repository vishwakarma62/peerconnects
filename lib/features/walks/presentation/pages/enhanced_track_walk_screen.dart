import 'dart:async';
import 'package:flutter/material.dart';
import 'package:peer_connects/config/theme.dart';
import 'package:peer_connects/config/branding.dart';

class EnhancedTrackWalkScreen extends StatefulWidget {
  const EnhancedTrackWalkScreen({super.key});

  @override
  State<EnhancedTrackWalkScreen> createState() => _EnhancedTrackWalkScreenState();
}

class _EnhancedTrackWalkScreenState extends State<EnhancedTrackWalkScreen> with TickerProviderStateMixin {
  bool _isWalking = false;
  bool _isPaused = false;
  String _duration = '00:00:00';
  String _distance = '0.0';
  String _pace = '0\'00"';
  String _calories = '0';
  String _steps = '0';
  Timer? _timer;
  int _seconds = 0;
  double _animatedDistance = 0.0;
  
  // For map animation
  late AnimationController _mapAnimationController;
  late Animation<double> _mapAnimation;
  
  // For pulse animation on start/stop button
  late AnimationController _pulseAnimationController;
  late Animation<double> _pulseAnimation;
  
  // For weather information
  final String _temperature = '22°C';
  final String _weatherCondition = 'Sunny';
  final IconData _weatherIcon = Icons.wb_sunny;
  
  // For walk markers
  final List<String> _markers = [];
  
  @override
  void initState() {
    super.initState();
    
    // Setup map animation
    _mapAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _mapAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _mapAnimationController,
        curve: Curves.easeInOut,
      ),
    );
    
    // Setup pulse animation
    _pulseAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _pulseAnimationController,
        curve: Curves.easeInOut,
      ),
    );
    
    _pulseAnimationController.repeat(reverse: true);
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    _mapAnimationController.dispose();
    _pulseAnimationController.dispose();
    super.dispose();
  }
  
  void _toggleWalking() {
    setState(() {
      _isWalking = !_isWalking;
      _isPaused = false;
      
      if (_isWalking) {
        // Start tracking walk
        _startTracking();
      } else {
        // Stop tracking and save walk
        _stopTracking();
        _showWalkSummaryDialog();
      }
    });
  }
  
  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
      
      if (_isPaused) {
        _timer?.cancel();
      } else {
        _resumeTracking();
      }
    });
  }
  
  void _startTracking() {
    // Reset values
    _seconds = 0;
    _animatedDistance = 0.0;
    _markers.clear();
    
    // Start the timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
        
        // Update duration
        int hours = _seconds ~/ 3600;
        int minutes = (_seconds % 3600) ~/ 60;
        int secs = _seconds % 60;
        _duration = '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
        
        // Simulate distance increase
        _animatedDistance += 0.005; // Simulating 5m per second
        _distance = _animatedDistance.toStringAsFixed(2);
        
        // Update pace
        if (_animatedDistance > 0) {
          double paceValue = _seconds / 60 / _animatedDistance;
          int paceMinutes = paceValue.floor();
          int paceSeconds = ((paceValue - paceMinutes) * 60).round();
          _pace = "$paceMinutes'${paceSeconds.toString().padLeft(2, '0')}\"";
        }
        
        // Update calories (simple estimation)
        _calories = ((_animatedDistance * 60) + (_seconds / 60 * 5)).round().toString();
        
        // Update steps (rough estimation - about 1300 steps per km)
        _steps = ((_animatedDistance * 1300).round()).toString();
      });
    });
    
    // Animate map
    _mapAnimationController.forward();
  }
  
  void _resumeTracking() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
        
        // Update duration
        int hours = _seconds ~/ 3600;
        int minutes = (_seconds % 3600) ~/ 60;
        int secs = _seconds % 60;
        _duration = '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
        
        // Simulate distance increase
        _animatedDistance += 0.005; // Simulating 5m per second
        _distance = _animatedDistance.toStringAsFixed(2);
        
        // Update pace
        if (_animatedDistance > 0) {
          double paceValue = _seconds / 60 / _animatedDistance;
          int paceMinutes = paceValue.floor();
          int paceSeconds = ((paceValue - paceMinutes) * 60).round();
          _pace = "$paceMinutes'${paceSeconds.toString().padLeft(2, '0')}\"";
        }
        
        // Update calories
        _calories = ((_animatedDistance * 60) + (_seconds / 60 * 5)).round().toString();
        
        // Update steps
        _steps = ((_animatedDistance * 1300).round()).toString();
      });
    });
  }
  
  void _stopTracking() {
    _timer?.cancel();
    _mapAnimationController.stop();
  }
  
  void _addMarker() {
    setState(() {
      _markers.add('Marker at $_distance km');
      
      // Show a brief confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Marker added to your route'),
          duration: const Duration(seconds: 2),
          backgroundColor: AppTheme.primaryColor,
        ),
      );
    });
  }
  
  void _showWalkSummaryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Walk Summary'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Achievement banner (if applicable)
              if (_animatedDistance >= 1.0)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.emoji_events,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'New Achievement!',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.amber,
                              ),
                            ),
                            Text(
                              _animatedDistance >= 5.0
                                  ? '5K Milestone'
                                  : _animatedDistance >= 3.0
                                      ? '3K Milestone'
                                      : '1K Milestone',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              
              // Stats
              _buildSummaryItem('Duration', _duration, Icons.timer),
              const SizedBox(height: 16),
              _buildSummaryItem('Distance', '$_distance km', Icons.straighten),
              const SizedBox(height: 16),
              _buildSummaryItem('Avg. Pace', '$_pace /km', Icons.speed),
              const SizedBox(height: 16),
              _buildSummaryItem('Steps', _steps, Icons.directions_walk),
              const SizedBox(height: 16),
              _buildSummaryItem('Calories', '$_calories kcal', Icons.local_fire_department),
              
              // Weather info
              const SizedBox(height: 16),
              _buildSummaryItem('Weather', _temperature, _weatherIcon),
              
              // Markers section if any
              if (_markers.isNotEmpty) ...[
                const SizedBox(height: 24),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Your Markers',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                ...List.generate(
                  _markers.length,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.place,
                          size: 16,
                          color: Colors.red,
                        ),
                        const SizedBox(width: 8),
                        Text(_markers[index]),
                      ],
                    ),
                  ),
                ),
              ],
              
              // Share options
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildShareButton(Icons.share, 'Share'),
                  _buildShareButton(Icons.facebook, 'Facebook'),
                  _buildShareButton(Icons.camera_alt, 'Instagram'),
                ],
              ),
            ],
          ),
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
              
              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Walk saved successfully!'),
                  backgroundColor: AppTheme.primaryColor,
                ),
              );
            },
            style: AppTheme.primaryButtonStyle,
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildShareButton(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () {},
          icon: Icon(icon),
          color: AppTheme.primaryColor,
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
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
          // Weather banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: AppTheme.primaryColor.withOpacity(0.1),
            child: Row(
              children: [
                Icon(
                  _weatherIcon,
                  color: Colors.orange,
                ),
                const SizedBox(width: 8),
                Text(
                  '$_weatherCondition, $_temperature',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.location_on,
                  size: 16,
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(width: 4),
                const Text(
                  'GPS Signal: Strong',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          
          // Map placeholder with animation
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                // Map background
                Container(
                  color: Colors.grey[300],
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _mapAnimation,
                      builder: (context, child) {
                        return _isWalking
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.map,
                                    size: 64 + (_mapAnimation.value * 10),
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    _isPaused
                                        ? 'Walk Paused'
                                        : 'Tracking your walk...',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              )
                            : const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.map,
                                    size: 64,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'Ready to start walking',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              );
                      },
                    ),
                  ),
                ),
                
                // Markers overlay
                if (_markers.isNotEmpty)
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.place,
                            size: 16,
                            color: Colors.red,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${_markers.length} markers',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          // Stats panel with enhanced UI
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
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
                        _buildStatCard('Steps', _steps, Icons.directions_walk),
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
                      // Pause/Resume button (only shown when walking)
                      if (_isWalking)
                        AnimatedBuilder(
                          animation: _pulseAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _isPaused ? 1.0 : _pulseAnimation.value * 0.9,
                              child: FloatingActionButton(
                                onPressed: _togglePause,
                                backgroundColor: _isPaused ? Colors.green : Colors.orange,
                                child: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
                              ),
                            );
                          },
                        ),
                      
                      // Start/Stop button
                      AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _isWalking ? 1.0 : _pulseAnimation.value,
                            child: FloatingActionButton.large(
                              onPressed: _toggleWalking,
                              backgroundColor: _isWalking ? Colors.red : AppTheme.primaryColor,
                              child: Icon(_isWalking ? Icons.stop : Icons.play_arrow),
                            ),
                          );
                        },
                      ),
                      
                      // Add marker button (only shown when walking)
                      if (_isWalking)
                        FloatingActionButton(
                          onPressed: _addMarker,
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
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: AppTheme.primaryColor,
                size: 28,
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