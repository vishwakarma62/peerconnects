import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peer_connects/config/theme.dart';
import 'package:peer_connects/core/di/injection_container.dart' as di;
import 'package:peer_connects/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:peer_connects/features/auth/presentation/bloc/auth_event.dart';
import 'package:peer_connects/features/auth/presentation/pages/splash_screen.dart';
import 'package:peer_connects/features/gamification/presentation/pages/achievements_screen.dart';
import 'package:peer_connects/features/gamification/presentation/pages/challenges_screen.dart';
import 'package:peer_connects/features/gamification/presentation/pages/leaderboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di.sl<AuthBloc>()
            ..add(const AuthCheckRequested()),
        ),
      ],
      child: MaterialApp(
        title: 'Peer Connects',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const SplashScreen(),
        routes: {
          '/achievements': (context) => const AchievementsScreen(),
          '/challenges': (context) => const ChallengesScreen(),
          '/leaderboard': (context) => const LeaderboardScreen(),
        },
      ),
    );
  }
}