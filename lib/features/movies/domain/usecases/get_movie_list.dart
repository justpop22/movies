import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/params/movieparams.dart';
import '../entities/movie_entity.dart';
import '../repositories/movie_repository.dart';

class GetMoviesList {
  final MovieRepository repository;

  GetMoviesList({required this.repository});
  Future<Either<Failure, MovieEntity>> call({required MovieListParams params}) {
    return repository.getMoviesList(params: params);
  }
}
