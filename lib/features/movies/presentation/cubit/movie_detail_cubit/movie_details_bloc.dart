import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/params/movie_detail_params.dart';
import '../../../../../core/params/movie_suggestion_params.dart';
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

    final detailsResult = await getMovieDetails.call(
      params: MovieDetailParams(movieId: event.id),
    );

    final suggestionsResult = await getMovieSuggestions.call(
      params: MovieSuggestionParams(movieId: event.id),
    );

    detailsResult.fold(
      (failure) => emit(MovieDetailsFailure(failure.errMessagge)),
      (movieDetail) {
        List<MovieSuggestionSubEntity> finalSuggestions = [];

        suggestionsResult.fold(
          (failure) {
            finalSuggestions = [];
          },
          (successData) {
            if (successData is List<MovieSuggestionSubEntity>) {
              finalSuggestions = successData as List<MovieSuggestionSubEntity>;
            } else if (successData is MovieSuggestionEntity) {
              finalSuggestions = successData.movies;
            }
          },
        );

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
