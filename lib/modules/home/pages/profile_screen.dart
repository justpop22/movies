import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/routes/app_route_name.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/temp/app_data.dart'; // Keep this for now (Dummy Data)
import '../../../core/widgets/movie_grid_item.dart';
import '../../../core/widgets/profile_header.dart'; // Ensure this points to your new refactored header
import '../../../core/widgets/profile_tabs.dart';
import '../../../core/widgets/profile_tabs_delegate.dart';
import '../../../features/auth/presentation/cubit/auth_bloc.dart';
import '../../../features/auth/presentation/cubit/auth_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedTab = 0; // 0 = Watchlist, 1 = History

  @override
  Widget build(BuildContext context) {
    // ✅ WRAP WITH BLOC LISTENER
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          // 🚪 Exit to Login Screen
          Navigator.pushNamedAndRemoveUntil(
            context,
            RouteName.login,
                (route) => false,
          );
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.mainBackground,
        body: Column(
          children: [
            // Status Bar Color
            Container(
              height: MediaQuery.of(context).padding.top,
              color: AppColors.headerBackground,
            ),

            Expanded(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // Profile Header
                  const SliverToBoxAdapter(child: ProfileHeader()),

                  // Sticky Tabs
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: ProfileTabsDelegate(
                      child: ProfileTabs(
                        selectedIndex: _selectedTab,
                        onTabChanged: (index) =>
                            setState(() => _selectedTab = index),
                      ),
                    ),
                  ),

                  // Tab Content (Toggle between Watchlist / History)
                  if (_selectedTab == 0)
                    _buildWatchListSliverGrid()
                  else
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text(
                          "History Content Here",
                          style: TextStyle(
                              color: AppColors.disabledText, fontSize: 16),
                        ),
                      ),
                    ),

                  SliverPadding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).padding.bottom + 20),
                  ),
                ],
              ),
            ),
          ],
        ),
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