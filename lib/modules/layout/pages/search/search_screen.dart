import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/services/service_locater.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/params/movieparams.dart';
import '../../../../features/movies/presentation/cubit/movie_list_cubit/movies_bloc.dart';
import '../../../../features/movies/presentation/cubit/movie_list_cubit/movies_event.dart';
import '../../../../features/movies/presentation/cubit/movie_list_cubit/movies_state.dart';
import '../../../../core/widgets/movie_grid_item.dart';
import '../../../../l10n/app_localizations.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MoviesBloc>(),
      child: const _SearchScreenContent(),
    );
  }
}

class _SearchScreenContent extends StatefulWidget {
  const _SearchScreenContent();

  @override
  State<_SearchScreenContent> createState() => _SearchScreenContentState();
}

class _SearchScreenContentState extends State<_SearchScreenContent> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (query.trim().isNotEmpty) {
      context.read<MoviesBloc>().add(SearchMoviesEvent(queryTerm: query));
    } else {
      context.read<MoviesBloc>().add(ResetSearchEvent());
    }
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      final currentQuery = _searchController.text.trim();

      if (currentQuery.isNotEmpty) {
        context.read<MoviesBloc>().add(
          GetMoviesEvent(params: MovieListParams(queryTerm: currentQuery)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              backgroundColor: AppColors.mainBackground,
              automaticallyImplyLeading: false,
              toolbarHeight: 80.h,
              title: _buildSearchField(),
              floating: true,
              pinned: true,
              elevation: 0,
            ),

            BlocBuilder<MoviesBloc, MoviesState>(
              builder: (context, state) {
                if (state is MoviesInitial) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: _buildEmptyState(locale.startSearching),
                  );
                }

                if (state is MoviesLoading) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.secondaryColor,
                      ),
                    ),
                  );
                }

                if (state is MoviesFailure) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  );
                }

                if (state is MoviesLoaded) {
                  if (state.movies.isEmpty) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: _buildEmptyState(locale.noMoviesFound),
                    );
                  }

                  return SliverPadding(
                    padding: EdgeInsets.all(16.0).w,
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          if (index >= state.movies.length) {
                            return const Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.secondaryColor,
                              ),
                            );
                          }

                          final movie = state.movies[index];
                          return MovieGridItem(
                            movieId: movie.id,
                            imagePath: movie.mediumCoverImage ?? "",
                            rating: movie.rating.toString(),
                            heroTag: 'similar_poster_${movie.id}',
                          );
                        },
                        childCount: state.hasReachedMax
                            ? state.movies.length
                            : state.movies.length + 1,
                      ),
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                    ),
                  );
                }

                return const SliverToBoxAdapter(child: SizedBox.shrink());
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    var locale = AppLocalizations.of(context)!;
    return Container(
      height: 50.h,
      margin: EdgeInsets.symmetric(vertical: 10).r,
      decoration: BoxDecoration(
        color: AppColors.headerBackground,
        borderRadius: BorderRadius.circular(12).w,
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        style: TextStyle(color: Colors.white, fontSize: 16.sp),
        cursorColor: AppColors.secondaryColor,
        decoration: InputDecoration(
          hintText: locale.searchByTitle,
          hintStyle: TextStyle(color: AppColors.disabledText.withOpacity(0.7)),
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.disabledText,
            size: 24,
          ),
          suffixIcon: IconButton(
            icon: const Icon(
              Icons.clear,
              color: AppColors.disabledText,
              size: 20,
            ),
            onPressed: () {
              _searchController.clear();
              context.read<MoviesBloc>().add(ResetSearchEvent());
              FocusScope.of(context).unfocus();
            },
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 10,
          ).r,
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/icons/popcorn_icon.png", height: 124.h, width: 124.w),
          SizedBox(height: 16.h),
          Text(
            message,
            style: TextStyle(color: AppColors.disabledText, fontSize: 16.sp),
          ),
        ],
      ),
    );
  }
}