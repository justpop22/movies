import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies/core/widgets/dialogs/delete_dialog.dart';
import '../../../../../../core/routes/app_route_name.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/profile/edit_acc_text_field.dart';
import '../../../../../features/auth/domain/enitiy/user_entity.dart';
import '../../../../../features/auth/presentation/cubit/auth_bloc.dart';
import '../../../../../features/auth/presentation/cubit/auth_event.dart';
import '../../../../../features/auth/presentation/cubit/auth_state.dart';
import '../../../../../features/usre_arguments/presentaion/bloc/user_bloc.dart';
import '../../../../../features/usre_arguments/presentaion/bloc/user_events.dart';
import '../../../../../features/usre_arguments/presentaion/bloc/user_states.dart';

import '../../../../../l10n/app_localizations.dart';
import 'avatar_selection_sheet.dart';

class EditProfileScreen extends StatefulWidget {
  final String initialAvatarPath;

  const EditProfileScreen({super.key, required this.initialAvatarPath});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;

  String currentAvatarPath = "";
  UserEntity? currentUser;

  bool get isNetworkImage => currentAvatarPath.startsWith('http');

  int _getAvatarIdFromPath(String path) {
    const avatars = [
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
    return avatars.indexOf(path);
  }

  String _getAvatarPathFromId(int? id) {
    const avatars = [
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
    if (id != null && id >= 0 && id < avatars.length) {
      return avatars[id];
    }
    return 'assets/logo/profile1.png';
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    currentAvatarPath = widget.initialAvatarPath;

    final userState = context.read<UserBloc>().state;
    if (userState is UserDataLoaded) {
      _populateFields(userState.user!);
    }
  }

  void _populateFields(UserEntity user) {
    currentUser = user;
    _nameController.text = user.displayName;
    _phoneController.text = user.phoneNumber ?? "";
    if (user.avatarId != null) {
      currentAvatarPath = _getAvatarPathFromId(user.avatarId);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User data not loaded yet")),
      );
      return;
    }

    final updatedUser = UserEntity(
      uid: currentUser!.uid,
      email: currentUser!.email,
      displayName: _nameController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      avatarId: _getAvatarIdFromPath(currentAvatarPath),
    );

    context.read<UserBloc>().add(UpdateUserEvent(updatedUser));
  }

  void _showAvatarSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return AvatarSelectionSheet(
          currentAvatarPath: currentAvatarPath,
          onAvatarSelected: (newPath) {
            setState(() {
              currentAvatarPath = newPath;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    return MultiBlocListener(
      listeners: [
        BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserInfoUpdated) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Profile Updated!"),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context);
            } else if (state is UserError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),

        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is Unauthenticated) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                RouteName.login,
                (route) => false,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Account deleted successfully")),
              );
            } else if (state is AuthActionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.mainBackground,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(title: Text(locale.editProfile)),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ).r,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 10.h),

                      GestureDetector(
                        onTap: _showAvatarSheet,
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.secondaryColor,
                                  width: 2.w,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 60.r,
                                backgroundImage: isNetworkImage
                                    ? CachedNetworkImageProvider(
                                            currentAvatarPath,
                                          )
                                          as ImageProvider
                                    : AssetImage(currentAvatarPath),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 36.w,
                                height: 36.h,
                                decoration: BoxDecoration(
                                  color: AppColors.secondaryColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 2.w,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 20,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 40.h),

                      CustomTextField(
                        controller: _nameController,
                        hint: locale.fullName,
                        icon: Icons.person,
                        inputType: TextInputType.name,
                      ),
                      SizedBox(height: 20.h),

                      CustomTextField(
                        controller: _phoneController,
                        hint: locale.phoneNumber,
                        icon: Icons.phone,
                        inputType: TextInputType.phone,
                      ),
                      SizedBox(height: 20.h),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () {
                            if (currentUser?.email != null) {
                              context.read<AuthBloc>().add(
                                ForgotPasswordEvent(email: currentUser!.email),
                              );
                            }
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            locale.resetPassword,
                            style: TextStyle(
                              color: AppColors.secondaryText,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                              decorationColor: AppColors.secondaryText,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 56.h,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondaryColor,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12).w,
                          ),
                          elevation: 2,
                        ),
                        onPressed: _onSave,
                        child: BlocBuilder<UserBloc, UserState>(
                          builder: (context, state) {
                            if (state is UserLoading) {
                              return SizedBox(
                                height: 24.h,
                                width: 24.w,
                                child: CircularProgressIndicator(
                                  color: Colors.black,
                                  strokeWidth: 2,
                                ),
                              );
                            }

                            return Text(
                              locale.updateData,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 15.h),

                    SizedBox(
                      width: double.infinity,
                      height: 56.h,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.dangerColor,
                          foregroundColor: AppColors.primaryText,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12).w,
                          ),
                          elevation: 2,
                        ),
                        onPressed: () {
                          showDeleteConfirmation(context);
                        },
                        child: Text(
                          locale.deleteAccount,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
