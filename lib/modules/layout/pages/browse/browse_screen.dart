import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/services/service_locater.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/params/movieparams.dart';
import '../../../../core/widgets/movie_grid_item.dart';
import '../../../../features/movies/presentation/cubit/movie_list_cubit/movies_bloc.dart';
import '../../../../features/movies/presentation/cubit/movie_list_cubit/movies_event.dart';
import '../../../../features/movies/presentation/cubit/movie_list_cubit/movies_state.dart';
import '../../../../l10n/app_localizations.dart';

class BrowseScreen extends StatelessWidget {
  final String? initialCategory;
  final Function(String?) onCategoryChanged;


  const BrowseScreen({super.key, this.initialCategory, required this.onCategoryChanged});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MoviesBloc>()
        ..add(GetMoviesEvent(params: MovieListParams(genre: initialCategory))),
      child: _BrowseScreenContent(initialCategory: initialCategory, onCategoryChanged: onCategoryChanged),
    );
  }
}

class _BrowseScreenContent extends StatefulWidget {
  final String? initialCategory;
  final Function(String?)? onCategoryChanged;
  const _BrowseScreenContent({required this.initialCategory, this.onCategoryChanged});

  @override
  State<_BrowseScreenContent> createState() => _BrowseScreenContentState();
}

class _BrowseScreenContentState extends State<_BrowseScreenContent> {
  final ScrollController _scrollController = ScrollController();

  final List<String> _categories = [
    'Action',
    'Drama',
    'Sci-Fi',
    'Adventure',
    'Animation',
    'Comedy',
    'Horror',
    'Romance',
    'Thriller',
  ];

  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (currentScroll >= maxScroll * 0.9) {
      context.read<MoviesBloc>().add(
        GetMoviesEvent(params: MovieListParams(genre: _selectedCategory)),
      );
    }
  }

  void _onCategorySelected(String category) {
    setState(() {
      if (_selectedCategory == category) {
        _selectedCategory = null;
      } else {
        _selectedCategory = category;
      }
    });
    widget.onCategoryChanged?.call(_selectedCategory);
    context.read<MoviesBloc>().add(ResetSearchEvent());

    context.read<MoviesBloc>().add(
      GetMoviesEvent(params: MovieListParams(genre: _selectedCategory)),
    );
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
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: AppColors.mainBackground,
              automaticallyImplyLeading: false,
              pinned: true,
              toolbarHeight: 70.h,
              title: _buildCategoryList(),
            ),

            BlocBuilder<MoviesBloc, MoviesState>(
              builder: (context, state) {
                if (state is MoviesInitial || state is MoviesLoading) {
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
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  );
                }

                if (state is MoviesLoaded) {
                  if (state.movies.isEmpty) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text(
                          locale.noMoviesCategory,
                          style: TextStyle(color: AppColors.disabledText),
                        ),
                      ),
                    );
                  }

                  return SliverPadding(
                    padding: EdgeInsets.all(15).w,
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.65,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15,
                          ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index >= state.movies.length) {
                            return const Center(
                              child: CircularProgressIndicator(),
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
                    ),
                  );
                }
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              },
            ),
            SliverPadding(padding: EdgeInsets.only(bottom: 20).r),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryList() {
    return SizedBox(
      height: 40.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;

          return Padding(
            padding: EdgeInsets.only(right: 10).r,
            child: GestureDetector(
              onTap: () => _onCategorySelected(category),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16).r,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.secondaryColor
                      : AppColors.headerBackground,
                  borderRadius: BorderRadius.circular(16).w,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.mainBackground
                        : Colors.transparent,
                    width: 1.w,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  category,
                  style: TextStyle(
                    color: isSelected ? Colors.black : AppColors.secondaryText,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
