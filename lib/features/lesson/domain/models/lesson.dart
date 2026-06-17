class Lesson {
  final int id;
  final int courseId;
  final int stepNumber;
  final String? categoryLabel;
  final String title;
  final String? description;
  final String? content;
  final String? expertInsight;
  final int readingMinutes;

  Lesson({
    required this.id,
    required this.courseId,
    required this.stepNumber,
    this.categoryLabel,
    required this.title,
    this.description,
    this.content,
    this.expertInsight,
    this.readingMinutes = 5,
  });

  factory Lesson.fromMap(Map<String, dynamic> map) {
    return Lesson(
      id: map['id'] as int,
      courseId: map['course_id'] as int,
      stepNumber: map['step_number'] as int,
      categoryLabel: map['category_label'] as String?,
      title: map['title'] as String,
      description: map['description'] as String?,
      content: map['content'] as String?,
      expertInsight: map['expert_insight'] as String?,
      readingMinutes: map['reading_minutes'] as int? ?? 5,
    );
  }
}

class ChecklistItem {
  final int id;
  final int lessonId;
  final String? label;
  final String content;

  ChecklistItem({
    required this.id,
    required this.lessonId,
    this.label,
    required this.content,
  });

  factory ChecklistItem.fromMap(Map<String, dynamic> map) {
    return ChecklistItem(
      id: map['id'] as int,
      lessonId: map['lesson_id'] as int,
      label: map['label'] as String?,
      content: map['content'] as String,
    );
  }
}
