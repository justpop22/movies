import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/dialogs/app_dialogs.dart'; // Assuming this import is correct
import '../../../core/routes/app_route_name.dart';
import '../services/auth_services.dart'; // Assuming this import is correct

class AuthProvider extends ChangeNotifier {
  // --- Controllers and Form Key ---
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  // --- State Properties ---
  User? _user;
  User? get user => _user;

  String? _userPhone;
  String? get userPhone => _userPhone; // Phone number fetched from Firestore

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized; // Flag for async data loading

  // Getter to retrieve the avatar from the Firebase User object
  String? get selectedAvatar {
    return _user?.photoURL ?? localSelectedAvatar;
  }

  String? localSelectedAvatar; // Local state for avatar selection during registration


  // --- Constructor and Initialization ---

  AuthProvider() {
    _user = FirebaseAuth.instance.currentUser;

    // Check for an existing user and fetch their Firestore data on startup
    if (_user != null) {
      _initializeUserSession(_user!.uid);
    }
  }

  // Private method to handle the async initialization and data fetch
  Future<void> _initializeUserSession(String uid) async {
    await _fetchUserDataFromFirestore(uid);
    _isInitialized = true;
    notifyListeners();
  }

  // Method to fetch phone number (and other data) from Firestore
  Future<void> _fetchUserDataFromFirestore(String uid) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (docSnapshot.exists) {
        // Read the value from the 'phone' field
        _userPhone = docSnapshot.data()?['phone'] as String?;
      }
    } catch (e) {
      debugPrint("Error fetching phone number from Firestore: $e");
    }
  }

  // --- Profile Management ---

  void setAvatar(String avatarUrl) {
    localSelectedAvatar = avatarUrl;
    notifyListeners();
  }

  Future<void> updateUserData({required String name, required String phone}) async {
    if (_user == null) return;

    try {
      await _user!.updateDisplayName(name);

      await FirebaseFirestore.instance.collection("users").doc(_user!.uid).update({
        "name": name,
        "phone": phone,
        "updated_at": FieldValue.serverTimestamp(),
      });

      // Update the local phone state immediately
      _userPhone = phone;

      await _user!.reload();
      _user = FirebaseAuth.instance.currentUser;
      notifyListeners();
    } catch (e) {
      debugPrint("Failed to update user data: $e");
      rethrow;
    }
  }

  Future<void> updateProfileAvatar(String newAvatarPath) async {
    if (_user == null) return;

    try {
      await _user!.updatePhotoURL(newAvatarPath);

      await FirebaseFirestore.instance.collection("users").doc(_user!.uid).update({
        "avatarUrl": newAvatarPath,
        "updated_at": FieldValue.serverTimestamp(),
      });

      await _user!.reload();
      _user = FirebaseAuth.instance.currentUser;
      notifyListeners();
    } catch (e) {
      debugPrint("Failed to update avatar: $e");
      rethrow;
    }
  }

  // --- Authentication Methods ---

  Future<void> logout(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    try {
      await AuthServices.signOut();
      _user = null;
      _userPhone = null;
      localSelectedAvatar = null;
      _isInitialized = false;
      emailController.clear();
      passwordController.clear();

      if (context.mounted) {
        AppDialogs.showMessage(context, "Logged out successfully", type: DialogType.success);
      }
    } catch (e) {
      debugPrint("Logout error: $e");
      if (context.mounted) {
        AppDialogs.showMessage(context, "Logout failed. Please try again.", type: DialogType.error);
      }
    }
    isLoading = false;
    notifyListeners();
  }

  Future<bool> createAccount(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    if (!formKey.currentState!.validate()) {
      isLoading = false;
      notifyListeners();
      return false;
    }

    try {
      var userCredential = await AuthServices.createAccount(
        email: emailController.text.trim(),
        password: passwordController.text,
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
        avatar: localSelectedAvatar,
      );

      if (userCredential != null && context.mounted) {
        _user = userCredential.user;
        await _fetchUserDataFromFirestore(_user!.uid);

        AppDialogs.showMessage(
          context,
          "Check your email",
          type: DialogType.success,
        );

        // ✅ يجب وضع notifyListeners() هنا لتحديث الشاشة بعد جلب بيانات Firestore
        notifyListeners();
        return true; // ✅ الإرجاع عند النجاح
      }
      return false; // فشل التسجيل دون إطلاق خطأ

    } catch (e, stackTrace) {
      debugPrint("CreateAccount error: $e");
      debugPrintStack(stackTrace: stackTrace);

      if (context.mounted) {
        AppDialogs.showMessage(
          context,
          "Failed to create account: ${e.toString()}",
          type: DialogType.error,
        );
      }
      return false;

    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login(BuildContext context) async{
    isLoading = true;
    notifyListeners(); // لتحديث حالة التحميل

    if(formKey.currentState!.validate()){
      try {
        var userCredential = await AuthServices.login(
            email: emailController.text, password: passwordController.text);

        if (userCredential != null && userCredential.user != null) {
          _user = userCredential.user;

          await _fetchUserDataFromFirestore(_user!.uid);

          if (_user!.emailVerified) {
            emailController.clear();
            passwordController.clear();

            AppDialogs.showMessage(context, "Welcome ${_user!.displayName}");

            notifyListeners();
            return true;
          } else {
            AppDialogs.showMessage(context, "Email not Verified, check your email",type: DialogType.error);
          }
        }
      }catch(e){
        AppDialogs.showMessage(context, "Invalid Email Or Password", type: DialogType.error);
      }
    }

    // 4. يتم تنفيذ finally بشكل ضمني:
    isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> signInWithGoogle(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    try {
      var userCredential = await AuthServices.signInWithGoogle();

      if (userCredential != null && userCredential.user != null) {
        _user = userCredential.user;

        // Must fetch Firestore data (like the empty phone number)
        await _fetchUserDataFromFirestore(_user!.uid);

        // Notify listeners to trigger RootScreen navigation (State-Driven Navigation)
        notifyListeners();

        // Optional: Display success message
        if (context.mounted) {
          AppDialogs.showMessage(context, "Welcome ${_user!.displayName ?? 'User'}");
        }
        return true;
      }
    } catch (e, stacktrace) {
      debugPrint("AuthProvider Google error: $e");
      debugPrintStack(stackTrace: stacktrace);

      if (context.mounted) {
        AppDialogs.showMessage(context, "Google Sign-In failed.", type: DialogType.error);
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return false;
  }

  Future<bool> deleteUserAccount(BuildContext context) async {
    if (_user == null) {
      AppDialogs.showMessage(context, "No user signed in.", type: DialogType.error);
      return false;
    }

    isLoading = true;
    notifyListeners();

    try {
      String uid = _user!.uid;

      // 1. Delete the user's document from Firestore (optional but recommended)
      await FirebaseFirestore.instance.collection('users').doc(uid).delete();

      // 2. Delete the Firebase Auth account
      await _user!.delete();

      // 3. Clear local state
      _user = null;
      _userPhone = null;
      localSelectedAvatar = null;

      if (context.mounted) {
        AppDialogs.showMessage(context, "Account deleted successfully.", type: DialogType.success);
      }
      return true;

    } on FirebaseAuthException catch (e) {
      debugPrint("Deletion error: $e");
      String message = "Failed to delete account.";

      // Handle common re-authentication requirement
      if (e.code == 'requires-recent-login' && context.mounted) {
        message = "Please sign in again to confirm account deletion.";
        Navigator.pushReplacementNamed(context, RouteName.login);
        // You would typically navigate the user back to the login screen
        // and instruct them to try deleting immediately after logging in.
      }

      if (context.mounted) {
        AppDialogs.showMessage(context, message, type: DialogType.error);
      }
      return false;

    } catch (e) {
      debugPrint("General deletion error: $e");
      if (context.mounted) {
        AppDialogs.showMessage(context, "An unknown error occurred.", type: DialogType.error);
      }
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    rePasswordController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}