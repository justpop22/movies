import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/core/theme/app_colors.dart';
import 'package:movies/core/widgets/movie_grid_item.dart';

import '../../../core/services/service_locater.dart';
import '../../../features/movies/domain/entities/movie_detail_entity.dart';
import '../../../features/movies/presentation/cubit/movie_detail_cubit/movie_details_bloc.dart';
import '../../../features/movies/presentation/cubit/movie_detail_cubit/movie_details_event.dart';
import '../../../features/movies/presentation/cubit/movie_detail_cubit/movie_details_state.dart';
import '../../../features/usre_arguments/presentaion/bloc/user_bloc.dart';
import '../../../features/usre_arguments/presentaion/bloc/user_events.dart';
// ✅ Import UserState to access UserDataLoaded
import '../../../features/usre_arguments/presentaion/bloc/user_states.dart';
import '../../../features/movies/domain/entities/sub_entity/movie.dart'; // Import MovieSubEntity

class MovieDetailsScreen extends StatelessWidget {
  final int movieId;

  const MovieDetailsScreen({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      sl<MovieDetailsBloc>()..add(GetMovieDetailsEvent(id: movieId)),
      child: const _MovieDetailsContent(),
    );
  }
}

class _MovieDetailsContent extends StatefulWidget {
  const _MovieDetailsContent();

  @override
  State<_MovieDetailsContent> createState() => _MovieDetailsContentState();
}

class _MovieDetailsContentState extends State<_MovieDetailsContent> {
  @override
  void initState() {
    super.initState();
    // ✅ Ensure UserBloc has the latest data when entering this screen
    context.read<UserBloc>().add( GetFavoritesEvent());
    context.read<UserBloc>().add( GetHistoryEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      // 1. Listen to Movie Details Bloc
      body: BlocBuilder<MovieDetailsBloc, MovieDetailsState>(
        builder: (context, movieState) {
          if (movieState is MovieDetailsLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.secondaryColor),
            );
          }

          if (movieState is MovieDetailsFailure) {
            return Center(
              child: Text(
                movieState.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (movieState is MovieDetailsLoaded) {
            final movie = movieState.movieDetail;
            final suggestions = movieState.suggestions;
            final String imagePath = movie.posterUrl  ?? "";
            final String duration = (movie.runtime ?? 0).toString();

            return BlocBuilder<UserBloc, UserState>(
              builder: (context, userState) {

                // ✅ CHECK STATUS: Is this movie in the lists?
                bool isFavorite = false;
                bool isBookMarked = false;

                if (userState is UserDataLoaded) {
                  // Check by ID
                  isFavorite = userState.favorites.any((m) => m.id == movie.id);
                  isBookMarked = userState.watchHistory.any((m) => m.id == movie.id);
                }

                return CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    _buildAppBar(
                      context,
                      imagePath,
                      movie.year.toString(),
                      movie.title,
                      duration,
                      movie,
                      isFavorite,   // ✅ Pass calculated status
                      isBookMarked, // ✅ Pass calculated status
                    ),
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Watch Button
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.dangerColor,
                                  foregroundColor: AppColors.primaryText,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: const Text(
                                  'Watch',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Stats Section
                          MovieStatsSection(
                            rating: movie.rating.toString(),
                            duration: duration,
                            likeCount: movie.likeCount,
                          ),
                          const SizedBox(height: 20),

                          // Screenshots Section
                          MovieScreenshotsSection(screenshotUrls: movie.screenshots),

                          // Genres
                          _buildSectionTitle('Genres'),
                          _buildGenresRow(movie.genres),

                          // Summary
                          _buildSectionTitle('Summary'),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              movie.descriptionFull.isNotEmpty
                                  ? movie.descriptionFull
                                  : "No description available.",
                              style: const TextStyle(
                                color: AppColors.secondaryText,
                                fontSize: 15,
                                height: 1.6,
                              ),
                            ),
                          ),

                          if (movie.cast.isNotEmpty) ...[
                            _buildSectionTitle('Cast'),
                            MovieCastSection(castList: movie.cast),
                          ],

                          if (suggestions.isNotEmpty) ...[
                            _buildSectionTitle('Similar'),
                            _buildSimilarMoviesList(suggestions),
                          ],
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return FadeInUp(
      from: 20,
      duration: const Duration(milliseconds: 500),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 30, 20, 15),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(
      BuildContext context,
      String posterPath,
      String year,
      String title,
      String runtime,
      MovieDetailEntity movieDetail,
      bool isFavorite,   // ✅ Receive Status
      bool isBookMarked, // ✅ Receive Status
      ) {
    return SliverAppBar(
      backgroundColor: AppColors.headerBackground,
      expandedHeight: 450.0,
      pinned: false,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 28),
      ),
      actions: [
        // --- 1. FAVORITE BUTTON ---
        IconButton(
          onPressed: () {
            // ✅ Toggle Logic: If already favorite, remove it. Else, add it.
            if (isFavorite) {
              context.read<UserBloc>().add(RemoveFavoriteEvent(movieId: movieDetail.id));
            } else {
              // Create Entity
              final entity = MovieSubEntity(
                id: movieDetail.id,
                title: movieDetail.title,
                smallCoverImage: movieDetail.posterUrl ?? "",
                rating: movieDetail.rating,
                genres: movieDetail.genres,
                mediumCoverImage: movieDetail.posterUrl ?? "",
                largeCoverImage: movieDetail.posterUrl ?? "",
              );
              context.read<UserBloc>().add(AddFavoriteEvent(movie: entity));
            }
          },
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : Colors.white,
            size: 30,
          ),
        ),

        // --- 2. BOOKMARK BUTTON ---
        IconButton(
          onPressed: () {
            // ✅ Toggle Logic
            if (isBookMarked) {
              context.read<UserBloc>().add(RemoveHistoryEvent(movieId: movieDetail.id));
            } else {
              final entity = MovieSubEntity(
                id: movieDetail.id,
                title: movieDetail.title,
                smallCoverImage: movieDetail.posterUrl ?? "",
                rating: movieDetail.rating,
                genres: movieDetail.genres,
                mediumCoverImage: movieDetail.posterUrl ?? "",
                largeCoverImage: movieDetail.posterUrl ?? "",
              );
              context.read<UserBloc>().add(AddHistoryEvent(movie: entity));
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
              posterPath,
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
                  child: const Icon(Icons.play_arrow, size: 45, color: Colors.black),
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
                      title,
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
                      "$year • $runtime min",
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

  Widget _buildSimilarMoviesList(List<dynamic> suggestions) {
    return FadeInUp(
      delay: const Duration(milliseconds: 200),
      duration: const Duration(milliseconds: 500),
      child: Container(
        height: 230,
        margin: const EdgeInsets.only(bottom: 20),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
            final movie = suggestions[index];
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: SizedBox(
                width: 130,
                child: MovieGridItem(
                  movieId: movie.id,
                  rating: movie.rating.toString(),
                  imagePath: movie.mediumCoverImage ?? "",
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildGenresRow(List<String> genres) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: genres
            .map(
              (genre) => Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: AppColors.headerBackground,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              genre,
              style: const TextStyle(
                color: AppColors.primaryText,
                fontSize: 13,
              ),
            ),
          ),
        )
            .toList(),
      ),
    );
  }
}

// --- Included Helper Classes ---
class MovieCastSection extends StatelessWidget {
  final List<dynamic> castList;
  const MovieCastSection({super.key, required this.castList});
  @override
  Widget build(BuildContext context) {
    if (castList.isEmpty) return const SizedBox();
    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: castList.length,
        itemBuilder: (context, index) {
          final actor = castList[index];
          final String name = actor.name ?? "Unknown";
          final String imageUrl = actor.urlSmallImage ?? "";
          final String characterName = actor.characterName ?? "Unknown";
          return Container(
            margin: const EdgeInsets.only(right: 15),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.grey[800],
                  backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
                  child: imageUrl.isEmpty ? const Icon(Icons.person, color: Colors.white) : null,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 70,
                  child: Text(name, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.secondaryText, fontSize: 11)),
                ),
                const SizedBox(height: 4),
                Text(characterName, style: const TextStyle(color: AppColors.secondaryText, fontSize: 11)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class MovieStatsSection extends StatelessWidget {
  final String rating;
  final String duration;
  final int likeCount;
  const MovieStatsSection({super.key, required this.rating, required this.duration, required this.likeCount});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          _buildStatBadge(Icons.star, Colors.amber, rating),
          const SizedBox(width: 15),
          _buildStatBadge(Icons.access_time, Colors.white70, "$duration min"),
          const SizedBox(width: 15),
          _buildStatBadge(Icons.thumb_up, Colors.white70, "$likeCount likes"),
        ],
      ),
    );
  }
  Widget _buildStatBadge(IconData icon, Color iconColor, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: AppColors.headerBackground, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white12)),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 16),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }
}

class MovieScreenshotsSection extends StatelessWidget {
  final List<String> screenshotUrls;
  const MovieScreenshotsSection({super.key, required this.screenshotUrls});
  @override
  Widget build(BuildContext context) {
    if (screenshotUrls.isEmpty) return const SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeInUp(
          from: 20,
          duration: const Duration(milliseconds: 500),
          child: const Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 15),
            child: Text("Screenshots", style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold)),
          ),
        ),
        FadeInUp(
          delay: const Duration(milliseconds: 200),
          duration: const Duration(milliseconds: 500),
          child: SizedBox(
            height: 160,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: screenshotUrls.length,
              itemBuilder: (context, index) {
                final url = screenshotUrls[index];
                return Container(
                  width: 280,
                  margin: const EdgeInsets.only(right: 15),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppColors.headerBackground, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 5, offset: const Offset(0, 3))]),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(url, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.broken_image, color: Colors.grey)),),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}