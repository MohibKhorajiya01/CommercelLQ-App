import 'package:go_router/go_router.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/categories/presentation/categories_screen.dart';
import '../../features/course_detail/presentation/course_detail_screen.dart';
import '../../features/lesson/presentation/lesson_screen.dart';
import '../../features/search/presentation/search_screen.dart';
import '../../features/bookmarks/presentation/bookmarks_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';

import 'package:flutter/material.dart';

CustomTransitionPage<void> _buildPageWithDefaultTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        )),
        child: child,
      );
    },
  );
}

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const SplashScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
      ),
    ),
    GoRoute(
      path: '/home',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
      ),
    ),
    GoRoute(
      path: '/categories/:id',
      pageBuilder: (context, state) {
        final categoryId = int.parse(state.pathParameters['id']!);
        return _buildPageWithDefaultTransition(context: context, state: state, child: CategoriesScreen(categoryId: categoryId));
      },
    ),
    GoRoute(
      path: '/course/:id',
      pageBuilder: (context, state) {
        final courseId = int.parse(state.pathParameters['id']!);
        return _buildPageWithDefaultTransition(context: context, state: state, child: CourseDetailScreen(courseId: courseId));
      },
    ),
    GoRoute(
      path: '/lesson/:id',
      pageBuilder: (context, state) {
        final lessonId = int.parse(state.pathParameters['id']!);
        return _buildPageWithDefaultTransition(context: context, state: state, child: LessonScreen(lessonId: lessonId));
      },
    ),
    GoRoute(
      path: '/search',
      pageBuilder: (context, state) => _buildPageWithDefaultTransition(context: context, state: state, child: const SearchScreen()),
    ),
    GoRoute(
      path: '/bookmarks',
      pageBuilder: (context, state) => _buildPageWithDefaultTransition(context: context, state: state, child: const BookmarksScreen()),
    ),
    GoRoute(
      path: '/profile',
      pageBuilder: (context, state) => _buildPageWithDefaultTransition(context: context, state: state, child: const ProfileScreen()),
    ),
  ],
);
