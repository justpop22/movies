import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/service_locater.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/params/movieparams.dart';
import '../../../core/widgets/movie_grid_item.dart';
import '../../../features/movies/presentation/cubit/movie_list_cubit/movies_bloc.dart';
import '../../../features/movies/presentation/cubit/movie_list_cubit/movies_event.dart';
import '../../../features/movies/presentation/cubit/movie_list_cubit/movies_state.dart';

class BrowseScreen extends StatelessWidget {
  final String? initialCategory;

  const BrowseScreen({super.key, this.initialCategory});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MoviesBloc>()
        ..add(GetMoviesEvent(params: MovieListParams(genre: initialCategory))),
      child: _BrowseScreenContent(initialCategory: initialCategory),
    );
  }
}

class _BrowseScreenContent extends StatefulWidget {
  final String? initialCategory;
  const _BrowseScreenContent({required this.initialCategory});

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

    context.read<MoviesBloc>().add(ResetSearchEvent());

    context.read<MoviesBloc>().add(
      GetMoviesEvent(params: MovieListParams(genre: _selectedCategory)),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              toolbarHeight: 70,
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
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  );
                }

                if (state is MoviesLoaded) {
                  if (state.movies.isEmpty) {
                    return const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text(
                          "No movies found for this category",
                          style: TextStyle(color: AppColors.disabledText),
                        ),
                      ),
                    );
                  }

                  return SliverPadding(
                    padding: const EdgeInsets.all(15),
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
            const SliverPadding(padding: EdgeInsets.only(bottom: 20)),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryList() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;

          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () => _onCategorySelected(category),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.secondaryColor
                      : AppColors.headerBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.mainBackground
                        : Colors.transparent,
                    width: 1,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  category,
                  style: TextStyle(
                    color: isSelected ? Colors.black : AppColors.secondaryText,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
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
