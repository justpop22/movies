import 'package:dartz/dartz.dart';
import '../../../../core/connection/network_info.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/params/login_params.dart';
import '../../../../core/params/signup_params.dart';
import '../../domain/enitiy/user_entity.dart';
import '../../domain/repositories/auth_repo.dart';
import '../datasources/data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, UserEntity>> login(LoginParams params) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.login(params);
        return Right(user);
      } on ServerException catch (e) {
        return Left(Failure(errMessagge: e.errorModel.errorMessage));
      }
    } else {
      return Left(Failure(errMessagge: "No Internet Connection"));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signUp(SignUpParams params) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.signUp(params);
        return Right(user);
      } on ServerException catch (e) {
        return Left(Failure(errMessagge: e.errorModel.errorMessage));
      }
    } else {
      return Left(Failure(errMessagge: "No Internet Connection"));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(Failure(errMessagge: e.errorModel.errorMessage));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteAccount();
        return const Right(null);
      } on ServerException catch (e) {
        return Left(Failure(errMessagge: e.errorModel.errorMessage));
      }
    } else {
      return Left(Failure(errMessagge: "No Internet Connection"));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.getCurrentUser();
        if (user != null) {
          return Right(user);
        }
        return Left(Failure(errMessagge: "No user logged in"));
      } on ServerException catch (e) {
        return Left(Failure(errMessagge: e.errorModel.errorMessage));
      }
    } else {
      return Left(Failure(errMessagge: "No Internet Connection"));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteDataSource.signInWithGoogle();
        return Right(user);
      } on ServerException catch (e) {
        return Left(Failure(errMessagge: e.errorModel.errorMessage));
      }
    } else {
      return Left(Failure(errMessagge: "No Internet Connection"));
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword(String email) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.forgotPassword(email);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(Failure(errMessagge: e.errorModel.errorMessage));
      }
    } else {
      return Left(Failure(errMessagge: "No Internet Connection"));
    }
  }
}
