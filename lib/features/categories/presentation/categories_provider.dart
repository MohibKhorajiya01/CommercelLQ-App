import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/database_helper.dart';
import '../../bookmarks/presentation/bookmarks_provider.dart';

final categoryDetailProvider = FutureProvider.family<Map<String, dynamic>?, int>((ref, categoryId) async {
  return DatabaseHelper.instance.getCategoryById(categoryId);
});

final categoryFilterProvider = StateProvider<String>((ref) => 'all');

final coursesByCategoryProvider = FutureProvider.family<List<Map<String, dynamic>>, int>((ref, categoryId) async {
  final filter = ref.watch(categoryFilterProvider);
  return DatabaseHelper.instance.getCoursesByCategoryFiltered(categoryId, filter);
});


final courseBookmarkProvider = StateNotifierProvider.family<BookmarkNotifier, bool, int>((ref, courseId) {
  return BookmarkNotifier(courseId, ref);
});

class BookmarkNotifier extends StateNotifier<bool> {
  final int courseId;
  final Ref ref;
  
  BookmarkNotifier(this.courseId, this.ref) : super(false) {
    _init();
  }

  Future<void> _init() async {
    state = await DatabaseHelper.instance.isCourseBookmarked(courseId);
  }

  Future<void> toggle() async {
    await DatabaseHelper.instance.toggleCourseBookmark(courseId);
    state = !state;
    ref.invalidate(bookmarkedCoursesProvider);
  }
}
