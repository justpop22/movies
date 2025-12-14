import 'package:equatable/equatable.dart';
import '../../../auth/domain/enitiy/user_entity.dart';
import '../../../movies/domain/entities/sub_entity/movie.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserActionSuccess extends UserState {
  final String message;
  const UserActionSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class UserError extends UserState {
  final String message;
  const UserError(this.message);

  @override
  List<Object> get props => [message];
}

class UserDataLoaded extends UserState {
  final UserEntity? user;
  final List<MovieSubEntity> favorites;
  final List<MovieSubEntity> watchHistory;

  const UserDataLoaded({
    this.user,
    this.favorites = const [],
    this.watchHistory = const [],
  });

  UserDataLoaded copyWith({
    UserEntity? user,
    List<MovieSubEntity>? favorites,
    List<MovieSubEntity>? watchHistory,
  }) {
    return UserDataLoaded(
      user: user ?? this.user,
      favorites: favorites ?? this.favorites,
      watchHistory: watchHistory ?? this.watchHistory,
    );
  }

  @override
  List<Object?> get props => [user, favorites, watchHistory];
}

class UserInfoUpdated extends UserState {
  final UserEntity user;
  const UserInfoUpdated(this.user);
  @override
  List<Object> get props => [user];
}

class FavoritesLoaded extends UserState {
  final List<MovieSubEntity> movies;
  const FavoritesLoaded(this.movies);
  @override
  List<Object> get props => [movies];
}

class HistoryLoaded extends UserState {
  final List<MovieSubEntity> movies;
  const HistoryLoaded(this.movies);
  @override
  List<Object> get props => [movies];
}
