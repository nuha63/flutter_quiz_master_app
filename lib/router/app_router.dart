import 'package:go_router/go_router.dart';
import '../views/home_screen.dart';
import '../views/quiz_screen.dart';
import '../views/result_screen.dart';
import '../views/login_screen.dart';
import '../models/quiz_category.dart';
import '../models/quiz_result.dart';

class AppRouter {
  static GoRouter createRouter({String initialLocation = '/'}) {
    return GoRouter(
      initialLocation: initialLocation,
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginPage(),
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

  static final router = createRouter();
}
