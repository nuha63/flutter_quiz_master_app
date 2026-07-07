import 'package:go_router/go_router.dart';
import '../views/home_screen.dart';
import '../views/quiz_screen.dart';
import '../views/result_screen.dart';
import '../models/quiz_category.dart';
import '../models/quiz_result.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/quiz',
        builder: (context, state) {
          final category = state.extra as QuizCategory;
          return QuizScreen(category: category);
        },
      ),
      GoRoute(
        path: '/result',
        builder: (context, state) {
          final result = state.extra as QuizResult;
          return ResultScreen(result: result);
        },
      ),
    ],
  );
}
