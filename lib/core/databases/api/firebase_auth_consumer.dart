import 'package:firebase_auth/firebase_auth.dart';
import '../../api_response/api_response.dart';
import 'auth_consumer.dart';

class FirebaseAuthConsumer implements AuthConsumer {
  final FirebaseAuth firebaseAuth;

  FirebaseAuthConsumer({required this.firebaseAuth});

  @override
  Future<ApiResponse<User>> login({
    required String email,
    required String password,
  }) async {
    try {
      final result = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Success(result.user!);
    } on FirebaseAuthException catch (e) {
      return ApiError(e.message ?? "Login failed");
    } catch (e) {
      return ApiError(e.toString());
    }
  }

  @override
  Future<ApiResponse<User>> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final result = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Success(result.user!);
    } on FirebaseAuthException catch (e) {
      return ApiError(e.message ?? "Sign up failed");
    } catch (e) {
      return ApiError(e.toString());
    }
  }

  @override
  Future<ApiResponse<dynamic>> logout() async {
    try {
      await firebaseAuth.signOut();
      return Success(null);
    } catch (e) {
      return ApiError("Logout failed");
    }
  }

  @override
  Future<ApiResponse<dynamic>> deleteAccount() async {
    try {
      final user = firebaseAuth.currentUser;
      if (user != null) {
        await user.delete();
        return Success(null);
      }
      return ApiError("No user found");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        return ApiError("Please log in again to delete your account.");
      }
      return ApiError(e.message ?? "Delete failed");
    } catch (e) {
      return ApiError(e.toString());
    }
  }

  @override
  User? getCurrentUser() => firebaseAuth.currentUser;

  @override
  bool isSignedIn() => firebaseAuth.currentUser != null;
}
