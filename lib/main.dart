import 'package:flutter/material.dart';
import 'router/app_router.dart';
import 'controllers/theme_controller.dart';

void main() {
  runApp(const QuizMasterApp());
}

class QuizMasterApp extends StatefulWidget {
  const QuizMasterApp({super.key});

  static _QuizMasterAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_QuizMasterAppState>()!;

  @override
  State<QuizMasterApp> createState() => _QuizMasterAppState();
}

class _QuizMasterAppState extends State<QuizMasterApp> {
  final ThemeController _themeController = ThemeController();

  ThemeController get themeController => _themeController;

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
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}
