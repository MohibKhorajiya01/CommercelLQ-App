import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import 'lesson_provider.dart';
import '../../../../core/database/database_helper.dart';
import '../../../../core/widgets/bookmark_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../bookmarks/presentation/bookmarks_provider.dart';

// Note: Lesson bookmark logic
final lessonBookmarkProvider = StateNotifierProvider.family<LessonBookmarkNotifier, bool, int>((ref, lessonId) {
  return LessonBookmarkNotifier(lessonId, ref);
});

class LessonBookmarkNotifier extends StateNotifier<bool> {
  final int lessonId;
  final Ref ref;
  
  LessonBookmarkNotifier(this.lessonId, this.ref) : super(false) {
    _init();
  }

  Future<void> _init() async {
    state = await DatabaseHelper.instance.isLessonBookmarked(lessonId);
  }

  Future<void> toggle() async {
    await DatabaseHelper.instance.toggleLessonBookmark(lessonId);
    state = !state;
    ref.invalidate(bookmarkedLessonsProvider);
  }
}

class LessonScreen extends ConsumerStatefulWidget {
  final int lessonId;
  const LessonScreen({super.key, required this.lessonId});

  @override
  ConsumerState<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends ConsumerState<LessonScreen> {
  @override
  void initState() {
    super.initState();
    DatabaseHelper.instance.addRecentlyViewed(lessonId: widget.lessonId);
  }

  @override
  Widget build(BuildContext context) {
    final lessonAsync = ref.watch(lessonDetailProvider(widget.lessonId));
    final checklistAsync = ref.watch(checklistItemsProvider(widget.lessonId));
    final progressState = ref.watch(checklistProgressProvider(widget.lessonId));
    final isBookmarked = ref.watch(lessonBookmarkProvider(widget.lessonId));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: lessonAsync.when(
          data: (lesson) => Text(lesson?['title'] ?? 'Lesson', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          loading: () => const Text('Loading...'),
          error: (e, stack) => const Text('Error'),
        ),
        actions: [
          BookmarkButton(
            isBookmarked: isBookmarked,
            onTap: () => ref.read(lessonBookmarkProvider(widget.lessonId).notifier).toggle(),
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              lessonAsync.whenData((lesson) {
                Share.share('Check out this lesson on CommerceLQ: ${lesson?['title']}');
              });
            },
          ),
        ],
      ),
      body: lessonAsync.when(
        data: (lesson) {
          if (lesson == null) return const Center(child: Text('Lesson not found'));

          return checklistAsync.when(
            data: (checklist) {
              int checkedCount = checklist.where((item) => progressState[item['id']] == true).length;
              double progressPercent = checklist.isEmpty ? 0 : checkedCount / checklist.length;

              return Stack(
                children: [
                  Column(
                    children: [
                      _buildProgressIndicator(progressPercent),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(16, 24, 16, 100), // Bottom padding for sticky button
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildHeader(lesson),
                              const SizedBox(height: 24),
                              if (lesson['content'] != null) ...[
                                _InteractiveContentBlock(content: lesson['content'], lessonId: widget.lessonId),
                                const SizedBox(height: 32),
                              ],
                              if (lesson['youtube_id'] != null) ...[
                                _LessonVideoPlayer(youtubeId: lesson['youtube_id']),
                                const SizedBox(height: 32),
                              ],
                              _buildChecklist(checklist, progressState),
                              const SizedBox(height: 24),
                              if (lesson['expert_insight'] != null)
                                _buildExpertInsight(lesson['expert_insight']),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  _buildBottomButton(context, lesson['course_id'], checklist, checkedCount),
                ],
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

  Widget _buildProgressIndicator(double percent) {
    return Column(
      children: [
        LinearProgressIndicator(
          value: percent,
          minHeight: 4,
          backgroundColor: AppColors.border,
          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryPurple),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                AppStrings.guideProgress,
                style: AppTextStyles.labelSmall,
              ),
              Text(
                '${(percent * 100).toInt()}%',
                style: const TextStyle(
                  color: AppColors.primaryPurple,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: AppColors.border),
      ],
    );
  }

  Widget _buildHeader(Map<String, dynamic> lesson) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          (lesson['category_label'] ?? '').toUpperCase(),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColors.darkNavy,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          lesson['description'] ?? '',
          style: const TextStyle(
            fontSize: 15,
            color: AppColors.mutedGrey,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildChecklist(List<Map<String, dynamic>> checklist, Map<int, bool> progressState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: checklist.map((item) {
        final isChecked = progressState[item['id']] ?? false;
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: InkWell(
            onTap: () => ref.read(checklistProgressProvider(widget.lessonId).notifier).toggleItem(item['id']),
            borderRadius: BorderRadius.circular(8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isChecked ? AppColors.primaryPurple : Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: isChecked ? AppColors.primaryPurple : AppColors.mutedGrey,
                      width: 1.5,
                    ),
                  ),
                  child: isChecked
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (item['label'] != null) ...[
                        Text(
                          item['label'].toString().toUpperCase(),
                          style: AppTextStyles.labelSmall,
                        ),
                        const SizedBox(height: 4),
                      ],
                      Text(
                        item['content'],
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: isChecked ? FontWeight.normal : FontWeight.w600,
                          color: isChecked ? AppColors.mutedGrey : AppColors.darkNavy,
                          decoration: isChecked ? TextDecoration.lineThrough : null,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildExpertInsight(String insight) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.extraLightPurple,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text('💡 '),
              Text(
                AppStrings.expertInsight,
                style: TextStyle(
                  color: AppColors.primaryPurple,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            insight,
            style: const TextStyle(
              color: AppColors.bodyText,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context, int courseId, List<Map<String, dynamic>> checklist, int checkedCount) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        decoration: BoxDecoration(
          color: AppColors.pageBg,
          boxShadow: [
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.9),
              blurRadius: 20,
              spreadRadius: 10,
              offset: const Offset(0, -10),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () async {
              // Complete lesson logic
              bool isAllChecked = checkedCount == checklist.length && checklist.isNotEmpty;
              await DatabaseHelper.instance.saveLessonProgress(widget.lessonId, courseId, isAllChecked);
              
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.check_circle, color: Colors.white, size: 18),
                        SizedBox(width: 8),
                        Text(AppStrings.progressSaved, style: TextStyle(fontWeight: FontWeight.w600)),
                      ],
                    ),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: AppColors.darkNavy.withValues(alpha: 0.9),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    margin: const EdgeInsets.only(bottom: 80, left: 64, right: 64),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    duration: const Duration(seconds: 2),
                    elevation: 0,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryPurple,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: 0,
            ),
            child: const Text(
              AppStrings.saveProgress,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}


class _LessonVideoPlayer extends StatelessWidget {
  final String youtubeId;
  const _LessonVideoPlayer({required this.youtubeId});



  @override
  Widget build(BuildContext context) {
    String finalYoutubeId = youtubeId.trim();
    // Force override old cached IDs in case the user didn't fully restart the app to wipe the database
    if (['aqz-KE-bpKQ', '1gDhl4leE-8', 'M7lc1UVf-VE', 'jNQXAC9IVRw', 'Vh0J7dQHaoM', 'roM3wlSqk1c', 'YmVBbW3e9Q8'].contains(finalYoutubeId)) {
      finalYoutubeId = 'uorQJ_ucDhg'; // Master fallback: Shopify Tutorial 2024
    }

    final thumbnailUrl = 'https://img.youtube.com/vi/$finalYoutubeId/hqdefault.jpg';
    final launchUrlString = 'https://youtu.be/$finalYoutubeId';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () async {
            final url = Uri.parse(launchUrlString);
            if (!await launchUrl(url)) {
              debugPrint('Could not launch $url');
            }
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              alignment: Alignment.center,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    thumbnailUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.mutedGrey.withValues(alpha: 0.3),
                        child: const Icon(Icons.video_library, color: Colors.white, size: 48),
                      );
                    },
                  ),
                ),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 10,
                        spreadRadius: 2,
                      )
                    ]
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () async {
              final url = Uri.parse(launchUrlString);
              if (!await launchUrl(url)) {
                debugPrint('Could not launch $url');
              }
            },
            icon: const Icon(Icons.open_in_new, size: 18),
            label: const Text('Open in YouTube App'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryPurple,
              side: const BorderSide(color: AppColors.primaryPurple),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }
}


class _InteractiveContentBlock extends StatefulWidget {
  final String content;
  final int lessonId;
  const _InteractiveContentBlock({required this.content, required this.lessonId});

  @override
  State<_InteractiveContentBlock> createState() => _InteractiveContentBlockState();
}

class _InteractiveContentBlockState extends State<_InteractiveContentBlock> {
  Set<int> _checkedIndices = {};
  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    _prefs = await SharedPreferences.getInstance();
    final savedList = _prefs?.getStringList('lesson_${widget.lessonId}_progress');
    if (savedList != null && mounted) {
      setState(() {
        _checkedIndices = savedList.map((e) => int.parse(e)).toSet();
      });
    }
  }

  Future<void> _saveProgress() async {
    final list = _checkedIndices.map((e) => e.toString()).toList();
    await _prefs?.setStringList('lesson_${widget.lessonId}_progress', list);
  }

  @override
  Widget build(BuildContext context) {
    final paragraphs = widget.content.split('\n\n');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: paragraphs.asMap().entries.map((entry) {
        final index = entry.key;
        final text = entry.value.trim();
        if (text.isEmpty) return const SizedBox.shrink();

        final isStep = text.startsWith('Step') || text.startsWith('•') || text.startsWith('Option') || text.startsWith('Criteria');
        
        if (isStep) {
          final isChecked = _checkedIndices.contains(index);
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: InkWell(
              onTap: () {
                setState(() {
                  if (isChecked) {
                    _checkedIndices.remove(index);
                  } else {
                    _checkedIndices.add(index);
                  }
                  _saveProgress();
                });
              },
              borderRadius: BorderRadius.circular(8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(top: 4),
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: isChecked ? AppColors.primaryPurple : Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isChecked ? AppColors.primaryPurple : AppColors.border,
                        width: 1.5,
                      ),
                    ),
                    child: isChecked ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      text,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: isChecked ? AppColors.mutedGrey : AppColors.darkNavy,
                        decoration: isChecked ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(text, style: AppTextStyles.bodyLarge),
          );
        }
      }).toList(),
    );
  }
}

