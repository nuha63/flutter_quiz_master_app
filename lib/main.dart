import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'router/app_router.dart';
import 'controllers/theme_controller.dart';

// BDApps Base URL: https://www.bdappsdigitalapps.com/NADB26141/
const String bdappsBaseUrl = "https://www.bdappsdigitalapps.com/NADB26141/";


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(
    QuizMasterApp(isLoggedIn: isLoggedIn),
  );
}

class QuizMasterApp extends StatefulWidget {
  final bool isLoggedIn;

  const QuizMasterApp({
    super.key,
    required this.isLoggedIn,
  });

  static _QuizMasterAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_QuizMasterAppState>()!;

  @override
  State<QuizMasterApp> createState() => _QuizMasterAppState();
}

class _QuizMasterAppState extends State<QuizMasterApp> {
  final ThemeController _themeController = ThemeController();

  ThemeController get themeController => _themeController;

  late final _router = AppRouter.createRouter(
    initialLocation: widget.isLoggedIn ? '/home' : '/login',
  );

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _themeController,
      builder: (context, _) {
        return MaterialApp.router(
          title: 'Quiz Master',
          debugShowCheckedModeBanner: false,
          themeMode: _themeController.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: Colors.blue,
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: Colors.blue,
            brightness: Brightness.dark,
          ),
          routerConfig: _router,
        );
      },
    );
  }
}
