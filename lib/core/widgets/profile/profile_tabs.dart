import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies/core/theme/app_colors.dart';
import 'package:provider/provider.dart';

import '../../../l10n/app_localizations.dart';
import '../../provider/app_provider.dart';

class ProfileTabs extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;

  const ProfileTabs({
    super.key,
    required this.selectedIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    var appProvider = Provider.of<AppProvider>(context);
    return Stack(
      children: [
        Positioned.fill(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0).r,
            child: Row(
              children: [
                _buildTabItem(
                  0,
                  locale.wishlist,
                  "assets/icons/watch_list.png",
                  isIcon: false,
                ),
                _buildTabItem(1, locale.history, Icons.history, isIcon: true),
              ],
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Stack(
            children: [
              Container(height: 3.h, color: Colors.transparent),
              AnimatedAlign(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                alignment: appProvider.local == "en" ? selectedIndex == 0
                    ? Alignment.centerLeft
                    : Alignment.centerRight : selectedIndex == 1
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: FractionallySizedBox(
                  widthFactor: 0.5,
                  child: Container(height: 3.h, color: AppColors.secondaryColor),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabItem(
    int index,
    String label,
    dynamic iconSource, {
    required bool isIcon,
  }) {
    final isSelected = selectedIndex == index;
    final color = isSelected
        ? AppColors.secondaryColor
        : AppColors.secondaryText;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTabChanged(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isIcon)
              Icon(iconSource as IconData, size: 30, color: color)
            else
              Image.asset(
                iconSource as String,
                width: 30.w,
                height: 30.h,
                color: color,
              ),
            SizedBox(height: 5.h),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }
}
