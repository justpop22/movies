import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/core/theme/app_colors.dart';
import 'package:movies/core/widgets/movie_grid_item.dart';
import '../../../core/services/service_locater.dart';
import '../../../features/movies/presentation/cubit/movie_detail_cubit/movie_details_bloc.dart';
import '../../../features/movies/presentation/cubit/movie_detail_cubit/movie_details_event.dart';
import '../../../features/movies/presentation/cubit/movie_detail_cubit/movie_details_state.dart';
import '../../../features/usre_arguments/presentaion/bloc/user_bloc.dart';
import '../../../features/usre_arguments/presentaion/bloc/user_events.dart';
import '../../../features/usre_arguments/presentaion/bloc/user_states.dart';
import '../../../features/movies/presentation/widgets/movie_app_bar.dart';
import '../../../features/movies/presentation/widgets/movie_stats.dart';
import '../../../features/movies/presentation/widgets/movie_screenshots.dart';
import '../../../features/movies/presentation/widgets/movie_cast.dart';

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
    context.read<UserBloc>().add(GetFavoritesEvent());
    context.read<UserBloc>().add(GetHistoryEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBackground,
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

            return BlocBuilder<UserBloc, UserState>(
              builder: (context, userState) {
                bool isFavorite = false;
                bool isBookMarked = false;

                if (userState is UserDataLoaded) {
                  isFavorite = userState.favorites.any((m) => m.id == movie.id);
                  isBookMarked = userState.watchHistory.any(
                    (m) => m.id == movie.id,
                  );
                }

                return CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    MovieAppBar(
                      movie: movie,
                      isFavorite: isFavorite,
                      isBookMarked: isBookMarked,
                    ),

                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.dangerColor,
                                  foregroundColor: AppColors.primaryText,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
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

                          MovieStats(
                            rating: movie.rating,
                            runtime: movie.runtime ?? 0,
                            likeCount: movie.likeCount,
                          ),
                          const SizedBox(height: 20),

                          MovieScreenshots(screenshotUrls: movie.screenshots),

                          if (suggestions.isNotEmpty) ...[
                            _buildSectionTitle('Similar'),
                            _buildSimilarMoviesList(suggestions),
                          ],

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
                            MovieCast(castList: movie.cast),
                          ],

                          _buildSectionTitle('Genres'),
                          _buildGenresRow(movie.genres),

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
