import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  static final List<String> defaultAvatars = [
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

  static Future<UserCredential?> createAccount({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String? avatar,
  }) async {
    print("--- STARTING REGISTRATION ---"); // Debug 1

    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      print("--- USER CREATED: ${credential.user?.uid} ---"); // Debug 2

      await credential.user!.updateDisplayName(name);

      if (avatar != null) {
        await credential.user!.updatePhotoURL(avatar);
      }

      await FirebaseFirestore.instance
          .collection("users")
          .doc(credential.user!.uid)
          .set({
        "uid": credential.user!.uid,
        "name": name,
        "email": email,
        "phone": phone,
        "avatarUrl": avatar,
        "created_at": FieldValue.serverTimestamp(),
      });
      print("--- FIRESTORE SAVED ---"); // Debug 3

      print("--- ATTEMPTING TO SEND EMAIL ---"); // Debug 4
      await credential.user!.sendEmailVerification();
      print("--- EMAIL SENT COMMAND FINISHED ---"); // Debug 5

      return credential;

    }

     on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        throw 'The account already exists for that email.';
      } else {
        throw e.message ?? "Error occurred";
      }
    } catch (e) {
      print("createAccount general error: $e");
      rethrow;
    }
  }

  static Future<UserCredential?> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return credential;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  static Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
      if (gUser == null) return null;

      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      final userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

      // If it's a new user, create their Firestore document
      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        final user = userCredential.user!;
        final random = Random();
        // Ensure you have access to the defaultAvatars list
        // Example: final avatar = defaultAvatars[random.nextInt(defaultAvatars.length)];

        // Using a placeholder avatar if defaultAvatars isn't visible here
        final avatar = defaultAvatars[random.nextInt(defaultAvatars.length)];

        await user.updatePhotoURL(avatar);

        // Await Firestore write to ensure data exists before returning
        await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .set({
          "uid": user.uid,
          "name": user.displayName ?? "",
          "email": user.email ?? "",
          // Initialize phone as empty string for later update
          "phone": "",
          "avatarUrl": avatar,
          "created_at": FieldValue.serverTimestamp(),
        });
      }

      return userCredential;
    } catch (e, stacktrace) {
      print("FATAL GOOGLE SIGN-IN ERROR: $e");
      print("STACKTRACE: $stacktrace");
      rethrow;
    }
  }

  static Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
    } catch (e) {
      print("Sign out error: $e");
      rethrow;
    }
  }
}