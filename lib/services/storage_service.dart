import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quiz_result.dart';

class StorageService {
  static const String _themeKey = 'isDarkMode';
  static const String _totalAttemptsKey = 'totalAttempts';
  static const String _highestScoreKey = 'highestScore';
  static const String _lastScoreKey = 'lastScore';
  static const String _historyKey = 'quizHistory';

  static Future<bool> isDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeKey) ?? false;
  }

  static Future<void> setDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, value);
  }

  static Future<Map<String, dynamic>> getStats() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'totalAttempts': prefs.getInt(_totalAttemptsKey) ?? 0,
      'highestScore': prefs.getString(_highestScoreKey) ?? '0/0',
      'lastScore': prefs.getString(_lastScoreKey) ?? '0/0',
    };
  }

  static Future<void> saveResult(QuizResult result) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Update attempts
    int attempts = prefs.getInt(_totalAttemptsKey) ?? 0;
    await prefs.setInt(_totalAttemptsKey, attempts + 1);

    // Update last score
    await prefs.setString(_lastScoreKey, result.scoreDisplay);

    // Update highest score
    String highestScoreStr = prefs.getString(_highestScoreKey) ?? "0/0";
    int currentHighest = _parseScore(highestScoreStr);
    if (result.correctAnswers > currentHighest) {
       await prefs.setString(_highestScoreKey, result.scoreDisplay);
    }

    // Update history (last 10)
    List<String> history = prefs.getStringList(_historyKey) ?? [];
    history.insert(0, jsonEncode(result.toJson()));
    if (history.length > 10) {
      history = history.sublist(0, 10);
    }
    await prefs.setStringList(_historyKey, history);
  }

  static Future<List<QuizResult>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList(_historyKey) ?? [];
    return history.map((e) => QuizResult.fromJson(jsonDecode(e))).toList();
  }

  static int _parseScore(String score) {
    try {
      return int.parse(score.split('/')[0]);
    } catch (_) {
      return 0;
    }
  }
}
