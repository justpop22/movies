import 'package:dartz/dartz.dart';
import '../../../../core/connection/network_info.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../auth/domain/enitiy/user_entity.dart';
import '../../../movies/domain/entities/sub_entity/movie.dart';
import '../../domain/repo/user_repo.dart';
import '../datasources/user_remote_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, void>> addFavoriteMovie(MovieSubEntity movie) async {
    if (await networkInfo.isConnected!) {
      try {
        await remoteDataSource.addFavoriteMovie(movie);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(Failure(errMessagge: e.errorModel.errorMessage));
      }
    } else {
      return Left(Failure(errMessagge: "No Internet Connection"));
    }
  }

  @override
  Future<Either<Failure, void>> removeFavoriteMovie(int movieId) async {
    if (await networkInfo.isConnected!) {
      try {
        await remoteDataSource.removeFavoriteMovie(movieId);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(Failure(errMessagge: e.errorModel.errorMessage));
      }
    } else {
      return Left(Failure(errMessagge: "No Internet Connection"));
    }
  }

  @override
  Future<Either<Failure, void>> addWatchHistory(MovieSubEntity movie) async {
    if (await networkInfo.isConnected!) {
      try {
        await remoteDataSource.addWatchHistory(movie);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(Failure(errMessagge: e.errorModel.errorMessage));
      }
    } else {
      return Left(Failure(errMessagge: "No Internet Connection"));
    }
  }

  @override
  Future<Either<Failure, void>> removeWatchHistory(int movieId) async {
    if (await networkInfo.isConnected!) {
      try {
        await remoteDataSource.removeWatchHistory(movieId);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(Failure(errMessagge: e.errorModel.errorMessage));
      }
    } else {
      return Left(Failure(errMessagge: "No Internet Connection"));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateUserInfo(UserEntity user) async {
    if (await networkInfo.isConnected!) {
      try {
        final userModel = UserModel(
          uid: user.uid,
          email: user.email,
          displayName: user.displayName,
          phoneNumber: user.phoneNumber,
          avatarId: user.avatarId,
        );
        final result = await remoteDataSource.updateUserInfo(userModel);
        return Right(result);
      } on ServerException catch (e) {
        return Left(Failure(errMessagge: e.errorModel.errorMessage));
      }
    } else {
      return Left(Failure(errMessagge: "No Internet Connection"));
    }
  }

  @override
  Future<Either<Failure, List<MovieSubEntity>>> getFavorites() async {
    if (await networkInfo.isConnected!) {
      try {
        final result = await remoteDataSource.getFavorites();
        return Right(result);
      } on ServerException catch (e) {
        return Left(Failure(errMessagge: e.errorModel.errorMessage));
      }
    } else {
      return Left(Failure(errMessagge: "No Internet Connection"));
    }
  }

  @override
  Future<Either<Failure, List<MovieSubEntity>>> getWatchHistory() async {
    if (await networkInfo.isConnected!) {
      try {
        final result = await remoteDataSource.getWatchHistory();
        return Right(result);
      } on ServerException catch (e) {
        return Left(Failure(errMessagge: e.errorModel.errorMessage));
      }
    } else {
      return Left(Failure(errMessagge: "No Internet Connection"));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getUserInfo() async {
    if (await networkInfo.isConnected!) {
      try {
        final result = await remoteDataSource.getUserInfo();
        return Right(result);
      } on ServerException catch (e) {
        return Left(Failure(errMessagge: e.errorModel.errorMessage));
      }
    } else {
      return Left(Failure(errMessagge: "No Internet Connection"));
    }
  }
}
