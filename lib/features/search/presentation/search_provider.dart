import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/database_helper.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider = FutureProvider<Map<String, List<Map<String, dynamic>>>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.trim().isEmpty) return {'courses': [], 'lessons': []};

  final db = DatabaseHelper.instance;
  final courses = await db.searchCourses(query);
  final lessons = await db.searchLessons(query);

  return {
    'courses': courses,
    'lessons': lessons,
  };
});
