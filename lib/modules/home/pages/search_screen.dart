import 'package:flutter/material.dart';
import 'package:movies/core/theme/app_colors.dart';
import 'package:movies/core/temp/app_data.dart';
import 'package:movies/core/widgets/movie_grid_item.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    String query = _searchController.text.trim();
    setState(() {
      if (query.isNotEmpty) {
        _isSearching = true;
        _searchResults = AppData.movies
            .where((movie) => movie['title']
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase()))
            .toList();
      } else {
        _isSearching = false;
        _searchResults = [];
      }
    });
  }

  Widget _buildSearchField() {
    return Container(
      height: 48,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      decoration: BoxDecoration(
        color: AppColors.headerBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        cursorColor: AppColors.secondaryColor,
        decoration: InputDecoration(
          hintText: "Search",
          hintStyle: TextStyle(color: AppColors.disabledText.withOpacity(0.7)),
          prefixIcon: const Icon(Icons.search, color: AppColors.disabledText, size: 24),
          suffixIcon: _isSearching
              ? IconButton(
            icon: const Icon(Icons.clear, color: AppColors.disabledText, size: 20),
            onPressed: () {
              _searchController.clear();
            },
          )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/icons/popcorn_icon.png',
            width: 150,
            height: 150,
          ),
          const SizedBox(height: 20),
          // const Text(
          //   "Start Searching for your next show!",
          //   style: TextStyle(
          //     color: AppColors.disabledText,
          //     fontSize: 18,
          //   ),
          // ),
        ],
      ),
    );
  }

  //  GridView  MovieGridItem ---
  Widget _buildSearchResultsGrid() {
    if (_searchResults.isEmpty) {
      return const Center(
        child: Text(
          "No movies found.",
          style: TextStyle(color: AppColors.disabledText, fontSize: 16),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      // GridView.builder  (Grid)
      child: GridView.builder(
        //   CustomScrollView
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,

        itemCount: _searchResults.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemBuilder: (context, index) {
          final movie = _searchResults[index];

         // Using MovieGridItem
          return MovieGridItem(
            imagePath: movie['image'],
            rating: movie['rate'].toString(),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppColors.mainBackground,
            automaticallyImplyLeading: false,
            toolbarHeight: 60,
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: _buildSearchField(),
            ),
            pinned: true,
            elevation: 0,
          ),

          // SliverFillRemaining
          SliverFillRemaining(
            hasScrollBody: true,
            child: _isSearching
                ? _buildSearchResultsGrid()
                : _buildEmptyState(),
          ),
        ],
      ),
    );
  }
}
