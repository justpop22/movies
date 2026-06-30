import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/params/movieparams.dart';
import '../../../../core/routes/app_route_name.dart';
import '../../../../core/services/service_locater.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/movie_grid_item.dart';
import '../../../../features/movies/presentation/cubit/movie_list_cubit/movies_bloc.dart';
import '../../../../features/movies/presentation/cubit/movie_list_cubit/movies_event.dart';
import '../../../../features/movies/presentation/cubit/movie_list_cubit/movies_state.dart';
import '../../../../l10n/app_localizations.dart';
import '../main_layout.dart';
import '../movieDetails/movie_details.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late MoviesBloc _trendingBloc;
  late final PageController _pageController;
  final ValueNotifier<int> _currentIndexNotifier = ValueNotifier(0);


  final List<String> _categories = [
    'Action',
    'Drama',
    'Sci-Fi',
    'Adventure',
    'Animation',
    'Comedy',
    'Horror',
    'Romance',
  ];

  @override
  void initState() {
    super.initState();
    _trendingBloc = sl<MoviesBloc>()
      ..add(GetMoviesEvent(params: MovieListParams(sortBy: 'download_count')));
    _pageController = PageController(viewportFraction: 0.7, initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _currentIndexNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(children: [_buildHeaderSection(), _buildCategoryList()]),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return SizedBox(
      height: 0.65.sh,
      child: Stack(
        children: [_buildDynamicBackground(), _buildTrendingSlider()],
      ),
    );
  }

  Widget _buildDynamicBackground() {
    return Positioned.fill(
      child: BlocBuilder<MoviesBloc, MoviesState>(
        bloc: _trendingBloc,
        builder: (context, state) {
          if (state is! MoviesLoaded || state.movies.isEmpty) {
            return const ColoredBox(color: Colors.black);
          }

          return ValueListenableBuilder<int>(
            valueListenable: _currentIndexNotifier,
            builder: (context, index, _) {
              final movie =
                  state.movies[index.clamp(0, state.movies.length - 1)];
              final imagePath =
                  movie.largeCoverImage ?? movie.mediumCoverImage ?? "";

              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 700),
                child: Container(
                  key: ValueKey(imagePath),
                  decoration: BoxDecoration(
                    image: imagePath.isNotEmpty
                        ? DecorationImage(
                            image: CachedNetworkImageProvider(imagePath),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(color: Colors.black.withOpacity(0.4)),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildTrendingSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 30.h),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.0).r,
          child: Center(
            child: Text(
              "Available Now",
              style: GoogleFonts.protestRevolution (
                textStyle: TextStyle(
                  fontSize: 40.sp,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        ),

        SizedBox(
          height: 0.45.sh,
          child: BlocBuilder<MoviesBloc, MoviesState>(
            bloc: _trendingBloc,
            builder: (context, state) {
              if (state is MoviesLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.secondaryColor,
                  ),
                );
              }
              if (state is MoviesLoaded) {
                return PageView.builder(
                  controller: _pageController,
                  itemCount: state.movies.length,
                  onPageChanged: (index) {
                    _currentIndexNotifier.value = index;
                  },
                  itemBuilder: (context, index) {
                    final movie = state.movies[index];

                    return AnimatedBuilder(
                      animation: _pageController,
                      builder: (context, child) {
                        double page = index.toDouble();
                        if (_pageController.position.haveDimensions) {
                          page = _pageController.page ?? index.toDouble();
                        }
                        final double scale =
                        (1 - (page - index).abs() * 0.15).clamp(0.85, 1.0);

                        return Transform.scale(
                          scale: scale,
                          child: child,
                        );
                      },
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: const Duration(milliseconds: 600),
                              reverseTransitionDuration: const Duration(milliseconds: 500),
                              pageBuilder: (context, animation, secondaryAnimation) => MovieDetailsScreen(
                                imageUrl: movie.largeCoverImage ?? movie.mediumCoverImage ?? "",
                                movieId: movie.id,
                                heroTag: 'movie_hero_${movie.id}',
                              ),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                return FadeTransition(
                                  opacity: CurveTween(curve: Curves.easeOut).animate(animation),
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                        child: Hero(
                          tag: 'movie_hero_${movie.id}',
                          child: Material(
                            type: MaterialType.transparency,
                            child: _buildLargePoster(
                              movie.largeCoverImage ?? movie.mediumCoverImage ?? "",
                              movie.rating.toString(),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
              return const SizedBox();
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.0).r,
          child: Center(
            child: Text(
              "Watch Now",
              style: GoogleFonts.protestRevolution(
                textStyle: TextStyle(
                  fontSize: 40.sp,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLargePoster(String imageUrl, String rate) {
    return Container(
      margin: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25.r),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (_, __) => const ColoredBox(color: Colors.black26),
              errorWidget: (_, __, ___) =>
                  const Icon(Icons.broken_image, color: Colors.white),
            ),
            Positioned(top: 15, left: 15, child: _buildRatingBadge(rate)),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingBadge(String rate) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.75),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            rate,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 4.w),
          const Icon(Icons.star, color: Colors.amber, size: 16),
        ],
      ),
    );
  }

  Widget _buildCategoryList() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Column(
        children: _categories
            .map((c) => CategoryMovieRow(category: c))
            .toList(),
      ),
    );
  }
}

class CategoryMovieRow extends StatefulWidget {
  final String category;
  const CategoryMovieRow({super.key, required this.category});

  @override
  State<CategoryMovieRow> createState() => _CategoryMovieRowState();
}

class _CategoryMovieRowState extends State<CategoryMovieRow> {
  late MoviesBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = sl<MoviesBloc>()
      ..add(GetMoviesEvent(params: MovieListParams(genre: widget.category)));
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRowHeader(locale),
        SizedBox(
          height: 200.h,
          child: BlocBuilder<MoviesBloc, MoviesState>(
            bloc: _bloc,
            builder: (context, state) {
              if (state is! MoviesLoaded) {
                return const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                );
              }
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(left: 20.w),
                itemCount: state.movies.length,
                itemBuilder: (context, index) {
                  final movie = state.movies[index];
                  final tag = 'cat_${widget.category}_${movie.id}';

                  return Padding(
                    padding: EdgeInsets.only(right: 15.w),
                    child: SizedBox(
                      width: 135.w,
                      child: MovieGridItem(
                        movieId: movie.id,
                        rating: movie.rating.toString(),
                        imagePath: movie.mediumCoverImage ?? "",
                        heroTag: tag,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        SizedBox(height: 15.h),
      ],
    );
  }

  Widget _buildRowHeader(AppLocalizations locale) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.category,
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,

                PageRouteBuilder(
                  transitionDuration: Duration.zero,

                  reverseTransitionDuration: Duration.zero,

                  pageBuilder: (context, animation, secondaryAnimation) =>
                      MainLayout(
                        initialIndex: 2,

                        initialCategory: widget.category,
                      ),
                ),
              );
            },
            child: Row(
              children: [
                Text(
                  locale.seeMore,
                  style: TextStyle(
                    color: AppColors.secondaryColor,
                    fontSize: 14.sp,
                  ),
                ),
                Icon(
                  Icons.arrow_right_alt,
                  color: AppColors.secondaryColor,
                  size: 18,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
