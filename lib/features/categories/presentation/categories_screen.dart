import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import 'categories_provider.dart';
import '../../../../core/widgets/custom_badge.dart';
import '../../../../core/widgets/difficulty_dot.dart';
import '../../../../core/widgets/bookmark_button.dart';

class CategoriesScreen extends ConsumerWidget {
  final int categoryId;
  const CategoriesScreen({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryAsync = ref.watch(categoryDetailProvider(categoryId));
    final coursesAsync = ref.watch(coursesByCategoryProvider(categoryId));
    final currentFilter = ref.watch(categoryFilterProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: categoryAsync.when(
          data: (category) => Text(category?['name'] ?? 'Category'),
          loading: () => const Text('Loading...'),
          error: (e, stack) => const Text('Error'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterRow(ref, currentFilter),
          const SizedBox(height: 8),
          Expanded(
            child: coursesAsync.when(
              data: (courses) {
                if (courses.isEmpty) {
                  return const Center(child: Text('No guides found for this filter.'));
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    return _buildCourseCard(context, ref, courses[index])
                        .animate()
                        .fade(duration: 400.ms)
                        .slideY(begin: 0.1, duration: 400.ms, delay: (index * 50).ms);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, stack) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterRow(WidgetRef ref, String currentFilter) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _buildFilterChip(ref, 'all', 'ALL GUIDES', null, currentFilter == 'all'),
          const SizedBox(width: 8),
          _buildFilterChip(ref, 'high_impact', 'HIGH ROI', Icons.trending_up, currentFilter == 'high_impact'),
          const SizedBox(width: 8),
          _buildFilterChip(ref, 'beginner', 'QUICK SETUP', Icons.flash_on, currentFilter == 'beginner'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(WidgetRef ref, String filterValue, String label, IconData? icon, bool isSelected) {
    return GestureDetector(
      onTap: () => ref.read(categoryFilterProvider.notifier).state = filterValue,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryPurple : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primaryPurple : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.white : AppColors.mutedGrey,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.mutedGrey,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseCard(BuildContext context, WidgetRef ref, Map<String, dynamic> course) {
    final isBookmarked = ref.watch(courseBookmarkProvider(course['id']));

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: () => context.push('/course/${course['id']}'),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.lightPurpleBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(course['emoji'], style: const TextStyle(fontSize: 28)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(course['title'], style: AppTextStyles.heading4),
                        const SizedBox(height: 4),
                        if (course['badge_label'] != null)
                          CustomBadge(
                            label: course['badge_label'],
                            type: course['badge_type'],
                          ),
                      ],
                    ),
                  ),
                  BookmarkButton(
                    isBookmarked: isBookmarked,
                    onTap: () => ref.read(courseBookmarkProvider(course['id']).notifier).toggle(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                course['description'] ?? '',
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('EXPECTED ROI', style: AppTextStyles.labelSmall),
                        const SizedBox(height: 4),
                        DifficultyDot(
                          label: course['expected_roi'] ?? '-',
                          difficulty: 'beginner', // Using green dot for ROI per spec
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('DIFFICULTY', style: AppTextStyles.labelSmall),
                        const SizedBox(height: 4),
                        DifficultyDot(
                          label: course['difficulty'] != null 
                            ? course['difficulty']![0].toUpperCase() + course['difficulty']!.substring(1)
                            : '-',
                          difficulty: course['difficulty'],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.push('/course/${course['id']}'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lightPurpleBg,
                    foregroundColor: AppColors.primaryPurple,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Explore Business Plan →', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
