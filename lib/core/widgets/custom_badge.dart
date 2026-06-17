import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class CustomBadge extends StatelessWidget {
  final String label;
  final String? type;

  const CustomBadge({
    super.key,
    required this.label,
    this.type,
  });

  @override
  Widget build(BuildContext context) {
    Color textColor;
    Color bgColor;

    switch (type) {
      case 'high_impact':
        textColor = AppColors.highImpactText;
        bgColor = AppColors.highImpactBg;
        break;
      case 'digital_first':
        textColor = AppColors.digitalFirstText;
        bgColor = AppColors.digitalFirstBg;
        break;
      case 'low_investment':
        textColor = AppColors.lowInvestmentText;
        bgColor = AppColors.lowInvestmentBg;
        break;
      case 'beginner':
        textColor = AppColors.beginnerText;
        bgColor = AppColors.beginnerBg;
        break;
      default:
        textColor = AppColors.primaryPurple;
        bgColor = AppColors.lightPurpleBg;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
