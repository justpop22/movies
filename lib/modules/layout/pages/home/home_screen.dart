import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/params/movieparams.dart';
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
    final double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                height: (screenHeight * 0.65).h,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: BlocBuilder<MoviesBloc, MoviesState>(
                        bloc: _trendingBloc,
                        builder: (context, state) {
                          if (state is! MoviesLoaded || state.movies.isEmpty) {
                            return Container(color: Colors.black);
                          }

                          return ValueListenableBuilder<int>(
                            valueListenable: _currentIndexNotifier,
                            builder: (context, index, _) {
                              final safeIndex = index.clamp(
                                0,
                                state.movies.length - 1,
                              );
                              final movie = state.movies[safeIndex];
                              final imagePath =
                                  movie.largeCoverImage ??
                                  movie.mediumCoverImage ??
                                  "";

                              return AnimatedSwitcher(
                                duration: const Duration(milliseconds: 500),
                                child: Stack(
                                  key: ValueKey(imagePath),
                                  fit: StackFit.expand,
                                  children: [
                                    if (imagePath.isNotEmpty)
                                      Image.network(
                                        imagePath,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            const SizedBox(),
                                      ),
                                    Container(
                                      color: Colors.black.withOpacity(0.4),
                                    ),
                                    BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 8.0,
                                        sigmaY: 8.0,
                                      ),
                                      child: Container(
                                        color: Colors.black.withOpacity(0.2),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 30.h),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25.0).r,
                          child: Center(
                            child: Image.asset(
                              "assets/images/Available.png",
                              width: 250.w,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),

                        Expanded(
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
                                        if (_pageController
                                            .position
                                            .haveDimensions) {
                                          page =
                                              _pageController.page ??
                                              index.toDouble();
                                        }
                                        final double scale =
                                            (1 - (page - index).abs() * 0.15)
                                                .clamp(0.85, 1.0);

                                        return Transform.scale(
                                          scale: scale,
                                          child: child,
                                        );
                                      },

                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  MovieDetailsScreen(
                                                    movieId: movie.id,
                                                  ),
                                            ),
                                          );
                                        },
                                        child: _buildLargePoster(
                                          movie.largeCoverImage ??
                                              movie.mediumCoverImage ??
                                              "",
                                          movie.rating.toString(),
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
                            child: Image.asset(
                              "assets/images/Watch Now.png",
                              width: 250.w,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.only(left: 20.0, top: 10).r,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ..._categories.map(
                      (category) => CategoryMovieRow(category: category),
                    ),
                    SizedBox(height: 50.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLargePoster(String imageUrl, String rate) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0).r,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0).w,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0).w,
            child: imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    fit: BoxFit.fill,
                    height: double.infinity,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[900],
                      child: const Icon(
                        Icons.broken_image,
                        color: Colors.white,
                      ),
                    ),
                  )
                : Container(color: Colors.grey[900]),
          ),

          Positioned(
            top: 20,
            left: 20,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8.0,
              ).r,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12.0).w,
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Text(
                    rate,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  const Icon(Icons.star, color: Colors.amber, size: 18),
                ],
              ),
            ),
          ),
        ],
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
        SizedBox(height: 30.h),

        Padding(
          padding: EdgeInsets.only(right: 20.0, bottom: 15).r,
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
                    MaterialPageRoute(
                      builder: (_) => MainLayout(
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
                        fontSize: 14.sp,
                        color: AppColors.secondaryColor,
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
        ),

        SizedBox(
          height: 200.h,
          child: BlocBuilder<MoviesBloc, MoviesState>(
            bloc: _bloc,
            builder: (context, state) {
              if (state is MoviesLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.secondaryColor,
                  ),
                );
              }
              if (state is MoviesFailure) {
                return const Center(
                  child: Icon(Icons.error_outline, color: Colors.white24),
                );
              }
              if (state is MoviesLoaded) {
                if (state.movies.isEmpty) return const SizedBox();

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: state.movies.length,
                  itemBuilder: (context, index) {
                    final movie = state.movies[index];

                    return Container(
                      width: 130.w,
                      margin: EdgeInsets.only(right: 14.0).r,
                      child: MovieGridItem(
                        movieId: movie.id,
                        rating: movie.rating.toString(),
                        imagePath: movie.mediumCoverImage ?? "",
                      ),
                    );
                  },
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ],
    );
  }
}
