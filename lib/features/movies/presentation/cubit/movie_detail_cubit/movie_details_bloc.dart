import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/params/movie_detail_params.dart';
import '../../../../../core/params/movie_suggestion_params.dart';
import '../../../domain/entities/movie_detail_entity.dart';
import '../../../domain/entities/movie_suggestion_enity.dart';
import '../../../domain/entities/sub_entity/movie_suggestion_sub_entity.dart';
import '../../../domain/usecases/get_movie_details.dart';
import '../../../domain/usecases/get_movie_suggestions.dart';
import 'movie_details_event.dart';
import 'movie_details_state.dart';

class MovieDetailsBloc extends Bloc<MovieDetailsEvent, MovieDetailsState> {
  final GetMovieDetails getMovieDetails;
  final GetMovieSuggestions getMovieSuggestions;

  MovieDetailsBloc({
    required this.getMovieDetails,
    required this.getMovieSuggestions,
  }) : super(MovieDetailsInitial()) {
    on<GetMovieDetailsEvent>(_onGetMovieDetails);
  }

  Future<void> _onGetMovieDetails(
    GetMovieDetailsEvent event,
    Emitter<MovieDetailsState> emit,
  ) async {
    emit(MovieDetailsLoading());

    final results = await Future.wait([
      getMovieDetails.call(params: MovieDetailParams(movieId: event.id)),
      getMovieSuggestions.call(
        params: MovieSuggestionParams(movieId: event.id),
      ),
    ]);

    final detailsResult = results[0] as Either<Failure, MovieDetailEntity>;
    final suggestionsResult = results[1] as Either<Failure, dynamic>;

    detailsResult.fold(
      (failure) => emit(MovieDetailsFailure(failure.errMessagge)),
      (movieDetail) {
        List<MovieSuggestionSubEntity> finalSuggestions = [];

        suggestionsResult.fold((failure) => finalSuggestions = [], (
          successData,
        ) {
          if (successData is List<MovieSuggestionSubEntity>) {
            finalSuggestions = successData;
          } else if (successData is MovieSuggestionEntity) {
            finalSuggestions = successData.movies;
          }
        });

        emit(
          MovieDetailsLoaded(
            movieDetail: movieDetail,
            suggestions: finalSuggestions,
          ),
        );
      },
    );
  }
}
