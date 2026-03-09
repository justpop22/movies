import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:movies/core/params/movieparams.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../domain/entities/sub_entity/movie.dart';
import '../../../domain/usecases/get_movie_list.dart';
import 'movies_event.dart';
import 'movies_state.dart';

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

EventTransformer<E> debounceRestartable<E>(Duration duration) {
  return (events, mapper) {
    return restartable<E>().call(events.debounce(duration), mapper);
  };
}

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  final GetMoviesList getMoviesList;
  int page = 1;

  MoviesBloc({required this.getMoviesList}) : super(MoviesInitial()) {
    on<GetMoviesEvent>(
      _onGetMovies,
      transformer: throttleDroppable(const Duration(milliseconds: 100)),
    );

    on<SearchMoviesEvent>(
      _onSearchMovies,
      transformer: debounceRestartable(const Duration(milliseconds: 300)),
    );

    on<ResetSearchEvent>((event, emit) {
      page = 1;
      emit(MoviesInitial());
    });
  }

  Future<void> _onGetMovies(
      GetMoviesEvent event,
      Emitter<MoviesState> emit,
      ) async {
    // 1. Stop if we have already fetched the very last page
    if (state is MoviesLoaded && (state as MoviesLoaded).hasReachedMax) return;

    try {
      // 2. Only show the full-screen loading spinner on the VERY FIRST fetch
      if (state is MoviesInitial) {
        emit(MoviesLoading());
        page = 1;
      }

      // 3. Fetch using the current page
      final result = await getMoviesList.call(
        params: event.params.copyWith(page: page),
      );

      result.fold((failure) => emit(MoviesFailure(failure.errMessagge)), (
          wrapper,
          ) {
        final isLastPage = wrapper.movie.isEmpty;

        if (!isLastPage) {
          page++;
        }

        emit(
          MoviesLoaded(
            // REMOVE oldMovies + wrapper.movie
            // JUST USE wrapper.movie since it already has everything!
            movies: wrapper.movie,
            hasReachedMax: isLastPage,
          ),
        );
      });
    } catch (e) {
      emit(MoviesFailure(e.toString()));
    }
  }

  Future<void> _onSearchMovies(
      SearchMoviesEvent event,
      Emitter<MoviesState> emit,
      ) async {
    if (event.queryTerm.trim().isEmpty) {
      add(ResetSearchEvent());
      return;
    }

    // Always reset to page 1 and show loading when starting a new search
    emit(MoviesLoading());
    page = 1;

    try {
      final result = await getMoviesList.call(
        params: MovieListParams(queryTerm: event.queryTerm, page: page),
      );

      result.fold((failure) => emit(MoviesFailure(failure.errMessagge)), (
          wrapper,
          ) {
        if (wrapper.movie.isNotEmpty) {
          page++;
        }

        emit(
          MoviesLoaded(
            movies: wrapper.movie,
            hasReachedMax: wrapper.movie.isEmpty,
          ),
        );
      });
    } catch (e) {
      emit(MoviesFailure(e.toString()));
    }
  }
}