import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../auth/services/auth_services.dart';

class AvatarSelectionSheet extends StatelessWidget {
  final String currentAvatarPath;
  final Function(String) onAvatarSelected;

  const AvatarSelectionSheet({
    super.key,
    required this.currentAvatarPath,
    required this.onAvatarSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // تحديد ارتفاع مناسب للشريحة
      height: MediaQuery.of(context).size.height * 0.6,
      padding: const EdgeInsets.all(20.0),
      decoration: const BoxDecoration(
        color: AppColors.mainBackground, // ⬅️ استخدام AppColors
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // شريط إغلاق علوي
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: AppColors.disabledText,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 15),

          // عنوان الشريحة
          Text(
            "Pick Avatar",
            style: TextStyle(
                color: AppColors.secondaryColor,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // شبكة الصور
          Expanded(
            child: GridView.builder(
              itemCount: AuthServices.defaultAvatars.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                final avatarPath = AuthServices.defaultAvatars[index];
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
                      // إطار أصفر للصورة المختارة
                      border: isSelected
                          ? Border.all(color: AppColors.secondaryColor, width: 4)
                          : null,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
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