import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies/core/theme/app_colors.dart';
import 'package:movies/core/widgets/movie_grid_item.dart';
import '../../../../core/services/service_locater.dart';
import '../../../../features/movies/presentation/cubit/movie_detail_cubit/movie_details_bloc.dart';
import '../../../../features/movies/presentation/cubit/movie_detail_cubit/movie_details_event.dart';
import '../../../../features/movies/presentation/cubit/movie_detail_cubit/movie_details_state.dart';
import '../../../../features/usre_arguments/presentaion/bloc/user_bloc.dart';
import '../../../../features/usre_arguments/presentaion/bloc/user_events.dart';
import '../../../../features/usre_arguments/presentaion/bloc/user_states.dart';
import '../../../../features/movies/presentation/widgets/movie_app_bar.dart';
import '../../../../features/movies/presentation/widgets/movie_stats.dart';
import '../../../../features/movies/presentation/widgets/movie_screenshots.dart';
import '../../../../features/movies/presentation/widgets/movie_cast.dart';
import '../../../../l10n/app_localizations.dart';

class MovieDetailsScreen extends StatelessWidget {
  final int movieId;
  final String heroTag;
  final String imageUrl;

  const MovieDetailsScreen({
    super.key,
    required this.movieId,
    required this.heroTag,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      sl<MovieDetailsBloc>()..add(GetMovieDetailsEvent(id: movieId)),
      // ⭐️ FIX: Passed the tag down into the state widget
      child: _MovieDetailsContent(heroTag: heroTag,imageUrl: imageUrl),
    );
  }
}

class _MovieDetailsContent extends StatefulWidget {
  final String heroTag;
  final String imageUrl;

  const _MovieDetailsContent({required this.heroTag,required this.imageUrl});

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
    var locale = AppLocalizations.of(context)!;
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.mainBackground,
        body: BlocBuilder<MovieDetailsBloc, MovieDetailsState>(
          builder: (context, movieState) {

            // Inside movie_details.dart -> _MovieDetailsContentState -> build
            if (movieState is MovieDetailsLoading) {
              return CustomScrollView(
                physics: const NeverScrollableScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    backgroundColor: AppColors.headerBackground,
                    expandedHeight: 450.0.h,
                    leading: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 28),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      background: Hero(
                        tag: widget.heroTag,
                        child: Material(
                          type: MaterialType.transparency, // Match source transparency
                          child: ClipRRect(
                            borderRadius: BorderRadius.zero, // Morph from rounded to square
                            child: CachedNetworkImage(
                              imageUrl: widget.imageUrl, // Use the image URL passed from Home
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(color: AppColors.headerBackground),
                              errorWidget: (context, url, error) => Container(color: AppColors.headerBackground),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors.secondaryColor),
                    ),
                  ),
                ],
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
                        heroTag: widget.heroTag,
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
                                    padding: EdgeInsets.symmetric(
                                      vertical: 16,
                                    ).r,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16).w,
                                    ),
                                  ),
                                  child: Text(
                                    locale.watch,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.sp,
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
                            SizedBox(height: 20.h),

                            MovieScreenshots(screenshotUrls: movie.screenshots),

                            if (suggestions.isNotEmpty) ...[
                              _buildSectionTitle(locale.similar),
                              _buildSimilarMoviesList(suggestions),
                            ],

                            _buildSectionTitle(locale.summary),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20).r,
                              child: Text(
                                movie.descriptionFull.isNotEmpty
                                    ? movie.descriptionFull
                                    : locale.noDesAvail,
                                style: TextStyle(
                                  color: AppColors.secondaryText,
                                  fontSize: 15.sp,
                                  height: 1.6.h,
                                ),
                              ),
                            ),

                            if (movie.cast.isNotEmpty) ...[
                              _buildSectionTitle(locale.cast),
                              MovieCast(castList: movie.cast),
                            ],

                            _buildSectionTitle(locale.genres),
                            _buildGenresRow(movie.genres),

                            SizedBox(height: 40.h),
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
          style: TextStyle(
            color: Colors.white,
            fontSize: 19.sp,
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
        height: 230.h,
        margin: EdgeInsets.only(bottom: 20).r,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 20).r,
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
            final movie = suggestions[index];
            return Padding(
              padding: EdgeInsets.only(right: 12).r,
              child: SizedBox(
                width: 130.w,
                child: MovieGridItem(
                  movieId: movie.id,
                  rating: movie.rating.toString(),
                  imagePath: movie.mediumCoverImage ?? "",
                  heroTag: 'similar_poster_${movie.id}',
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
      padding: EdgeInsets.symmetric(horizontal: 20).r,
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: genres
            .map(
              (genre) => Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ).r,
            decoration: BoxDecoration(
              color: AppColors.headerBackground,
              borderRadius: BorderRadius.circular(20).w,
            ),
            child: Text(
              genre,
              style: TextStyle(
                color: AppColors.primaryText,
                fontSize: 13.sp,
              ),
            ),
          ),
        )
            .toList(),
      ),
    );
  }
}