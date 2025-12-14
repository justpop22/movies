import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/errors/error_model.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../movies/data/models/submodels/movies.dart';
import '../../../movies/domain/entities/sub_entity/movie.dart';

abstract class UserRemoteDataSource {
  Future<void> addFavoriteMovie(MovieSubEntity movie);
  Future<void> removeFavoriteMovie(int movieId);
  Future<void> addWatchHistory(MovieSubEntity movie);
  Future<void> removeWatchHistory(int movieId);
  Future<UserModel> updateUserInfo(UserModel user);
  Future<List<MovieModel>> getFavorites();
  Future<List<MovieModel>> getWatchHistory();
  Future<UserModel> getUserInfo();
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  UserRemoteDataSourceImpl({
    required this.firestore,
    required this.firebaseAuth,
  });

  String get _uid {
    final user = firebaseAuth.currentUser;
    if (user == null) {
      throw ServerException(
        ErrorModel(status: 401, errorMessage: "User not logged in"),
      );
    }
    return user.uid;
  }

  MovieModel _toModel(MovieSubEntity entity) {
    return MovieModel(
      id: entity.id,
      title: entity.title,
      mediumCoverImage: entity.mediumCoverImage,
      rating: entity.rating,
      genres: entity.genres,
      smallCoverImage: '',
      largeCoverImage: '',
    );
  }

  @override
  Future<void> addFavoriteMovie(MovieSubEntity movie) async {
    try {
      await firestore
          .collection('users')
          .doc(_uid)
          .collection('favorites')
          .doc(movie.id.toString())
          .set(_toModel(movie).toJson());
    } catch (e) {
      throw ServerException(
        ErrorModel(status: 500, errorMessage: e.toString()),
      );
    }
  }

  @override
  Future<void> removeFavoriteMovie(int movieId) async {
    try {
      await firestore
          .collection('users')
          .doc(_uid)
          .collection('favorites')
          .doc(movieId.toString())
          .delete();
    } catch (e) {
      throw ServerException(
        ErrorModel(status: 500, errorMessage: e.toString()),
      );
    }
  }

  @override
  Future<void> addWatchHistory(MovieSubEntity movie) async {
    try {
      final data = _toModel(movie).toJson();
      data['timestamp'] = FieldValue.serverTimestamp();

      await firestore
          .collection('users')
          .doc(_uid)
          .collection('history')
          .doc(movie.id.toString())
          .set(data);
    } catch (e) {
      throw ServerException(
        ErrorModel(status: 500, errorMessage: e.toString()),
      );
    }
  }

  @override
  Future<void> removeWatchHistory(int movieId) async {
    try {
      await firestore
          .collection('users')
          .doc(_uid)
          .collection('history')
          .doc(movieId.toString())
          .delete();
    } catch (e) {
      throw ServerException(
        ErrorModel(status: 500, errorMessage: e.toString()),
      );
    }
  }

  @override
  Future<UserModel> updateUserInfo(UserModel user) async {
    try {
      await firestore.collection('users').doc(_uid).update({
        'name': user.displayName,
        'phone': user.phoneNumber,
        'avatarId': user.avatarId,
      });
      return user;
    } catch (e) {
      throw ServerException(
        ErrorModel(status: 500, errorMessage: e.toString()),
      );
    }
  }

  @override
  Future<List<MovieModel>> getFavorites() async {
    try {
      final snapshot = await firestore
          .collection('users')
          .doc(_uid)
          .collection('favorites')
          .get();

      return snapshot.docs
          .map((doc) => MovieModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw ServerException(
        ErrorModel(status: 500, errorMessage: e.toString()),
      );
    }
  }

  @override
  Future<List<MovieModel>> getWatchHistory() async {
    try {
      final snapshot = await firestore
          .collection('users')
          .doc(_uid)
          .collection('history')
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => MovieModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw ServerException(
        ErrorModel(status: 500, errorMessage: e.toString()),
      );
    }
  }

  @override
  Future<UserModel> getUserInfo() async {
    try {
      final doc = await firestore.collection('users').doc(_uid).get();
      if (doc.exists) {
        return UserModel.fromJson(doc.data()!);
      } else {
        final user = firebaseAuth.currentUser!;
        return UserModel.fromFirebaseUser(user);
      }
    } catch (e) {
      throw ServerException(
        ErrorModel(status: 500, errorMessage: e.toString()),
      );
    }
  }
}
