import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/api_response/api_response.dart';
import '../../../../core/databases/api/auth_consumer.dart';
import '../../../../core/errors/error_model.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/params/login_params.dart';
import '../../../../core/params/signup_params.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(LoginParams params);
  Future<UserModel> signUp(SignUpParams params);
  Future<void> logout();
  Future<void> deleteAccount();
  Future<UserModel?> getCurrentUser();
  Future<UserModel> signInWithGoogle();
  Future<void> forgotPassword(String email);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AuthConsumer authConsumer;
  final FirebaseFirestore firestore;
  final GoogleSignIn googleSignIn;

  AuthRemoteDataSourceImpl({
    required this.authConsumer,
    required this.firestore,
    required this.googleSignIn,
  });

  @override
  Future<UserModel> login(LoginParams params) async {
    final response = await authConsumer.login(
      email: params.emailOrUsername,
      password: params.password,
    );

    switch (response) {
      case Success(data: final firebaseUser):
        final doc = await firestore
            .collection('users')
            .doc(firebaseUser.uid)
            .get();
        if (doc.exists) {
          return UserModel.fromJson(doc.data()!);
        }
        return UserModel.fromFirebaseUser(firebaseUser);

      case ApiError(message: final msg):
        throw ServerException(ErrorModel(status: 400, errorMessage: msg));
    }
  }

  @override
  Future<UserModel> signUp(SignUpParams params) async {
    final response = await authConsumer.signUp(
      email: params.email,
      password: params.password,
    );

    switch (response) {
      case Success(data: final firebaseUser):
        final newUser = UserModel(
          uid: firebaseUser.uid,
          email: params.email,
          displayName: params.name,
          phoneNumber: params.phone,
          avatarId: params.avatarId,
        );

        await firestore
            .collection('users')
            .doc(newUser.uid)
            .set(newUser.toMap());

        return newUser;

      case ApiError(message: final msg):
        throw ServerException(ErrorModel(status: 400, errorMessage: msg));
    }
  }

  @override
  Future<void> logout() async {
    final response = await authConsumer.logout();

    switch (response) {
      case Success(data: _):
        return;
      case ApiError(message: final msg):
        throw ServerException(ErrorModel(status: 400, errorMessage: msg));
    }
  }

  @override
  Future<void> deleteAccount() async {
    final user = authConsumer.getCurrentUser();

    if (user != null) {
      await firestore.collection('users').doc(user.uid).delete();
    }

    final response = await authConsumer.deleteAccount();

    switch (response) {
      case Success(data: _):
        return;
      case ApiError(message: final msg):
        throw ServerException(ErrorModel(status: 400, errorMessage: msg));
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = authConsumer.getCurrentUser();
    if (user != null) {
      final doc = await firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        return UserModel.fromJson(doc.data()!);
      }
      return UserModel.fromFirebaseUser(user);
    }
    return null;
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? gUser = await googleSignIn.signIn();
      if (gUser == null) {
        throw ServerException(
          ErrorModel(status: 400, errorMessage: "Google Sign In Cancelled"),
        );
      }

      final GoogleSignInAuthentication gAuth = await gUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      final firebaseUser = userCredential.user!;

      final docSnapshot = await firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      if (docSnapshot.exists) {
        return UserModel.fromJson(docSnapshot.data()!);
      } else {
        final newUser = UserModel.fromFirebaseUser(
          firebaseUser,
        ).copyWith(phoneNumber: "", avatarId: 0);

        await firestore
            .collection('users')
            .doc(firebaseUser.uid)
            .set(newUser.toMap());
        return newUser;
      }
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        ErrorModel(
          status: 401,
          errorMessage: e.message ?? "Google login failed.",
        ),
      );
    } catch (e) {
      throw ServerException(
        ErrorModel(status: 500, errorMessage: e.toString()),
      );
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        ErrorModel(
          status: 400,
          errorMessage: e.message ?? "Password reset failed.",
        ),
      );
    } catch (e) {
      throw ServerException(
        ErrorModel(status: 500, errorMessage: e.toString()),
      );
    }
  }
}
