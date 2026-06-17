import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import 'bookmarks_provider.dart';

class BookmarksScreen extends ConsumerWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.bookmarks),
      ),
      body: const _BookmarkedCoursesList(),
    );
  }
}

class _BookmarkedCoursesList extends ConsumerWidget {
  const _BookmarkedCoursesList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesAsync = ref.watch(bookmarkedCoursesProvider);

    return coursesAsync.when(
      data: (courses) {
        if (courses.isEmpty) {
          return const Center(
            child: Text(AppStrings.noBookmarks, textAlign: TextAlign.center),
          );
        }
        return RefreshIndicator(
          onRefresh: () async => ref.invalidate(bookmarkedCoursesProvider),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: Text(course['emoji'], style: const TextStyle(fontSize: 24)),
                  title: Text(course['title'], style: AppTextStyles.labelLarge),
                  subtitle: Text(course['description'] ?? '', maxLines: 2, overflow: TextOverflow.ellipsis),
                  onTap: () => context.push('/course/${course['id']}'),
                ),
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

