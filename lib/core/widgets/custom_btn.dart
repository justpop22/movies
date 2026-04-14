import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';

class CustomBtn extends StatelessWidget {
  final String text;
  final Function() onTap;
  final bool isLoading;
  final bool isExpanded;
  final bool border;
  final Color textColor;
  final Color buttomColor;
  final IconData? icon;
  final double iconSpacing;

  const CustomBtn({
    super.key,
    required this.onTap,
    required this.text,
    this.isLoading = false,
    this.isExpanded = false,
    this.border = false,
    this.textColor = AppColors.primaryColor,
    this.buttomColor = AppColors.secondaryColor,
    this.icon,
    this.iconSpacing = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(16);

    return Container(
      width: isExpanded ? double.infinity : null,
      decoration: border
          ? BoxDecoration(
              borderRadius: borderRadius,
              border: Border.all(color: AppColors.secondaryColor, width: 2.w),
            )
          : null,
      child: CupertinoButton(
        padding: EdgeInsets.symmetric(vertical: 16).r,
        borderRadius: borderRadius,
        color: border ? Colors.transparent : buttomColor,
        onPressed: onTap,
        child: AnimatedCrossFade(
          firstChild: Row(
            mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  color: border ? AppColors.secondaryColor : textColor,
                ),
                SizedBox(width: iconSpacing),
              ],
              Flexible(
                child: Text(
                  text,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: border ? AppColors.secondaryColor : textColor,
                  ),
                ),
              ),
            ],
          ),
          secondChild: SizedBox(
            width: 60.w,
            height: 26.h,
            child: CupertinoActivityIndicator(
              color: border ? AppColors.secondaryColor : textColor,
            ),
          ),
          duration: const Duration(milliseconds: 200),
          crossFadeState: isLoading
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
        ),
      ),
    );
  }
}
