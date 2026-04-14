import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../l10n/app_localizations.dart';

class AvatarSelectionSheet extends StatelessWidget {
  final String currentAvatarPath;
  final Function(String) onAvatarSelected;

  const AvatarSelectionSheet({
    super.key,
    required this.currentAvatarPath,
    required this.onAvatarSelected,
  });

  static const List<String> _defaultAvatars = [
    'assets/logo/profile1.png',
    'assets/logo/profile2.png',
    'assets/logo/profile3.png',
    'assets/logo/profile4.png',
    'assets/logo/profile5.png',
    'assets/logo/profile6.png',
    'assets/logo/profile7.png',
    'assets/logo/profile8.png',
    'assets/logo/profile9.png',
  ];

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      padding: EdgeInsets.all(20.0).w,
      decoration: const BoxDecoration(
        color: AppColors.mainBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 40.w,
            height: 5.h,
            decoration: BoxDecoration(
              color: AppColors.disabledText,
              borderRadius: BorderRadius.circular(10).w,
            ),
          ),
          SizedBox(height: 15.h),

          Text(
          locale.pickAvatar,
            style: TextStyle(
              color: AppColors.secondaryColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20.h),

          Expanded(
            child: GridView.builder(
              itemCount: _defaultAvatars.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                final avatarPath = _defaultAvatars[index];
                final isSelected = avatarPath == currentAvatarPath;

                return GestureDetector(
                  onTap: () {
                    onAvatarSelected(avatarPath);
                    Navigator.pop(context);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(
                              color: AppColors.secondaryColor,
                              width: 4.w,
                            )
                          : null,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(4.0).w,
                      child: CircleAvatar(
                        backgroundImage: AssetImage(avatarPath),
                        backgroundColor: AppColors.headerBackground,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
