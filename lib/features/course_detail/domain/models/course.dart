class Course {
  final int id;
  final int categoryId;
  final String title;
  final String? subtitle;
  final String? description;
  final String emoji;
  final String? badgeLabel;
  final String? badgeType;
  final String? expectedRoi;
  final String? investmentLevel;
  final String? timeRequired;
  final String? difficulty;
  final int totalSteps;

  Course({
    required this.id,
    required this.categoryId,
    required this.title,
    this.subtitle,
    this.description,
    required this.emoji,
    this.badgeLabel,
    this.badgeType,
    this.expectedRoi,
    this.investmentLevel,
    this.timeRequired,
    this.difficulty,
    this.totalSteps = 0,
  });

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      id: map['id'] as int,
      categoryId: map['category_id'] as int,
      title: map['title'] as String,
      subtitle: map['subtitle'] as String?,
      description: map['description'] as String?,
      emoji: map['emoji'] as String,
      badgeLabel: map['badge_label'] as String?,
      badgeType: map['badge_type'] as String?,
      expectedRoi: map['expected_roi'] as String?,
      investmentLevel: map['investment_level'] as String?,
      timeRequired: map['time_required'] as String?,
      difficulty: map['difficulty'] as String?,
      totalSteps: map['total_steps'] as int,
    );
  }
}
