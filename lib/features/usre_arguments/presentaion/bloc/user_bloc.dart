import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/features/usre_arguments/presentaion/bloc/user_events.dart';
import 'package:movies/features/usre_arguments/presentaion/bloc/user_states.dart';

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

    // --- FAVORITES ---
    on<AddFavoriteEvent>((event, emit) async {
      final result = await addFavorite(event.movie);
      result.fold(
            (l) => emit(UserError(l.errMessagge)),
            (r) {
          emit(const UserActionSuccess("Added to Favorites"));
          // Refresh list to update UI immediately
          add( GetFavoritesEvent());
        },
      );
    });

    on<RemoveFavoriteEvent>((event, emit) async {
      final result = await removeFavorite(event.movieId);
      result.fold(
            (l) => emit(UserError(l.errMessagge)),
            (r) {
          emit(const UserActionSuccess("Removed from Favorites"));
          add( GetFavoritesEvent()); // Refresh list
        },
      );
    });

    on<GetFavoritesEvent>((event, emit) async {
      // Don't emit loading if we already have data (prevents flickering)
      final currentUserData = _currentUserData;

      final result = await getFavorites();
      result.fold(
            (l) => emit(UserError(l.errMessagge)),
            (movies) {
          // Merge new favorites with existing user/history data
          emit(currentUserData.copyWith(favorites: movies));
        },
      );
    });

    // --- HISTORY ---
    on<AddHistoryEvent>((event, emit) async {
      final result = await addHistory(event.movie);
      result.fold(
            (l) => emit(UserError(l.errMessagge)),
            (r) {
          // Optional: Emit success or just refresh
          add( GetHistoryEvent());
        },
      );
    });

    on<RemoveHistoryEvent>((event, emit) async {
      final result = await removeHistory(event.movieId);
      result.fold(
            (l) => emit(UserError(l.errMessagge)),
            (r) {
          emit(const UserActionSuccess("Removed from History"));
          add( GetHistoryEvent()); // Refresh list
        },
      );
    });

    on<GetHistoryEvent>((event, emit) async {
      final currentUserData = _currentUserData;

      final result = await getHistory();
      result.fold(
            (l) => emit(UserError(l.errMessagge)),
            (movies) {
          // Merge new history with existing user/favorites data
          emit(currentUserData.copyWith(watchHistory: movies));
        },
      );
    });

    // --- USER INFO ---
    on<GetUserInfoEvent>((event, emit) async {
      final currentUserData = _currentUserData;

      final result = await getUserInfo();
      result.fold(
            (l) => emit(UserError(l.errMessagge)),
            (user) {
          emit(currentUserData.copyWith(user: user));
        },
      );
    });

    on<UpdateUserEvent>((event, emit) async {
      emit(UserLoading());
      final result = await updateUser(event.user);
      result.fold(
            (l) => emit(UserError(l.errMessagge)),
            (user) {
          // Update the user inside the main state object
          emit(_currentUserData.copyWith(user: user));
        },
      );
    });
  }

  // Helper to get current state data or default empty
  UserDataLoaded get _currentUserData {
    if (state is UserDataLoaded) {
      return state as UserDataLoaded;
    }
    return const UserDataLoaded();
  }
}