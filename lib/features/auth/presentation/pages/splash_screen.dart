import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peer_connects/config/theme.dart';
import 'package:peer_connects/core/services/user_preferences_service.dart';
import 'package:peer_connects/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:peer_connects/features/auth/presentation/bloc/auth_state.dart';
import 'package:peer_connects/features/auth/presentation/pages/welcome_screen.dart';
import 'package:peer_connects/features/walks/presentation/pages/home_screen.dart';
import 'package:peer_connects/core/di/injection_container.dart' as di;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final UserPreferencesService _preferencesService = di.sl<UserPreferencesService>();
  bool _isCheckingAuth = true;
  
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }
  
  _navigateToNextScreen() async {
    // First check shared preferences for faster startup
    final isLoggedIn = await _preferencesService.isLoggedIn();
    
    // Wait for minimum splash screen time
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;
    
    if (isLoggedIn) {
      // If logged in according to preferences, navigate to home screen
      // The AuthBloc will still verify with Firebase in the background
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    } else {
              Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const WelcomeScreen(),
          ),
        );
      
      // If not logged in, wait for AuthBloc to confirm
      setState(() {
        _isCheckingAuth = false;
      });
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        print('Auth state changed: $state');
        // Only handle navigation if we haven't already navigated based on preferences
        if (!_isCheckingAuth) {
          if (state.isAuthenticated) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
            );
          } else if (state.isUnauthenticated) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const WelcomeScreen(),
              ),
            );
          }
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.primaryColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App logo
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(
                  Icons.directions_walk,
                  size: 80,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 24),
              // App name
              const Text(
                'Peer Connects',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              // Tagline
              const Text(
                'Connect with walkers in your community',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 48),
              // Loading indicator
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}