import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
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

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    screens = [
      HomeScreen(),
      const SearchScreen(),
      BrowseScreen(initialCategory: widget.initialCategory),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      body: screens[currentIndex],
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: 60,
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
