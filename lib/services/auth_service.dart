import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

class AuthService {
  static const String _usersKey = 'quiz_master_users';
  static const String _currentUserKey = 'quiz_master_current_user';

  static Future<List<UserModel>> _getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> usersJson = prefs.getStringList(_usersKey) ?? [];
    return usersJson.map((e) => UserModel.fromJson(jsonDecode(e))).toList();
  }

  static Future<void> _saveUsers(List<UserModel> users) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> usersJson =
        users.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_usersKey, usersJson);
  }

  static Future<String?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final cleanEmail = email.trim().toLowerCase();
    final users = await _getUsers();

    if (users.any((u) => u.email.toLowerCase() == cleanEmail)) {
      return 'An account with this email already exists.';
    }

    final newUser = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name.trim(),
      email: cleanEmail,
      password: password,
    );

    users.add(newUser);
    await _saveUsers(users);

    // Auto login after registration
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentUserKey, jsonEncode(newUser.toJson()));
    return null; // Success
  }

  static Future<String?> login({
    required String email,
    required String password,
  }) async {
    final cleanEmail = email.trim().toLowerCase();
    final users = await _getUsers();

    final user = users.firstWhere(
      (u) => u.email.toLowerCase() == cleanEmail && u.password == password,
      orElse: () => UserModel(id: '', name: '', email: '', password: ''),
    );

    if (user.id.isEmpty) {
      return 'Invalid email or password.';
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentUserKey, jsonEncode(user.toJson()));
    return null; // Success
  }

  static Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userStr = prefs.getString(_currentUserKey);
    if (userStr == null || userStr.isEmpty) return null;

    try {
      return UserModel.fromJson(jsonDecode(userStr));
    } catch (_) {
      return null;
    }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
  }

  static Future<bool> isLoggedIn() async {
    final user = await getCurrentUser();
    return user != null;
  }

  static bool isSubscriptionStatusActive(String? rawStatus) {
    final status = rawStatus?.trim().toUpperCase() ?? '';
    if (status.isEmpty) return false;

    if (status == 'REGISTERED') return true;
    if (status.contains('PENDING')) return true;
    if (status == 'INITIAL CHARGING PENDING') return true;
    return false;
  }
}
