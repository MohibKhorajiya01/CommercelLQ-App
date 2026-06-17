import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_badge.dart';
import 'home_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lastAccessedAsync = ref.watch(lastAccessedCourseProvider);

    return Scaffold(
      backgroundColor: AppColors.pageBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/app_icon.png',
                width: 32,
                height: 32,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              AppStrings.appName,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 21,
                color: AppColors.darkNavy,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.pageBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.notifications_none_rounded, color: AppColors.darkNavy, size: 20),
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.primaryPurple,
        onRefresh: () async {
          ref.invalidate(lastAccessedCourseProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---- CONTINUE LEARNING ----
              lastAccessedAsync.when(
                data: (course) => course != null
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionHeader('Continue Learning', onTap: null),
                            const SizedBox(height: 12),
                            _buildContinueLearningCard(context, course),
                            const SizedBox(height: 8),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
                loading: () => const SizedBox.shrink(),
                error: (e, _) => const SizedBox.shrink(),
              ),

              // ---- 3 BUSINESS MODEL CARDS ----
              const SizedBox(height: 16),
              _buildSectionHeader('Business Models', onTap: null),
              const SizedBox(height: 14),
              _buildBusinessModelCards(context),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  // ─────────────────────────────────────────────
  // SECTION HEADER
  // ─────────────────────────────────────────────
  Widget _buildSectionHeader(String title, {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyles.heading3),
          if (onTap != null)
            GestureDetector(
              onTap: onTap,
              child: const Text(AppStrings.seeAll, style: AppTextStyles.purpleLink),
            ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // CONTINUE LEARNING CARD
  // ─────────────────────────────────────────────
  Widget _buildContinueLearningCard(BuildContext context, Map<String, dynamic> course) {
    final completedSteps = course['completed_steps'] as int? ?? 0;
    final totalSteps = course['total_steps'] as int? ?? 1;
    final progress = totalSteps > 0 ? completedSteps / totalSteps : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        onTap: () => context.push('/course/${course['id']}'),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.lightPurpleBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(course['emoji'] ?? '📚', style: const TextStyle(fontSize: 26)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('CONTINUE LEARNING', style: AppTextStyles.labelSmallPurple),
                    const SizedBox(height: 4),
                    Text(
                      course['title'] ?? '',
                      style: AppTextStyles.heading4,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 6,
                              backgroundColor: AppColors.lightPurpleBg,
                              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryPurple),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '$completedSteps/$totalSteps steps',
                          style: AppTextStyles.labelSmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.lightPurpleBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.primaryPurple),
              ),
            ],
          ),
        ),
      ),
    );
  }


  // ─────────────────────────────────────────────
  Widget _buildBusinessModelCards(BuildContext context) {
    final models = [
      _BusinessModel(
        title: 'E-Commerce',
        subtitle: 'Sell products via your own branded online store using Shopify or WooCommerce.',
        emoji: '🛍️',
        tag: 'POPULAR',
        tagType: 'high_impact',
        color: AppColors.primaryPurple,
        bgColor: AppColors.lightPurpleBg,
        stats: [
          _Stat('ROI', '40–200%'),
          _Stat('Start', '\$200–\$500'),
          _Stat('Level', 'Beginner'),
        ],
        categoryId: 1,
      ),
      _BusinessModel(
        title: 'Dropshipping',
        subtitle: 'Sell products without holding inventory. Supplier ships directly to your customer.',
        emoji: '📦',
        tag: 'LOW RISK',
        tagType: 'beginner',
        color: AppColors.primaryPurple,
        bgColor: AppColors.lightPurpleBg,
        stats: [
          _Stat('ROI', '10–50%'),
          _Stat('Start', '\$0–\$100'),
          _Stat('Level', 'Beginner'),
        ],
        categoryId: 2,
      ),
      _BusinessModel(
        title: 'FBA Private Label',
        subtitle: "Source products from manufacturers, add your brand, and let Amazon handle storage & shipping.",
        emoji: '🏷️',
        tag: 'HIGH PROFIT',
        tagType: 'digital_first',
        color: AppColors.primaryPurple,
        bgColor: AppColors.lightPurpleBg,
        stats: [
          _Stat('ROI', '50–300%'),
          _Stat('Start', '\$2k–\$5k'),
          _Stat('Level', 'Advanced'),
        ],
        categoryId: 3,
      ),
    ];

    return Column(
      children: models.map((m) => _buildModelCard(context, m)).toList(),
    );
  }

  Widget _buildModelCard(BuildContext context, _BusinessModel model) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => context.push('/categories/${model.categoryId}'),
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: emoji box + title + tag
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: model.bgColor,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Text(model.emoji, style: const TextStyle(fontSize: 28)),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(model.title, style: AppTextStyles.heading4),
                        const SizedBox(height: 6),
                        CustomBadge(label: model.tag, type: model.tagType),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.pageBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.arrow_forward_ios_rounded, size: 14, color: model.color),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Description
              Text(
                model.subtitle,
                style: AppTextStyles.bodySmall.copyWith(height: 1.5),
              ),

              const SizedBox(height: 16),

              // Divider
              Container(height: 1, color: AppColors.border),
              const SizedBox(height: 16),

              // 3 Stats row
              Row(
                children: model.stats.map((stat) {
                  return Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(stat.label, style: AppTextStyles.labelSmall),
                        const SizedBox(height: 4),
                        Text(
                          stat.value,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: model.color,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),

              // Explore Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.push('/categories/${model.categoryId}'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: model.bgColor,
                    foregroundColor: model.color,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Explore ${model.title}',
                        style: TextStyle(fontWeight: FontWeight.w700, color: model.color),
                      ),
                      const SizedBox(width: 6),
                      Icon(Icons.arrow_forward_rounded, size: 16, color: model.color),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // BOTTOM NAV
  // ─────────────────────────────────────────────
  Widget _buildBottomNav(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: 0,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primaryPurple,
        unselectedItemColor: AppColors.mutedGrey,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
        onTap: (index) {
          if (index == 1) context.push('/search');
          if (index == 2) context.push('/bookmarks');
          if (index == 3) context.push('/profile');
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: AppStrings.home,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search_rounded),
            label: AppStrings.search,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_outline),
            activeIcon: Icon(Icons.bookmark_rounded),
            label: AppStrings.bookmarks,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            activeIcon: Icon(Icons.person_rounded),
            label: AppStrings.profile,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// DATA CLASSES
// ─────────────────────────────────────────────
class _BusinessModel {
  final String title, subtitle, emoji, tag, tagType;
  final Color color, bgColor;
  final List<_Stat> stats;
  final int categoryId;

  _BusinessModel({
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.tag,
    required this.tagType,
    required this.color,
    required this.bgColor,
    required this.stats,
    required this.categoryId,
  });
}

class _Stat {
  final String label, value;
  _Stat(this.label, this.value);
}
