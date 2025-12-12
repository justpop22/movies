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

    // 1. Fetch Details
    final detailsResult = await getMovieDetails.call(
      params: MovieDetailParams(movieId: event.id),
    );

    // 2. Fetch Suggestions
    final suggestionsResult = await getMovieSuggestions.call(
      params: MovieSuggestionParams(movieId: event.id),
    );

    // 3. Combine Logic
    detailsResult.fold(
          (failure) => emit(MovieDetailsFailure(failure.errMessagge)),
          (movieDetail) {

        // ✅ FIX: Extract the list safely using fold()
        // We initialize an empty list first
        List<MovieSuggestionSubEntity> finalSuggestions = [];

        suggestionsResult.fold(
              (failure) {
            // If suggestions fail, we just keep the empty list (don't show error)
            finalSuggestions = [];
          },
              (successData) {
            // If success, we extract the list based on what your UseCase returns
            // Option A: If successData is the LIST itself
            if (successData is List<MovieSuggestionSubEntity>) {
              finalSuggestions = successData as List<MovieSuggestionSubEntity>;
            }
            // Option B: If successData is the WRAPPER (MovieSuggestionEntity)
            // We assume your wrapper has a property called .movies or .list
            else if (successData is MovieSuggestionEntity) {
              finalSuggestions = successData.movies;
            }
          },
        );

        emit(MovieDetailsLoaded(
          movieDetail: movieDetail,
          suggestions: finalSuggestions,
        ));
      },
    );
  }
}