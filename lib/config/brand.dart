import 'package:flutter/material.dart';

/// Brand configuration for Peer Connects
/// This class centralizes all brand-related constants and configurations
class PeerConnectsBrand {
  // Brand name variations
  static const String appName = 'Peer Connects';
  static const String shortName = 'PeerC';
  static const String tagline = 'Walk Together, Connect Better';
  static const String slogan = 'Every Step Connects';
  
  // Brand voice guidelines
  static const String voiceDescription = 'Friendly, motivating, community-focused, and health-conscious';
  
  // Brand mission
  static const String mission = 'To create meaningful connections through walking and outdoor activities';
  
  // Brand values
  static const List<String> values = [
    'Community', 'Health', 'Connection', 'Sustainability', 'Inclusivity'
  ];
  
  // App store descriptions
  static const String shortDescription = 'Connect with walkers in your community and track your walks together.';
  static const String longDescription = 'Peer Connects helps you find walking buddies, join community walks, '
      'track your progress, and build meaningful connections while improving your health.';
  
  // Social media handles
  static const String twitterHandle = '@PeerConnects';
  static const String instagramHandle = '@peerconnects';
  static const String facebookPage = 'PeerConnectsApp';
  
  // Contact information
  static const String supportEmail = 'support@peerconnects.com';
  static const String contactPhone = '+1-800-PEER-APP';
  
  // App version format
  static String getVersionText(String version, int buildNumber) {
    return 'Version $version ($buildNumber)';
  }
  
  // Copyright text
  static String getCopyrightText(int year) {
    return '© $year Peer Connects. All rights reserved.';
  }
  
  // Brand typography scale
  static const TextStyle displayLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
  );
  
  static const TextStyle displayMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
  );
  
  static const TextStyle displaySmall = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
  
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
  );
  
  static const TextStyle headlineMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );
  
  static const TextStyle headlineSmall = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );
  
  static const TextStyle titleLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
  
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
  );
}