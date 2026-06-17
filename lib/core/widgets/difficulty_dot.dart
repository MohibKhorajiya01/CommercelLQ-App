import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class DifficultyDot extends StatelessWidget {
  final String label;
  final String? difficulty; // 'beginner', 'moderate', 'advanced'
  final bool showLabel;

  const DifficultyDot({
    super.key,
    required this.label,
    this.difficulty,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    Color dotColor;

    switch (difficulty?.toLowerCase()) {
      case 'beginner':
        dotColor = AppColors.successGreen;
        break;
      case 'moderate':
        dotColor = AppColors.warningAmber;
        break;
      case 'advanced':
        dotColor = AppColors.dangerRed;
        break;
      default:
        dotColor = AppColors.primaryPurple;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: dotColor,
            shape: BoxShape.circle,
          ),
        ),
        if (showLabel) ...[
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.statValue,
          ),
        ]
      ],
    );
  }
}
