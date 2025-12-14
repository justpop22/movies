import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/params/movie_detail_params.dart';
import '../../../../core/params/movie_suggestion_params.dart';
import '../../../../core/params/movieparams.dart';
import '../entities/movie_detail_entity.dart';
import '../entities/movie_entity.dart';
import '../entities/movie_suggestion_enity.dart';

abstract class MovieRepository {
  Future<Either<Failure, MovieEntity>> getMoviesList({
    required MovieListParams params,
  });
  Future<Either<Failure, MovieDetailEntity>> getMovieDetails({
    required MovieDetailParams params,
  });
  Future<Either<Failure, MovieSuggestionEntity>> getMovieSuggestions({
    required MovieSuggestionParams params,
  });
}
