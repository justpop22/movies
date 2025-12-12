import 'package:firebase_auth/firebase_auth.dart';
import '../../api_response/api_response.dart';

abstract class AuthConsumer {
  Future<ApiResponse<User>> login({
    required String email,
    required String password,
  });

  Future<ApiResponse<User>> signUp({
    required String email,
    required String password,
  });

  Future<ApiResponse<dynamic>> logout();

  Future<ApiResponse<dynamic>> deleteAccount();

  User? getCurrentUser();
  bool isSignedIn();
}
