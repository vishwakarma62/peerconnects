import 'package:flutter/material.dart';

/// Branding configuration for Peer Connects
class AppBranding {
  // App name and tagline
  static const String appName = 'Peer Connects';
  static const String tagline = 'Walk Together, Connect Better';
  static const String slogan = 'Every Step Connects';
  static const String shortDescription = 'The premier social walking app that connects communities';
  
  // Brand voice guidelines
  static const String brandVoice = '''
  - Friendly and encouraging
  - Community-focused
  - Health-positive without being preachy
  - Inclusive and accessible to all fitness levels
  - Motivational and inspiring
  ''';
  
  // Brand mission and vision
  static const String mission = 'To create meaningful connections through walking and outdoor activities';
  static const String vision = 'A world where walking brings communities together for better health and stronger relationships';
  
  // Brand values
  static const List<String> values = [
    'Community', 'Health', 'Connection', 'Sustainability', 'Inclusivity'
  ];
  
  // Logo configurations
  static const double logoSizeSmall = 48.0;
  static const double logoSizeMedium = 80.0;
  static const double logoSizeLarge = 120.0;
  
  // Animation durations
  static const Duration shortAnimation = Duration(milliseconds: 300);
  static const Duration mediumAnimation = Duration(milliseconds: 500);
  static const Duration longAnimation = Duration(milliseconds: 800);
  
  // App store information
  static const String appStoreId = 'com.peerconnects.app';
  static const String playStoreId = 'com.peerconnects.app';
  
  // Social media handles
  static const String twitterHandle = '@peerconnects';
  static const String instagramHandle = '@peerconnects';
  static const String facebookPage = 'PeerConnectsApp';
  
  // Brand assets helper methods
  static Widget logo({double size = logoSizeMedium, Color? color}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color ?? AppBrandColors.primary,
        borderRadius: BorderRadius.circular(size * 0.25),
      ),
      child: Icon(
        Icons.directions_walk,
        size: size * 0.7,
        color: Colors.white,
      ),
    );
  }
  
  static Widget logoWithText({double logoSize = logoSizeMedium, double fontSize = 24, Color? color}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        logo(size: logoSize, color: color),
        const SizedBox(height: 12),
        Text(
          appName,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: color ?? AppBrandColors.primary,
          ),
        ),
      ],
    );
  }
}

/// Brand colors for Peer Connects
class AppBrandColors {
  // Primary palette
  static const Color primary = Color(0xFF4CAF50);
  static const Color primaryLight = Color(0xFF81C784);
  static const Color primaryDark = Color(0xFF2E7D32);
  
  // Secondary palette
  static const Color secondary = Color(0xFF03A9F4);
  static const Color secondaryLight = Color(0xFF4FC3F7);
  static const Color secondaryDark = Color(0xFF0288D1);
  
  // Accent colors
  static const Color accent = Color(0xFFFF9800);
  static const Color accentLight = Color(0xFFFFB74D);
  static const Color accentDark = Color(0xFFF57C00);
  
  // Semantic colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);
  
  // Gradient definitions
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryLight, primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondaryLight, secondary, secondaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    colors: [accentLight, accent, accentDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}