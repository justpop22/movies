import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import '../../../core/routes/app_route_name.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/delete_dialog.dart';
import '../../../core/widgets/edit_acc_text_field.dart';
import '../../auth/manager/auth_provider.dart';
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

  late String currentAvatarPath;
  late final User? currentUser;

  bool get isNetworkImage => currentAvatarPath.startsWith('http');

  @override
  void initState() {
    super.initState();
    final authProvider = context.read<AuthProvider>();
    currentUser = authProvider.user;

    _nameController = TextEditingController(
      text: currentUser?.displayName ?? "User Name",
    );
    _phoneController = TextEditingController(
      text: authProvider.userPhone ?? "Loading...",
    );

    currentAvatarPath = widget.initialAvatarPath;

    if (!authProvider.isInitialized && authProvider.user != null) {
      authProvider.addListener(_handleInitializationComplete);
    } else {
      _initializeControllers(authProvider);
    }
  }

  void _initializeControllers(AuthProvider authProvider) {
    _phoneController.text = authProvider.userPhone ?? "";
  }

  void _handleInitializationComplete() {
    final authProvider = context.read<AuthProvider>();

    if (authProvider.isInitialized) {
      authProvider.removeListener(_handleInitializationComplete);
      setState(() {
        _initializeControllers(authProvider);
      });
    }
  }

  @override
  void dispose() {
    context.read<AuthProvider>().removeListener(_handleInitializationComplete);
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveAndPop() async {
    final authProvider = context.read<AuthProvider>();
    await authProvider.updateUserData(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile Updated!")),
      );
      Navigator.pop(context);
    }
  }

  void _showAvatarSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return AvatarSelectionSheet(
          currentAvatarPath: currentAvatarPath,
          onAvatarSelected: (newPath) async {
            await context.read<AuthProvider>().updateProfileAvatar(newPath);

            setState(() {
              currentAvatarPath = newPath;
            });

            if (mounted) {
              Navigator.pop(context);
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("Edit Profile"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),

                    // --- Avatar Section ---
                    GestureDetector(
                      onTap: _showAvatarSheet,
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.secondaryColor, width: 2),
                            ),
                            child: CircleAvatar(
                              radius: 60,
                              // Conditional loading logic
                              backgroundImage: isNetworkImage
                                  ? CachedNetworkImageProvider(currentAvatarPath) as ImageProvider<Object>
                                  : AssetImage(currentAvatarPath),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: AppColors.secondaryColor,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 2,
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

                    const SizedBox(height: 40),

                    // --- Form Fields ---
                    CustomTextField(
                      controller: _nameController,
                      hint: "Full Name",
                      icon: Icons.person,
                      inputType: TextInputType.name,
                    ),

                    const SizedBox(height: 20),

                    CustomTextField(
                      controller: _phoneController,
                      hint: "Phone Number",
                      icon: Icons.phone,
                      inputType: TextInputType.phone,
                    ),

                    const SizedBox(height: 20),

                    // --- Reset Password ---
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, RouteName.forgetPassword);
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          "Reset Password",
                          style: TextStyle(
                            color: AppColors.secondaryText,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.secondaryText,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // --- Action Buttons (Pinned to Bottom) ---
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 1. Update Data Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondaryColor,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      onPressed: _saveAndPop,
                      child: const Text(
                        "Update Data",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // 2. Delete Account Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.dangerColor,
                        foregroundColor: AppColors.primaryText,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      onPressed: () {
                        showDeleteConfirmation(context);
                      },
                      child: const Text(
                        "Delete Account",
                        style: TextStyle(
                          fontSize: 16,
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
    );
  }
}