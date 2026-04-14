import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/routes/app_route_name.dart';
import '../../../core/theme/app_colors.dart';
import '../../../features/auth/presentation/cubit/auth_bloc.dart';
import '../../../features/auth/presentation/cubit/auth_state.dart';
import '../../../features/movies/presentation/cubit/movie_list_cubit/movies_bloc.dart';
import '../../../features/movies/presentation/cubit/movie_list_cubit/movies_event.dart';
import '../../../features/usre_arguments/presentaion/bloc/user_bloc.dart';
import '../../../features/usre_arguments/presentaion/bloc/user_events.dart';
import '../../../l10n/app_localizations.dart';
import 'home/home_screen.dart';
import 'search/search_screen.dart';
import 'browse/browse_screen.dart';
import 'profile/profile_screen.dart';

class MainLayout extends StatefulWidget {
  final int initialIndex;
  final String? initialCategory;
  const MainLayout({super.key, this.initialIndex = 0, this.initialCategory});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  late int currentIndex;
  late final List<Widget> screens;
  String? currentBrowseCategory;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    currentBrowseCategory = widget.initialCategory;
  }

  void _handleCategoryChange(String? newCategory) {
    setState(() {
      currentBrowseCategory = newCategory;
    });
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      body: IndexedStack(
        index: currentIndex,
        children: [
          HomeScreen(),
          const SearchScreen(),
          BrowseScreen(
            initialCategory: currentBrowseCategory,
            onCategoryChanged: _handleCategoryChange,
          ),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12).r,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16).w,
            child: SizedBox(
              height: 60.h,
              child: BottomNavigationBar(
                currentIndex: currentIndex,
                onTap: (index) => setState(() => currentIndex = index),
                selectedItemColor: AppColors.secondaryColor,
                unselectedItemColor: AppColors.primaryText,
                backgroundColor: AppColors.navigationBarBackground,
                type: BottomNavigationBarType.fixed,
                selectedFontSize: 12,
                unselectedFontSize: 12,
                iconSize: 22,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: locale.home,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.search),
                    label: locale.search,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.explore),
                    label: locale.browse,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: locale.profile,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
