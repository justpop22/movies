import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies/core/theme/app_colors.dart';

class ProfileTabsDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  ProfileTabsDelegate({required this.child, this.height = 85.0});

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: AppColors.headerBackground, child: child);
  }

  @override
  bool shouldRebuild(covariant ProfileTabsDelegate oldDelegate) {
    return oldDelegate.child != child;
  }
}
