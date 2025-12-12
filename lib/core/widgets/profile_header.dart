import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_btn.dart';
import '../../../core/widgets/exit_dialog.dart';
import '../../../core/widgets/stat_box.dart';
import '../../../features/auth/domain/enitiy/user_entity.dart';
import '../../features/usre_arguments/presentaion/bloc/user_bloc.dart';
import '../../features/usre_arguments/presentaion/bloc/user_events.dart';
import '../../features/usre_arguments/presentaion/bloc/user_states.dart';
import '../../modules/home/pages/edit_profile_screen.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({super.key});

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  // Define avatars here or in a constants file
  final List<String> _avatars = [
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
  void initState() {
    super.initState();
    // Only fetch if data isn't already loaded to avoid unnecessary calls
    // on simple rebuilds, unless you want to refresh every time.
    final state = context.read<UserBloc>().state;
    if (state is! UserDataLoaded) {
      context.read<UserBloc>().add(GetUserInfoEvent());
    }
  }

  /// Helper to determine which image provider to use
  ImageProvider _getAvatarProvider(UserEntity? user) {
    // 1. Check for Network Image (Google Auth / Uploaded)
    // Assuming UserEntity has a field 'photoUrl'
    /* if (user?.photoUrl != null && user!.photoUrl!.isNotEmpty) {
      return CachedNetworkImageProvider(user.photoUrl!);
    }
    */

    // 2. Check for Local Asset ID
    if (user != null && user.avatarId != null) {
      final index = user.avatarId!;
      if (index >= 0 && index < _avatars.length) {
        return AssetImage(_avatars[index]);
      }
    }

    // 3. Default Fallback
    return AssetImage(_avatars[0]);
  }

  @override
  Widget build(BuildContext context) {
    // Switch to BlocBuilder to make the UI reactive directly to the BLoC
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {

        // Extract user safely from state
        final UserEntity? currentUser = (state is UserDataLoaded) ? state.user : null;
        final bool isLoading = (state is UserLoading);

        return Container(
          color: AppColors.headerBackground,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),

              // --- Main Info Row ---
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // --- Avatar & Name ---
                  Expanded(
                    // Wrapped in Expanded to prevent overflow if name is long
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                )
                              ]
                          ),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey.shade200,
                            backgroundImage: _getAvatarProvider(currentUser),
                            child: isLoading
                                ? const CircularProgressIndicator.adaptive()
                                : null,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          currentUser?.displayName ?? "Guest User",
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.primaryText,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // --- Stats Row ---
                  const SizedBox(width: 15),
                  const Row(
                    children: [
                      StatBox(label: "Wishlist", count: "0"),
                      SizedBox(width: 10),
                      StatBox(label: "History", count: "0"),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 25),

              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: CustomBtn(
                      text: "Edit Profile",
                      onTap: () {
                        // Determine current path for arguments
                        // If logic gets complex, pass the whole UserEntity to EditProfileScreen
                        String currentAsset = _avatars[0];
                        if (currentUser?.avatarId != null &&
                            currentUser!.avatarId! < _avatars.length) {
                          currentAsset = _avatars[currentUser.avatarId!];
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditProfileScreen(
                              initialAvatarPath: currentAsset,
                              // best practice: pass the full user object if possible
                              // user: currentUser,
                            ),
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
                      onTap: () => showExitConfirmation(context),
                      buttomColor: AppColors.dangerColor,
                      textColor: AppColors.primaryText,
                      isExpanded: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}