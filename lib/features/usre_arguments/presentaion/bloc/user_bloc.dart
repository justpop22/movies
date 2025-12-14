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
    on<AddFavoriteEvent>((event, emit) async {
      final result = await addFavorite(event.movie);
      result.fold((l) => emit(UserError(l.errMessagge)), (r) {
        emit(const UserActionSuccess("Added to Favorites"));

        add(GetFavoritesEvent());
      });
    });

    on<RemoveFavoriteEvent>((event, emit) async {
      final result = await removeFavorite(event.movieId);
      result.fold((l) => emit(UserError(l.errMessagge)), (r) {
        emit(const UserActionSuccess("Removed from Favorites"));
        add(GetFavoritesEvent());
      });
    });

    on<GetFavoritesEvent>((event, emit) async {
      final currentUserData = _currentUserData;

      final result = await getFavorites();
      result.fold((l) => emit(UserError(l.errMessagge)), (movies) {
        emit(currentUserData.copyWith(favorites: movies));
      });
    });

    on<AddHistoryEvent>((event, emit) async {
      final result = await addHistory(event.movie);
      result.fold((l) => emit(UserError(l.errMessagge)), (r) {
        add(GetHistoryEvent());
      });
    });

    on<RemoveHistoryEvent>((event, emit) async {
      final result = await removeHistory(event.movieId);
      result.fold((l) => emit(UserError(l.errMessagge)), (r) {
        emit(const UserActionSuccess("Removed from History"));
        add(GetHistoryEvent());
      });
    });

    on<GetHistoryEvent>((event, emit) async {
      final currentUserData = _currentUserData;

      final result = await getHistory();
      result.fold((l) => emit(UserError(l.errMessagge)), (movies) {
        emit(currentUserData.copyWith(watchHistory: movies));
      });
    });

    on<GetUserInfoEvent>((event, emit) async {
      final currentUserData = _currentUserData;

      final result = await getUserInfo();
      result.fold((l) => emit(UserError(l.errMessagge)), (user) {
        emit(currentUserData.copyWith(user: user));
      });
    });

    on<UpdateUserEvent>((event, emit) async {
      emit(UserLoading());
      final result = await updateUser(event.user);
      result.fold((l) => emit(UserError(l.errMessagge)), (user) {
        emit(_currentUserData.copyWith(user: user));
      });
    });
  }

  UserDataLoaded get _currentUserData {
    if (state is UserDataLoaded) {
      return state as UserDataLoaded;
    }
    return const UserDataLoaded();
  }
}
