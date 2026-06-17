import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/database_helper.dart';

final courseDetailProvider = FutureProvider.family<Map<String, dynamic>?, int>((ref, courseId) async {
  return DatabaseHelper.instance.getCourseById(courseId);
});

final courseLessonsProvider = FutureProvider.family<List<Map<String, dynamic>>, int>((ref, courseId) async {
  return DatabaseHelper.instance.getLessonsByCourse(courseId);
});

final courseProgressProvider = FutureProvider.family<List<Map<String, dynamic>>, int>((ref, courseId) async {
  return DatabaseHelper.instance.getCourseProgress(courseId);
});
