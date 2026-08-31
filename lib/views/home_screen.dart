import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../data/quiz_data.dart';
import '../services/storage_service.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import '../models/quiz_result.dart';
import '../widgets/category_card.dart';

const String _baseUrl = "https://www.bdappsdigitalapps.com/NADB26141/";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? _stats;
  List<QuizResult> _history = [];
  UserModel? _currentUser;
  String _userPhone = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final stats = await StorageService.getStats();
    final history = await StorageService.getHistory();
    final user = await AuthService.getCurrentUser();
    final prefs = await SharedPreferences.getInstance();
    final phone = prefs.getString('userPhone') ?? '';

    if (mounted) {
      setState(() {
        _stats = stats;
        _history = history;
        _currentUser = user;
        _userPhone = phone;
      });
    }
  }

  Future<void> _handleLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('userPhone');
    await AuthService.logout();
    await _loadData();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logged out successfully.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _unsubscribe() async {
    final prefs = await SharedPreferences.getInstance();
    final phone = prefs.getString('userPhone') ?? '';

    if (phone.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Phone not found!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (!mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Unsubscribing'),
        content: const Text('Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    if (!mounted) return;

    // Hold a reference to the loader dialog so we can reliably close it.
    bool loaderOpen = true;
    final loaderContext = context;
    showDialog<void>(
      context: loaderContext,
      barrierDismissible: false,
      builder: (dialogContext) => const PopScope(
        canPop: false,
        child: Center(child: CircularProgressIndicator()),
      ),
    );

    Future<void> closeLoader() async {
      if (!loaderOpen) return;
      loaderOpen = false;
      if (!mounted) return;
      // Guard against pop when no dialog actually exists on the navigator.
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    }

    try {
      final res = await http
          .post(
            Uri.parse('${_baseUrl}unsubscribe.php'),
            body: {'user_mobile': phone},
          )
          .timeout(const Duration(seconds: 15));

      if (!mounted) return;
      await closeLoader();

      if (res.statusCode != 200) {
        throw Exception('HTTP ${res.statusCode}');
      }

      final dynamic decoded = jsonDecode(res.body);
      if (decoded is! Map<String, dynamic>) {
        throw Exception('Unexpected response shape');
      }
      final data = decoded;
      final statusCode = data['statusCode']?.toString() ?? '';
      final statusDetail = data['statusDetail']?.toString() ?? '';
      final successFlag = data['success'] == true;
      final subscriptionStatus =
          (data['subscriptionStatus']?.toString() ?? '').toUpperCase();

      final success =
          successFlag ||
          statusCode == 'S1000' ||
          subscriptionStatus == 'UNREGISTERED';

      if (success) {
        // Clear auth state before navigating so the cold-start guard in
        // main.dart doesn't read a stale `isLoggedIn` flag.
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', false);
        await prefs.remove('userPhone');

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unsubscribing success!'),
            backgroundColor: Colors.green,
          ),
        );

        try {
          context.go('/login');
        } catch (_) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/login',
            (route) => false,
          );
        }
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(statusDetail.isNotEmpty
                ? statusDetail
                : 'Unsubscribing failed'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } on TimeoutException {
      if (!mounted) return;
      await closeLoader();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Timeout error!'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      await closeLoader();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Network error: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeController = QuizMasterApp.of(context).themeController;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Quiz Master', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(themeController.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => themeController.toggleTheme(),
            tooltip: 'Toggle Theme',
          ),
          if (_currentUser != null)
            PopupMenuButton<String>(
              icon: CircleAvatar(
                radius: 14,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Text(
                  _currentUser!.name.isNotEmpty ? _currentUser!.name[0].toUpperCase() : 'U',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
              onSelected: (value) {
                if (value == 'logout') {
                  _handleLogout();
                } else if (value == 'unsubscribe') {
                  _unsubscribe();
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  enabled: false,
                  child: Text(
                    _currentUser!.email,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ),
                const PopupMenuDivider(),
                const PopupMenuItem(
                  value: 'unsubscribe',
                  child: Row(
                    children: [
                      Icon(Icons.do_not_disturb_on_outlined, size: 18, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Unsubscribe', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                const PopupMenuItem(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout_rounded, size: 18),
                      SizedBox(width: 8),
                      Text('Log Out'),
                    ],
                  ),
                ),
              ],
            )
          else
            TextButton.icon(
              onPressed: () async {
                await context.push('/login');
                _loadData();
              },
              icon: const Icon(Icons.login_rounded, size: 18),
              label: const Text('Log In'),
            ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.psychology_rounded, size: 48, color: Colors.white),
                  const SizedBox(height: 12),
                  const Text(
                    'Quiz Master',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (_userPhone.isNotEmpty)
                    Text(
                      _userPhone,
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Home'),
              onTap: () => Navigator.pop(context),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.do_not_disturb_on_outlined, color: Colors.red),
              title: const Text(
                'Unsubscribe',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.pop(context);
                _unsubscribe();
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeSection(),
            const SizedBox(height: 24),
            _buildStatisticsSection(),
            const SizedBox(height: 24),
            const Text(
              'Categories',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildCategoriesGrid(),
            const SizedBox(height: 24),
            if (_history.isNotEmpty) ...[
              const Text(
                'Recent History',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildHistoryList(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    final title = _currentUser != null
        ? 'Welcome back, ${_currentUser!.name}! 👋'
        : 'Welcome to Quiz Master! 👋';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Test your knowledge and improve your learning skills.',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
            ),
          ),
          if (_currentUser == null) ...[
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () async {
                await context.push('/login');
                _loadData();
              },
              icon: const Icon(Icons.person_add_outlined, size: 18),
              label: const Text('Log In / Sign Up'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatisticsSection() {
    if (_stats == null) return const SizedBox.shrink();

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 0.8,
      children: [
        _buildStatCard('Attempts', _stats!['totalAttempts'].toString(), Icons.play_arrow_rounded),
        _buildStatCard('Highest', _stats!['highestScore'], Icons.emoji_events_rounded),
        _buildStatCard('Last', _stats!['lastScore'], Icons.history_rounded),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(fontSize: 12), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemCount: quizCategories.length,
      itemBuilder: (context, index) {
        return CategoryCard(category: quizCategories[index]);
      },
    );
  }

  Widget _buildHistoryList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _history.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final result = _history[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            child: Text('${index + 1}'),
          ),
          title: Text('Score: ${result.scoreDisplay}'),
          subtitle: Text('${result.percentage.toStringAsFixed(1)}%'),
          trailing: Text(
            '${result.date.day}/${result.date.month}/${result.date.year}',
            style: const TextStyle(fontSize: 12),
          ),
        );
      },
    );
  }
}
