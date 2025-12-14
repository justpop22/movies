import 'package:movies/features/movies/data/models/movie_suggestion_model.dart';
import '../../../../core/databases/api/api_consumer.dart';
import '../../../../core/databases/api/end_points.dart';
import '../../../../core/params/movie_detail_params.dart';
import '../../../../core/params/movie_suggestion_params.dart';
import '../../../../core/params/movieparams.dart';
import '../models/movie_detail.dart';
import '../models/movie_model.dart';

abstract class MovieRemoteDataSource {
  Future<MovieList> getMoviesList(MovieListParams params);

  Future<MovieDetailModel> getMovieDetails(MovieDetailParams params);

  Future<MovieSuggestionModel> getMovieSuggestions(
    MovieSuggestionParams params,
  );
}

class MovieRemoteDataSourceImpl extends MovieRemoteDataSource {
  late final ApiConsumer api;
  MovieRemoteDataSourceImpl({required this.api});

  Future<MovieList> getMoviesList(MovieListParams params) async {
    final response = await api.get(
      EndPoints.listMovies,
      queryParameters: {
        ApiKey.page: params.page,
        ApiKey.limit: params.limit,
        if (params.queryTerm != null) ApiKey.queryTerm: params.queryTerm,
        if (params.genre != null) ApiKey.genre: params.genre,
        if (params.sortBy != null) ApiKey.sortBy: params.sortBy,
      },
    );
    return MovieList.fromJson(response[ApiKey.data]);
  }

  Future<MovieDetailModel> getMovieDetails(MovieDetailParams params) async {
    final response = await api.get(
      EndPoints.movieDetails,
      queryParameters: {
        ApiKey.movieId: params.movieId,
        if (params.withCast) ApiKey.withCast: true,
        if (params.withImages) ApiKey.withImages: true,
      },
    );
    return MovieDetailModel.fromJson(response[ApiKey.data][ApiKey.movie]);
  }

  Future<MovieSuggestionModel> getMovieSuggestions(
    MovieSuggestionParams params,
  ) async {
    final response = await api.get(
      EndPoints.movieSuggestions,
      queryParameters: {ApiKey.movieId: params.movieId},
    );
    return MovieSuggestionModel.fromJson(response[ApiKey.data]);
  }
}
