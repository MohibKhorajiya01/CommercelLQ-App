import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/database_helper.dart';

final bookmarkedCoursesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  return DatabaseHelper.instance.getBookmarkedCourses();
});

final bookmarkedLessonsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  return DatabaseHelper.instance.getBookmarkedLessons();
});
