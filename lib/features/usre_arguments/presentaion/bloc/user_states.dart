import 'package:equatable/equatable.dart';
import '../../../auth/domain/enitiy/user_entity.dart';
import '../../../movies/domain/entities/sub_entity/movie.dart';

abstract class UserState extends Equatable {
  const UserState();
  @override
  List<Object> get props => [];
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

class UserDataLoaded extends UserState {
  final UserEntity user;
  const UserDataLoaded(this.user);
  @override
  List<Object> get props => [user];
}