import 'package:flutter/material.dart';
import 'package:movies/core/theme/app_colors.dart';

class MovieStatsSection extends StatelessWidget {
  final String rating;
  final String duration;

  const MovieStatsSection({
    super.key,
    required this.rating,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildBrownStatBox(Icons.favorite_rounded, "2.5k"),
          _buildBrownStatBox(Icons.access_time_filled_rounded, duration),
          _buildBrownStatBox(Icons.star_rounded, rating),
        ],
      ),
    );
  }

  Widget _buildBrownStatBox(IconData icon, String value) {
    return Container(
      width: 115,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF282828),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.secondaryColor, size: 24),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
