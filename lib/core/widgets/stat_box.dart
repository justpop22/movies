import 'package:flutter/material.dart';

import '../theme/app_colors.dart';


class StatBox extends StatelessWidget {
  final String label;
  final String count;

  const StatBox({
    super.key,
    required this.label,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          count,
          style: const TextStyle(
            color: AppColors.primaryText,
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.primaryText,
            fontSize: 24,
            fontWeight: FontWeight.bold
          ),
        ),
      ],
    );
  }
}