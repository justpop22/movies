import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/core/theme/app_colors.dart';
import '../../../movies/domain/entities/movie_detail_entity.dart';
import '../../../movies/domain/entities/sub_entity/movie.dart';
import '/features/usre_arguments/presentaion/bloc/user_bloc.dart';
import '/features/usre_arguments/presentaion/bloc/user_events.dart';

class MovieAppBar extends StatelessWidget {
  final MovieDetailEntity movie;
  final bool isFavorite;
  final bool isBookMarked;

  const MovieAppBar({
    super.key,
    required this.movie,
    required this.isFavorite,
    required this.isBookMarked,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: AppColors.headerBackground,
      expandedHeight: 450.0,
      pinned: false,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(
          Icons.arrow_back_ios_new,
          color: Colors.white,
          size: 28,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            if (isFavorite) {
              context.read<UserBloc>().add(
                RemoveFavoriteEvent(movieId: movie.id),
              );
            } else {
              context.read<UserBloc>().add(
                AddFavoriteEvent(movie: _createSubEntity()),
              );
            }
          },
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : Colors.white,
            size: 30,
          ),
        ),

        IconButton(
          onPressed: () {
            if (isBookMarked) {
              context.read<UserBloc>().add(
                RemoveHistoryEvent(movieId: movie.id),
              );
            } else {
              context.read<UserBloc>().add(
                AddHistoryEvent(movie: _createSubEntity()),
              );
            }
          },
          icon: Icon(
            isBookMarked ? Icons.bookmark : Icons.bookmark_border,
            color: isBookMarked ? AppColors.secondaryColor : Colors.white,
            size: 30,
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              movie.posterUrl ?? "",
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  Container(color: AppColors.headerBackground),
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black54,
                    AppColors.mainBackground,
                  ],
                  stops: [0.5, 0.8, 1.0],
                ),
              ),
            ),
            Center(
              child: FadeIn(
                duration: const Duration(milliseconds: 500),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryColor.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    size: 45,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 25,
              left: 20,
              right: 20,
              child: FadeInUp(
                duration: const Duration(milliseconds: 500),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      movie.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 2),
                            blurRadius: 10.0,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${movie.year}",
                      style: const TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  MovieSubEntity _createSubEntity() {
    return MovieSubEntity(
      id: movie.id,
      title: movie.title,
      smallCoverImage: movie.posterUrl ?? "",
      rating: movie.rating,
      genres: movie.genres,
      mediumCoverImage: movie.posterUrl ?? "",
      largeCoverImage: movie.posterUrl ?? "",
    );
  }
}
