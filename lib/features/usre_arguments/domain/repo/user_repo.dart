import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../auth/domain/enitiy/user_entity.dart';
import '../../../movies/domain/entities/sub_entity/movie.dart';

abstract class UserRepository {
  Future<Either<Failure, void>> addFavoriteMovie(MovieSubEntity movie);
  Future<Either<Failure, void>> removeFavoriteMovie(int movieId);

  Future<Either<Failure, void>> addWatchHistory(MovieSubEntity movie);
  Future<Either<Failure, void>> removeWatchHistory(int movieId);

  Future<Either<Failure, UserEntity>> updateUserInfo(UserEntity user);

  Future<Either<Failure, List<MovieSubEntity>>> getFavorites();
  Future<Either<Failure, List<MovieSubEntity>>> getWatchHistory();
  Future<Either<Failure, UserEntity>> getUserInfo();
}
