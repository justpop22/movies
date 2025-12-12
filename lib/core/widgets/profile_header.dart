import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:movies/core/theme/app_colors.dart';
import 'package:movies/core/widgets/stat_box.dart';
import 'package:movies/core/widgets/exit_dialog.dart';
import 'package:movies/core/widgets/custom_btn.dart';
import 'package:movies/modules/auth/manager/auth_provider.dart';
import 'package:movies/modules/home/pages/edit_profile_screen.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<AuthProvider, ({String? photo, String? name, String? localAvatar})>(
      selector: (_, provider) => (
      photo: provider.user?.photoURL,
      name: provider.user?.displayName,
      localAvatar: provider.localSelectedAvatar
      ),
      builder: (context, data, child) {
        final avatarPath = data.photo ?? data.localAvatar ?? 'assets/logo/profile1.png';
        final isNetwork = data.photo != null && data.photo!.startsWith('http');

        return Container(
          color: AppColors.headerBackground,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),

              Row(
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: isNetwork
                            ? CachedNetworkImageProvider(avatarPath)
                            : AssetImage(avatarPath) as ImageProvider,
                      ),
                      const SizedBox(height: 22,),
                      Text(
                        data.name ?? "Guest User",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.primaryText,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Row(
                    children: [
                      StatBox(label: "Wishlist", count: "24"),
                      SizedBox(width: 10),
                      StatBox(label: "History", count: "12"),
                    ],
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 15),

              // Text(
              //   data.name ?? "Guest User",
              //   textAlign: TextAlign.center,
              //   style: const TextStyle(
              //     color: AppColors.primaryText,
              //     fontSize: 20,
              //     fontWeight: FontWeight.w500,
              //   ),
              // ),
              const SizedBox(height: 5),

              // ==========================================

              // ==========================================
              Row(
                children: [
                  // Edit Profile
                  Expanded(
                    flex: 2,
                    child: CustomBtn(
                      text: "Edit Profile",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditProfileScreen(initialAvatarPath: avatarPath),
                          ),
                        );
                      },
                      buttomColor: AppColors.secondaryColor,
                      textColor: Colors.black,
                      isExpanded: true,
                    ),
                  ),

                  const SizedBox(width: 10),

                  // Exit
                  Expanded(
                    flex: 1,
                    child: CustomBtn(
                      text: "Exit",
                      icon: Icons.logout,
                      iconSpacing: 5,
                      onTap: () async {
                        showExitConfirmation(context);
                      },
                      buttomColor: AppColors.dangerColor,
                      textColor: AppColors.primaryText,
                      isExpanded: true,
                    ),
                  ),
                ],
              ),
              // ==========================================

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
