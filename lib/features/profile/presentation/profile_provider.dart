import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/database_helper.dart';

final profileStatsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final db = DatabaseHelper.instance;
  final completedCourses = await db.getCompletedCoursesCount();
  final completedLessons = await db.getCompletedLessonsCount();
  
  // For hours learned, let's estimate 15 mins per completed lesson
  final hoursLearned = (completedLessons * 15) ~/ 60;
  
  return {
    'completed_courses': completedCourses,
    'completed_lessons': completedLessons,
    'hours_learned': hoursLearned,
    'day_streak': 3, // Mock value
  };
});

final inProgressCoursesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  return DatabaseHelper.instance.getInProgressCourses();
});
