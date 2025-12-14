import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/routes/app_route_name.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/movie_grid_item.dart';
import '../../../core/widgets/profile_header.dart';
import '../../../core/widgets/profile_tabs.dart';
import '../../../core/widgets/profile_tabs_delegate.dart';

// ✅ Import Auth Bloc
import '../../../features/auth/presentation/cubit/auth_bloc.dart';
import '../../../features/auth/presentation/cubit/auth_state.dart';

// ✅ Import User Bloc & Events
import '../../../features/usre_arguments/presentaion/bloc/user_bloc.dart';
import '../../../features/usre_arguments/presentaion/bloc/user_events.dart';
import '../../../features/usre_arguments/presentaion/bloc/user_states.dart';

// ✅ FIX: Import MovieSubEntity (Matches what UserDataLoaded holds)
import '../../../features/movies/domain/entities/sub_entity/movie.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedTab = 0; // 0 = Watchlist, 1 = History

  @override
  void initState() {
    super.initState();
    // ✅ Fetch Data on Init
    context.read<UserBloc>().add( GetFavoritesEvent());
    context.read<UserBloc>().add( GetHistoryEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            RouteName.login,
                (route) => false,
          );
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, userState) {

          // ✅ FIX: Use MovieSubEntity types here
          List<MovieSubEntity> favorites = [];
          List<MovieSubEntity> history = [];

          // Extract data if loaded
          if (userState is UserDataLoaded) {
            favorites = userState.favorites;
            history = userState.watchHistory;
          }

          return Scaffold(
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
                      // Profile Header with Dynamic Counts
                      SliverToBoxAdapter(
                        child: ProfileHeader(
                          watchListCount: favorites.length,
                          historyCount: history.length,
                        ),
                      ),

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

                      // Tab Content
                      if (_selectedTab == 0)
                        _buildMovieGrid(favorites, "No movies in Watchlist")
                      else
                        _buildMovieGrid(history, "No movies in History"),

                      SliverPadding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).padding.bottom + 20),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ✅ FIX: Update parameter type to List<MovieSubEntity>
  Widget _buildMovieGrid(List<MovieSubEntity> movies, String emptyMessage) {
    if (movies.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Text(
            emptyMessage,
            style: const TextStyle(color: AppColors.disabledText, fontSize: 16),
          ),
        ),
      );
    }

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
            final movie = movies[index];
            return MovieGridItem(
              movieId: movie.id,
              imagePath: movie.mediumCoverImage ?? movie.smallCoverImage??movie.largeCoverImage??"",
              rating: movie.rating.toString(),
            );
          },
          childCount: movies.length,
        ),
      ),
    );
  }
}