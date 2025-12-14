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
  final int watchListCount;
  final int historyCount;

  const ProfileHeader({
    super.key,
    this.watchListCount = 0,
    this.historyCount = 0,
  });

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
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

    context.read<UserBloc>().add(GetUserInfoEvent());
  }

  ImageProvider _getAvatarProvider(UserEntity? user) {
    if (user != null && user.avatarId != null) {
      final index = user.avatarId!;
      if (index >= 0 && index < _avatars.length) {
        return AssetImage(_avatars[index]);
      }
    }
    return AssetImage(_avatars[0]);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        UserEntity? currentUser;
        if (state is UserDataLoaded) {
          currentUser = state.user;
        } else if (state is UserDataLoaded) {}

        final bool isLoading = (state is UserLoading);

        return Container(
          color: AppColors.headerBackground,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
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
                              ),
                            ],
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

                  const SizedBox(width: 15),
                  Row(
                    children: [
                      StatBox(
                        label: "Wishlist",
                        count: widget.watchListCount.toString(),
                      ),
                      const SizedBox(width: 10),
                      StatBox(
                        label: "History",
                        count: widget.historyCount.toString(),
                      ),
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
