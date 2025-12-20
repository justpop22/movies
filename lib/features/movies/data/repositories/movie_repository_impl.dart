import 'package:dartz/dartz.dart';
import 'package:movies/core/params/movie_suggestion_params.dart';
import '../../../../core/connection/network_info.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/params/movie_detail_params.dart';
import '../../../../core/params/movieparams.dart';
import '../../domain/entities/movie_detail_entity.dart';
import '../../domain/entities/movie_entity.dart';
import '../../domain/entities/movie_suggestion_enity.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/movies_local_data_source.dart';
import '../datasources/movies_remote_data_source.dart';
import '../models/movie_model.dart';
import '../models/submodels/movies.dart';

class MovieRepositoryImpl extends MovieRepository {
  final NetworkInfo networkInfo;
  final MovieRemoteDataSource remoteDataSource;
  final MovieLocalDataSource localDataSource;
  final Map<String, MovieEntity> _memoryCache = {};
  MovieRepositoryImpl({
    required this.networkInfo,
    required this.remoteDataSource,
    required this.localDataSource,
  });
  @override
  Future<Either<Failure, MovieEntity>> getMoviesList({
    required MovieListParams params,
  }) async {
    final cacheKey = "${params.genre}_${params.sortBy}_${params.queryTerm}";

    if (_memoryCache.containsKey(cacheKey) &&
        (params.page == 1 || params.page == null)) {
      return Right(_memoryCache[cacheKey]!);
    }

    if (await networkInfo.isConnected!) {
      try {
        final remoteMovies =
            await remoteDataSource.getMoviesList(params) as MovieList;

        if (params.page == 1 || params.page == null) {
          _memoryCache[cacheKey] = remoteMovies;
        } else {
          final existing = _memoryCache[cacheKey];
          if (existing != null) {
            final combinedMovies = [
              ...existing.movie!.cast<MovieModel>(),
              ...remoteMovies.movie!.cast<MovieModel>(),
            ];

            _memoryCache[cacheKey] = MovieList(
              movie: combinedMovies,
              movieCount: remoteMovies.movieCount,
              limit: remoteMovies.limit,
              pageNumber: remoteMovies.pageNumber,
            );
          }
        }

        localDataSource.cacheMovies(remoteMovies);
        return Right(_memoryCache[cacheKey] ?? remoteMovies);
      } on ServerException catch (e) {
        return Left(Failure(errMessagge: e.errorModel.errorMessage));
      }
    } else {
      try {
        final localMovies = await localDataSource.getLastMovies();
        return Right(localMovies);
      } on CacheException catch (e) {
        return Left(Failure(errMessagge: e.errorMessage));
      }
    }
  }

  @override
  Future<Either<Failure, MovieDetailEntity>> getMovieDetails({
    required MovieDetailParams params,
  }) async {
    if (await networkInfo.isConnected!) {
      try {
        final remoteMovie = await remoteDataSource.getMovieDetails(params);
        return Right(remoteMovie);
      } on ServerException catch (e) {
        return Left(Failure(errMessagge: e.errorModel.errorMessage));
      }
    } else {
      return Left(Failure(errMessagge: "No Internet Connection"));
    }
  }

  Future<Either<Failure, MovieSuggestionEntity>> getMovieSuggestions({
    required MovieSuggestionParams params,
  }) async {
    if (await networkInfo.isConnected!) {
      try {
        final remoteMovie = await remoteDataSource.getMovieSuggestions(params);
        return Right(remoteMovie);
      } on ServerException catch (e) {
        return Left(Failure(errMessagge: e.errorModel.errorMessage));
      }
    } else {
      return Left(Failure(errMessagge: "No Internet Connection"));
    }
  }
}
