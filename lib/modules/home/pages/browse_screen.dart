import 'package:flutter/material.dart';
import 'package:movies/core/theme/app_colors.dart';
import 'package:movies/core/temp/app_data.dart';
import 'package:movies/core/widgets/movie_grid_item.dart';

class BrowseScreen extends StatefulWidget {
  final String? initialCategory;
  const BrowseScreen({super.key,this.initialCategory});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {

  final List<String> _categories = [
    'Action',
    'Drama',
    'Sci-Fi',
    'Adventure',
    'Animation',
    'Comedy',
    'Horror',
  ];


  late String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: AppColors.mainBackground,
              automaticallyImplyLeading: false,
              pinned: true,
              toolbarHeight: 70,
              title: _buildCategoryList(),
            ),

            _buildMovieGrid(),

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
              onTap: () {
                setState(() {

                  if (isSelected) {
                    _selectedCategory = null;
                  } else {
                    _selectedCategory = category;
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(

                  color: isSelected ? AppColors.secondaryColor : AppColors.mainBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? AppColors.mainBackground : AppColors.secondaryColor,
                    width: 1,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  category,
                  style: TextStyle(
                    color: isSelected ? Colors.black : AppColors.secondaryColor,
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

  Widget _buildMovieGrid() {
    final List<Map<String, dynamic>> displayedMovies;

    // Filtering Logic
    if (_selectedCategory == null) {

      displayedMovies = AppData.movies;
    } else {

      displayedMovies = AppData.movies
          .where((movie) => movie['category'] == _selectedCategory)
          .toList();
    }

    if (displayedMovies.isEmpty) {
      return const SliverFillRemaining(
        child: Center(
          child: Text(
            "No Film to this Category",
            style: TextStyle(color: AppColors.secondaryText, fontSize: 16),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.all(15),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
        ),
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            final movie = displayedMovies[index % displayedMovies.length];

            return MovieGridItem(
              imagePath: movie['image'],
              rating: movie['rate'].toString(),
            );
          },
          childCount: displayedMovies.length*2,
        ),
      ),
    );
  }
}
