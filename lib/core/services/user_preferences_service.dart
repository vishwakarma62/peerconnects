import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:peer_connects/features/auth/domain/entities/user_entity.dart';

class UserPreferencesService {
  static const String _userKey = 'user_data';
  static const String _tokenKey = 'auth_token';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _themeKey = 'app_theme';
  static const String _notificationsKey = 'notifications_enabled';
  static const String _lastLoginKey = 'last_login';

  // Save user data
  Future<bool> saveUser(UserEntity user) async {
    final prefs = await SharedPreferences.getInstance();
    final userData = {
      'id': user.id,
      'email': user.email,
      'name': user.name,
      'photoUrl': user.photoUrl,
    };
    return await prefs.setString(_userKey, jsonEncode(userData));
  }

  // Get user data
  Future<UserEntity?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString(_userKey);
    
    if (userString == null) {
      return null;
    }
    
    try {
      final userData = jsonDecode(userString) as Map<String, dynamic>;
      return UserEntity(
        id: userData['id'] as String,
        email: userData['email'] as String,
        name: userData['name'] as String?,
        photoUrl: userData['photoUrl'] as String?,
      );
    } catch (e) {
      return null;
    }
  }

  // Save authentication token
  Future<bool> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString(_tokenKey, token);
  }

  // Get authentication token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Set logged in status
  Future<bool> setLoggedIn(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    if (isLoggedIn) {
      await prefs.setString(_lastLoginKey, DateTime.now().toIso8601String());
    }
    return await prefs.setBool(_isLoggedInKey, isLoggedIn);
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // Get last login time
  Future<DateTime?> getLastLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final lastLoginString = prefs.getString(_lastLoginKey);
    if (lastLoginString == null) {
      return null;
    }
    return DateTime.parse(lastLoginString);
  }

  // Save theme preference
  Future<bool> saveThemePreference(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(_themeKey, isDarkMode);
  }

  // Get theme preference
  Future<bool> isDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeKey) ?? false;
  }

  // Save notification preference
  Future<bool> saveNotificationPreference(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(_notificationsKey, enabled);
  }

  // Get notification preference
  Future<bool> areNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationsKey) ?? true;
  }

  // Clear all user data (for logout)
  Future<bool> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_tokenKey);
    await prefs.setBool(_isLoggedInKey, false);
    await prefs.remove(_lastLoginKey);
    // Don't clear theme and notification preferences
    return true;
  }
}