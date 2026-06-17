import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_strings.dart';
import 'course_detail_provider.dart';
import '../../../../features/categories/presentation/categories_provider.dart'; // For bookmark provider
import '../../../core/widgets/custom_badge.dart';
import '../../../core/widgets/progress_card.dart';
import '../../../core/widgets/bookmark_button.dart';
import '../../../core/database/database_helper.dart';

class CourseDetailScreen extends ConsumerStatefulWidget {
  final int courseId;
  const CourseDetailScreen({super.key, required this.courseId});

  @override
  ConsumerState<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends ConsumerState<CourseDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Record recently viewed
    DatabaseHelper.instance.addRecentlyViewed(courseId: widget.courseId);
  }

  @override
  Widget build(BuildContext context) {
    final courseAsync = ref.watch(courseDetailProvider(widget.courseId));
    final lessonsAsync = ref.watch(courseLessonsProvider(widget.courseId));
    final progressAsync = ref.watch(courseProgressProvider(widget.courseId));
    final isBookmarked = ref.watch(courseBookmarkProvider(widget.courseId));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Column(
          children: [
            const Text(AppStrings.businessRoadmap),
            Text(
              AppStrings.zeroToProfit,
              style: AppTextStyles.labelSmallPurple,
            ),
          ],
        ),
        actions: [
          BookmarkButton(
            isBookmarked: isBookmarked,
            onTap: () => ref.read(courseBookmarkProvider(widget.courseId).notifier).toggle(),
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              courseAsync.whenData((course) {
                Share.share('Check out this business roadmap on CommerceLQ: ${course?['title']}');
              });
            },
          ),
        ],
      ),
      body: courseAsync.when(
        data: (course) {
          if (course == null) return const Center(child: Text('Course not found'));
          
          return lessonsAsync.when(
            data: (lessons) {
              return progressAsync.when(
                data: (progress) {
                  int completedCount = progress.where((p) => p['is_completed'] == 1).length;
                  double percent = lessons.isEmpty ? 0 : completedCount / lessons.length;
                  
                  // Find current active step
                  int activeStep = completedCount + 1;
                  if (activeStep > lessons.length) activeStep = lessons.length;
                  String activeStepName = lessons.isNotEmpty 
                      ? lessons[activeStep - 1]['title'] 
                      : 'Completed';

                  return RefreshIndicator(
                    onRefresh: () async {
                      ref.invalidate(courseProgressProvider(widget.courseId));
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        children: [
                          _buildHeroCard(course),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: ProgressCard(
                              currentStep: activeStep,
                              totalSteps: lessons.length,
                              stepName: activeStepName,
                              percentage: percent,
                            ),
                          ),
                          const SizedBox(height: 24),
                          _buildRoadmapHeader(),
                          const SizedBox(height: 16),
                          _buildTimeline(context, lessons, progress),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildHeroCard(Map<String, dynamic> course) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.lightPurpleBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(course['emoji'], style: const TextStyle(fontSize: 32)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(course['title'], style: AppTextStyles.heading3),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (course['badge_label'] != null) ...[
                          CustomBadge(label: course['badge_label'], type: course['badge_type']),
                          const SizedBox(width: 8),
                        ],
                        if (course['difficulty'] != null)
                          CustomBadge(
                            label: course['difficulty'].toString().toUpperCase(), 
                            type: course['difficulty'] == 'beginner' ? 'beginner' : 
                                  (course['difficulty'] == 'moderate' ? 'digital_first' : 'high_impact'), // reusing colors for pills
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(course['description'] ?? '', style: AppTextStyles.bodyMedium),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildStatBox(Icons.trending_up, course['expected_roi'] ?? 'High', AppStrings.expectedRoi, AppColors.successGreen, AppColors.greenStatBg)),
              const SizedBox(width: 8),
              Expanded(child: _buildStatBox(Icons.account_balance_wallet, course['investment_level'] ?? 'Low', AppStrings.investment, AppColors.warningAmber, AppColors.amberStatBg)),
              const SizedBox(width: 8),
              Expanded(child: _buildStatBox(Icons.access_time, course['time_required'] ?? '1 mo', AppStrings.timeRequired, AppColors.infoBlue, AppColors.blueStatBg)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(IconData icon, String value, String label, Color color, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(color: color.withValues(alpha: 0.8), fontSize: 10, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildRoadmapHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.route_outlined, size: 28, color: AppColors.primaryPurple),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Step-by-Step Roadmap', style: AppTextStyles.heading3),
                const SizedBox(height: 4),
                Text('Complete each step to build your business from scratch', style: AppTextStyles.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline(BuildContext context, List<Map<String, dynamic>> lessons, List<Map<String, dynamic>> progressList) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: List.generate(lessons.length, (index) {
          final lesson = lessons[index];
          final progress = progressList.firstWhere(
            (p) => p['lesson_id'] == lesson['id'], 
            orElse: () => {'is_completed': 0}
          );
          final isCompleted = progress['is_completed'] == 1;
          final isLast = index == lessons.length - 1;

          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: 32,
                  child: Column(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isCompleted ? AppColors.primaryPurple : Colors.white,
                          border: Border.all(
                            color: isCompleted ? AppColors.primaryPurple : AppColors.mutedGrey,
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '${lesson['step_number']}',
                            style: TextStyle(
                              color: isCompleted ? Colors.white : AppColors.mutedGrey,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      if (!isLast)
                        Expanded(
                          child: Container(
                            width: 1.5,
                            color: AppColors.border,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: InkWell(
                      onTap: () async {
                        await context.push('/lesson/${lesson['id']}');
                        // Refresh progress when returning
                        ref.invalidate(courseProgressProvider(widget.courseId));
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  lesson['category_label'] ?? 'LESSON',
                                  style: AppTextStyles.labelSmall,
                                ),
                                const Icon(Icons.chevron_right, color: AppColors.primaryPurple, size: 20),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(lesson['title'], style: AppTextStyles.heading4),
                            const SizedBox(height: 8),
                            Text(lesson['description'] ?? '', style: AppTextStyles.bodyMedium),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(2),
                                    child: LinearProgressIndicator(
                                      value: isCompleted ? 1.0 : 0.0,
                                      minHeight: 4,
                                      backgroundColor: AppColors.border,
                                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryPurple),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  isCompleted ? '100%' : '0%',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.mutedGrey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              AppStrings.tapForGuide,
                              style: AppTextStyles.purpleLink,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
