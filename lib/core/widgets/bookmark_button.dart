import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class BookmarkButton extends StatelessWidget {
  final bool isBookmarked;
  final VoidCallback onTap;

  const BookmarkButton({
    super.key,
    required this.isBookmarked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isBookmarked ? Icons.bookmark : Icons.bookmark_border,
        color: isBookmarked ? AppColors.primaryPurple : AppColors.darkNavy,
      ),
      onPressed: onTap,
    );
  }
}
