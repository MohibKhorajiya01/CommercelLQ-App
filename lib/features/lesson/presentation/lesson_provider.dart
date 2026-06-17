import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/database_helper.dart';

final lessonDetailProvider = FutureProvider.family<Map<String, dynamic>?, int>((ref, lessonId) async {
  return DatabaseHelper.instance.getLessonById(lessonId);
});

final checklistItemsProvider = FutureProvider.family<List<Map<String, dynamic>>, int>((ref, lessonId) async {
  return DatabaseHelper.instance.getChecklistItems(lessonId);
});

final checklistProgressProvider = StateNotifierProvider.family<ChecklistProgressNotifier, Map<int, bool>, int>((ref, lessonId) {
  return ChecklistProgressNotifier(lessonId);
});

class ChecklistProgressNotifier extends StateNotifier<Map<int, bool>> {
  final int lessonId;
  ChecklistProgressNotifier(this.lessonId) : super({}) {
    _init();
  }

  Future<void> _init() async {
    state = await DatabaseHelper.instance.getChecklistProgress(lessonId);
  }

  Future<void> toggleItem(int itemId) async {
    final currentState = state[itemId] ?? false;
    final newState = !currentState;
    
    // Save to DB immediately
    await DatabaseHelper.instance.saveChecklistItemProgress(itemId, lessonId, newState);
    
    // Update local state
    state = {...state, itemId: newState};
  }

  Future<void> markAllCompleted(List<int> itemIds) async {
    for (var id in itemIds) {
      await DatabaseHelper.instance.saveChecklistItemProgress(id, lessonId, true);
    }
    state = { for (var id in itemIds) id : true };
  }
}
