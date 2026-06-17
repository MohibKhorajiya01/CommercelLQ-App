import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import 'search_provider.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(searchQueryProvider);
    final resultsAsync = ref.watch(searchResultsProvider);

    return Scaffold(
      backgroundColor: AppColors.pageBg,
      body: SafeArea(
        child: Column(
          children: [
            // Floating Search Bar
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryPurple.withValues(alpha: 0.1),
                    blurRadius: 15,
                    spreadRadius: 2,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: TextField(
                autofocus: true,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  hintText: AppStrings.searchPlaceholder,
                  hintStyle: const TextStyle(color: AppColors.mutedGrey),
                  prefixIcon: IconButton(
                    icon: const Icon(Icons.arrow_back, color: AppColors.darkNavy),
                    onPressed: () => context.pop(),
                  ),
                  suffixIcon: query.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: AppColors.mutedGrey),
                          onPressed: () => ref.read(searchQueryProvider.notifier).state = '',
                        )
                      : const Icon(Icons.search, color: AppColors.mutedGrey),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onChanged: (val) => ref.read(searchQueryProvider.notifier).state = val,
              ),
            ),
            
            // Search Results or Empty State
            Expanded(
              child: query.trim().isEmpty
                  ? _buildEmptyState()
                  : resultsAsync.when(
                      data: (results) {
                        final courses = results['courses'] as List<Map<String, dynamic>>;
                        final lessons = results['lessons'] as List<Map<String, dynamic>>;

                        if (courses.isEmpty && lessons.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.search_off_rounded, size: 64, color: AppColors.border),
                                const SizedBox(height: 16),
                                Text(AppStrings.noResults, style: AppTextStyles.heading3.copyWith(color: AppColors.mutedGrey)),
                              ],
                            ),
                          );
                        }

                        return ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          physics: const BouncingScrollPhysics(),
                          children: [
                            if (courses.isNotEmpty) ...[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12, left: 4),
                                child: Text('COURSES', style: AppTextStyles.labelSmall.copyWith(color: AppColors.mutedGrey)),
                              ),
                              ...courses.map((c) => _buildCourseResult(context, c)),
                              const SizedBox(height: 24),
                            ],
                            if (lessons.isNotEmpty) ...[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12, left: 4),
                                child: Text('LESSONS', style: AppTextStyles.labelSmall.copyWith(color: AppColors.mutedGrey)),
                              ),
                              ...lessons.map((l) => _buildLessonResult(context, l)),
                            ],
                          ],
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Center(child: Text('Error: $e')),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.lightPurpleBg,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.search_rounded, size: 48, color: AppColors.primaryPurple),
          ),
          const SizedBox(height: 24),
          const Text(
            'What do you want to learn?',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 8),
          const Text(
            'Search for Shopify, Dropshipping, or FBA...',
            style: TextStyle(color: AppColors.mutedGrey, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseResult(BuildContext context, Map<String, dynamic> course) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: InkWell(
        onTap: () => context.push('/course/${course['id']}'),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.lightPurpleBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(child: Text(course['emoji'], style: const TextStyle(fontSize: 24))),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(course['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 4),
                    Text(
                      course['description'] ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AppColors.mutedGrey, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.border),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLessonResult(BuildContext context, Map<String, dynamic> lesson) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: InkWell(
        onTap: () => context.push('/lesson/${lesson['id']}'),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryPurple.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.play_lesson_rounded, color: AppColors.primaryPurple, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(lesson['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 4),
                    Text(
                      'Course: ${lesson['course_title']}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AppColors.primaryPurple, fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
