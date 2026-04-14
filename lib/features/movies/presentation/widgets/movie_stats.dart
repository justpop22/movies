import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies/core/theme/app_colors.dart';

class MovieStats extends StatelessWidget {
  final double rating;
  final int runtime;
  final int likeCount;

  const MovieStats({
    super.key,
    required this.rating,
    required this.runtime,
    required this.likeCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10).r,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildBrownStatBox(Icons.star, rating.toString()),
          _buildBrownStatBox(Icons.access_time_filled, "$runtime"),
          _buildBrownStatBox(Icons.thumb_up, "$likeCount"),
        ],
      ),
    );
  }

  Widget _buildBrownStatBox(IconData icon, String value) {
    return Container(
      width: 105.w,
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8).r,
      decoration: BoxDecoration(
        color: const Color(0xFF282828),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.secondaryColor, size: 24),
          SizedBox(width: 8.w),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
