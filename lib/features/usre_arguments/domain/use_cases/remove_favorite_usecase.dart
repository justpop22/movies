import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../repo/user_repo.dart';

class RemoveFavoriteMovieUseCase {
  final UserRepository repository;
  RemoveFavoriteMovieUseCase({required this.repository});

  Future<Either<Failure, void>> call(int movieId) {
    return repository.removeFavoriteMovie(movieId);
  }
}
