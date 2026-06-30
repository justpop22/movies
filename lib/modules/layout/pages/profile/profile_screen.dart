import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/routes/app_route_name.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/movie_grid_item.dart';
import '../../../../core/widgets/profile/profile_header.dart';
import '../../../../core/widgets/profile/profile_tabs.dart';
import '../../../../core/widgets/profile/profile_tabs_delegate.dart';
import '../../../../features/auth/presentation/cubit/auth_bloc.dart';
import '../../../../features/auth/presentation/cubit/auth_state.dart';
import '../../../../features/usre_arguments/presentaion/bloc/user_bloc.dart';
import '../../../../features/usre_arguments/presentaion/bloc/user_events.dart';
import '../../../../features/usre_arguments/presentaion/bloc/user_states.dart';
import '../../../../features/movies/domain/entities/sub_entity/movie.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(GetFavoritesEvent());
    context.read<UserBloc>().add(GetHistoryEvent());
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
          List<MovieSubEntity> favorites = [];
          List<MovieSubEntity> history = [];

          if (userState is UserDataLoaded) {
            favorites = userState.favorites;
            history = userState.watchHistory;
          }

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
                      SliverToBoxAdapter(
                        child: ProfileHeader(
                          watchListCount: favorites.length,
                          historyCount: history.length,
                        ),
                      ),

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

                      if (_selectedTab == 0)
                        _buildMovieGrid(
                          favorites,
                          "assets/icons/popcorn_icon.png",
                        )
                      else
                        _buildMovieGrid(
                          history,
                          "assets/icons/popcorn_icon.png",
                        ),

                      SliverPadding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).padding.bottom + 20,
                        ),
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

  Widget _buildMovieGrid(List<MovieSubEntity> movies, String imagePath) {
    if (movies.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Image.asset(
            imagePath,
            width: 124.w,
            height: 124.h,
            fit: BoxFit.contain,
          ),
        ),
      );
    }

    return SliverPadding(
      padding: EdgeInsets.all(15).w,
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.65,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          final movie = movies[index];
          return MovieGridItem(
            movieId: movie.id,
            imagePath:
                movie.mediumCoverImage ??
                movie.smallCoverImage ??
                movie.largeCoverImage ??
                "",
            rating: movie.rating.toString(),
            heroTag: 'similar_poster_${movie.id}',
          );
        }, childCount: movies.length),
      ),
    );
  }
}
