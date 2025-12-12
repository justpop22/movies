import 'package:equatable/equatable.dart';
import '../../../auth/domain/enitiy/user_entity.dart';
import '../../../movies/domain/entities/sub_entity/movie.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class AddFavoriteEvent extends UserEvent {
  final MovieSubEntity movie;
  const AddFavoriteEvent(this.movie);

  @override
  List<Object> get props => [movie];
}

class RemoveFavoriteEvent extends UserEvent {
  final int movieId;
  const RemoveFavoriteEvent(this.movieId);

  @override
  List<Object> get props => [movieId];
}

class AddHistoryEvent extends UserEvent {
  final MovieSubEntity movie;
  const AddHistoryEvent(this.movie);

  @override
  List<Object> get props => [movie];
}

class RemoveHistoryEvent extends UserEvent {
  final int movieId;
  const RemoveHistoryEvent(this.movieId);

  @override
  List<Object> get props => [movieId];
}

class UpdateUserEvent extends UserEvent {
  final UserEntity user;
  const UpdateUserEvent(this.user);

  @override
  List<Object> get props => [user];
}
class GetUserInfoEvent extends UserEvent {}
class GetHistoryEvent extends UserEvent {}
class GetFavoritesEvent extends UserEvent {}