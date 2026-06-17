import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/database_helper.dart';

final recentlyViewedProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  return DatabaseHelper.instance.getRecentlyViewed(limit: 5);
});

final featuredCoursesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  return DatabaseHelper.instance.getFeaturedCourses(limit: 3);
});

final lastAccessedCourseProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  return DatabaseHelper.instance.getLastAccessedCourse();
});

final categoriesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  return DatabaseHelper.instance.getCategories();
});
