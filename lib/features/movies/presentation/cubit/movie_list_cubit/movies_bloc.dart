import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:movies/core/params/movieparams.dart';
import 'package:stream_transform/stream_transform.dart';

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
      transformer: debounceRestartable(const Duration(milliseconds: 500)),
    );
    on<ResetSearchEvent>((event, emit) {
      page = 1;
      emit(MoviesInitial());
    });
  }

  Future<void> _onSearchMovies(
    SearchMoviesEvent event,
    Emitter<MoviesState> emit,
  ) async {
    emit(MoviesLoading());
    page = 1;

    try {
      final result = await getMoviesList.call(
        params: MovieListParams(queryTerm: event.queryTerm, page: page),
      );

      result.fold((failure) => emit(MoviesFailure(failure.errMessagge)), (
        wrapper,
      ) {
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

  Future<void> _onGetMovies(
    GetMoviesEvent event,
    Emitter<MoviesState> emit,
  ) async {
    if (state is MoviesLoaded && (state as MoviesLoaded).hasReachedMax) return;

    try {
      if (state is MoviesInitial) {
        emit(MoviesLoading());
        page = 1;

        final result = await getMoviesList.call(
          params: event.params.copyWith(page: page),
        );

        result.fold((failure) => emit(MoviesFailure(failure.errMessagge)), (
          wrapper,
        ) {
          page++;
          emit(
            MoviesLoaded(
              movies: wrapper.movie,
              hasReachedMax: wrapper.movie.isEmpty,
            ),
          );
        });
        return;
      }

      if (state is MoviesLoaded) {
        final currentState = state as MoviesLoaded;
        final result = await getMoviesList.call(
          params: event.params.copyWith(page: page),
        );

        result.fold((failure) => emit(MoviesFailure(failure.errMessagge)), (
          newMovieWrapper,
        ) {
          if (newMovieWrapper.movie.isEmpty) {
            emit(currentState.copyWith(hasReachedMax: true));
          } else {
            page++;
            emit(
              MoviesLoaded(
                movies: currentState.movies + newMovieWrapper.movie,
                hasReachedMax: false,
              ),
            );
          }
        });
      }
    } catch (e) {
      emit(MoviesFailure(e.toString()));
    }
  }
}
