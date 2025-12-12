import 'package:flutter/material.dart';
import 'package:movies/core/theme/app_colors.dart';
import 'package:movies/core/temp/app_data.dart';
import 'package:movies/core/widgets/movie_grid_item.dart';
import 'package:movies/core/widgets/profile_header.dart';
import 'package:movies/core/widgets/profile_tabs.dart';
import 'package:movies/core/widgets/profile_tabs_delegate.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedTab = 0; // 0 = Watchlist, 1 = History

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      body: Column(
        children: [

          Container(
            height: MediaQuery.of(context).padding.top,
            color: AppColors.headerBackground,
          ),

          Expanded(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [

                const SliverToBoxAdapter(child: ProfileHeader()),


                SliverPersistentHeader(
                  pinned: true,
                  delegate: ProfileTabsDelegate(
                    child: ProfileTabs(
                      selectedIndex: _selectedTab,
                      onTabChanged: (index) => setState(() => _selectedTab = index),
                    ),
                  ),
                ),


                if (_selectedTab == 0)
                  _buildWatchListSliverGrid()
                else
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text(
                        "History Content Here",
                        style: TextStyle(color: AppColors.disabledText, fontSize: 16),
                      ),
                    ),
                  ),


                SliverPadding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWatchListSliverGrid() {
    return SliverPadding(
      padding: const EdgeInsets.all(15),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.65,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            final movie = AppData.movies[index];
            return MovieGridItem(
              imagePath: movie['image'],
              rating: movie['rate'].toString(),
            );
          },
          childCount: AppData.movies.length,
        ),
      ),
    );
  }
}
