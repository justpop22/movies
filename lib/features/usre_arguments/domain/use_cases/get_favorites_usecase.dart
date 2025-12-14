import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../movies/domain/entities/sub_entity/movie.dart';
import '../repo/user_repo.dart';

class GetFavoritesUseCase {
  final UserRepository repository;
  GetFavoritesUseCase({required this.repository});

  Future<Either<Failure, List<MovieSubEntity>>> call() {
    return repository.getFavorites();
  }
}
