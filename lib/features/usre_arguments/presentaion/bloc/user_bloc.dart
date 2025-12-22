import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:movies/features/usre_arguments/presentaion/bloc/user_events.dart';
import 'package:movies/features/usre_arguments/presentaion/bloc/user_states.dart';

import '../../../../core/errors/failure.dart';
import '../../../auth/domain/enitiy/user_entity.dart';
import '../../../movies/domain/entities/sub_entity/movie.dart';
import '../../domain/use_cases/add_favorite_usecase.dart';
import '../../domain/use_cases/add_history_usecase.dart';
import '../../domain/use_cases/remove_favorite_usecase.dart';
import '../../domain/use_cases/remove_history_usecase.dart';
import '../../domain/use_cases/update_user_usecase.dart';
import '../../domain/use_cases/get_favorites_usecase.dart';
import '../../domain/use_cases/get_history_usecase.dart';
import '../../domain/use_cases/get_user_info_usecase.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final AddFavoriteMovieUseCase addFavorite;
  final RemoveFavoriteMovieUseCase removeFavorite;
  final AddWatchHistoryUseCase addHistory;
  final RemoveWatchHistoryUseCase removeHistory;
  final UpdateUserInfoUseCase updateUser;

  final GetFavoritesUseCase getFavorites;
  final GetWatchHistoryUseCase getHistory;
  final GetUserInfoUseCase getUserInfo;

  UserBloc({
    required this.addFavorite,
    required this.removeFavorite,
    required this.addHistory,
    required this.removeHistory,
    required this.updateUser,
    required this.getFavorites,
    required this.getHistory,
    required this.getUserInfo,
  }) : super(UserInitial()) {
    on<GetUserInfoEvent>((event, emit) async {
      emit(UserLoading());

      final results = await Future.wait([
        getUserInfo(),
        getFavorites(),
        getHistory(),
      ]);

      final userResult = results[0] as Either<Failure, UserEntity?>;
      final favsResult = results[1] as Either<Failure, List<MovieSubEntity>>;
      final historyResult = results[2] as Either<Failure, List<MovieSubEntity>>;

      userResult.fold((failure) => emit(UserError(failure.errMessagge)), (
        user,
      ) {
        final favorites = favsResult.fold((l) => <MovieSubEntity>[], (r) => r);
        final history = historyResult.fold((l) => <MovieSubEntity>[], (r) => r);

        emit(
          UserDataLoaded(
            user: user,
            favorites: favorites,
            watchHistory: history,
          ),
        );
      });
    });

    on<AddFavoriteEvent>((event, emit) async {
      final currentData = _currentUserData;
      final updatedFavorites = List<MovieSubEntity>.from(currentData.favorites)
        ..add(event.movie);
      emit(currentData.copyWith(favorites: updatedFavorites));
      final result = await addFavorite(event.movie);

      result.fold((l) {
        final rollbackList = List<MovieSubEntity>.from(currentData.favorites);
        emit(currentData.copyWith(favorites: rollbackList));
        emit(UserError(l.errMessagge));
      }, (r) => null);
    });

    on<RemoveFavoriteEvent>((event, emit) async {
      final currentData = _currentUserData;
      final updatedFavorites = currentData.favorites
          .where((m) => m.id != event.movieId)
          .toList();
      emit(currentData.copyWith(favorites: updatedFavorites));
      final result = await removeFavorite(event.movieId);
      result.fold((l) {
        emit(currentData.copyWith(favorites: currentData.favorites));
        emit(UserError(l.errMessagge));
      }, (r) => null);
    });

    on<GetFavoritesEvent>((event, emit) async {
      final result = await getFavorites();
      result.fold(
        (l) => emit(UserError(l.errMessagge)),
        (movies) => emit(_currentUserData.copyWith(favorites: movies)),
      );
    });

    on<AddHistoryEvent>((event, emit) async {
      final currentData = _currentUserData;
      final updatedHistory = List<MovieSubEntity>.from(currentData.watchHistory)
        ..add(event.movie);
      emit(currentData.copyWith(watchHistory: updatedHistory));
      final result = await addHistory(event.movie);
      result.fold((l) {
        emit(currentData.copyWith(watchHistory: currentData.watchHistory));
        emit(UserError(l.errMessagge));
      }, (r) => null);
    });

    on<RemoveHistoryEvent>((event, emit) async {
      final currentData = _currentUserData;
      final updatedHistory = currentData.watchHistory
          .where((m) => m.id != event.movieId)
          .toList();
      emit(currentData.copyWith(watchHistory: updatedHistory));
      final result = await removeHistory(event.movieId);
      result.fold((l) {
        emit(currentData.copyWith(watchHistory: currentData.watchHistory));
        emit(UserError(l.errMessagge));
      }, (r) => null);
    });

    on<GetHistoryEvent>((event, emit) async {
      final result = await getHistory();
      result.fold(
        (l) => emit(UserError(l.errMessagge)),
        (movies) => emit(_currentUserData.copyWith(watchHistory: movies)),
      );
    });

    on<UpdateUserEvent>((event, emit) async {
      emit(UserLoading());

      final result = await updateUser(event.user);

      result.fold(
            (l) => emit(UserError(l.errMessagge)),
            (user) {
          emit(UserInfoUpdated(user));

          emit(UserDataLoaded(user: user));
        },
      );
    });
  }

  UserDataLoaded get _currentUserData {
    final currentState = state;
    if (currentState is UserDataLoaded) {
      return currentState;
    }
    return const UserDataLoaded(favorites: [], watchHistory: []);
  }


}
