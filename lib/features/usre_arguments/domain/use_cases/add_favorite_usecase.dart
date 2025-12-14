import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../movies/domain/entities/sub_entity/movie.dart';
import '../repo/user_repo.dart';

class AddFavoriteMovieUseCase {
  final UserRepository repository;
  AddFavoriteMovieUseCase({required this.repository});

  Future<Either<Failure, void>> call(MovieSubEntity movie) {
    return repository.addFavoriteMovie(movie);
  }
}
