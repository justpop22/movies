import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies/modules/onboarding/pages/onboarding_screen1.dart';
import 'package:movies/modules/onboarding/pages/onboarding_screen2.dart';
import 'package:movies/modules/onboarding/pages/onboarding_screen3.dart';
import 'package:movies/modules/onboarding/pages/onboarding_screen4.dart';
import 'package:movies/modules/onboarding/pages/onboarding_screen5.dart';
import 'package:movies/modules/onboarding/pages/onboarding_screen6.dart';

ValueNotifier<int> globalCurrentPage = ValueNotifier(0);

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final PageController _controller = PageController();
  static int _currentPage = 0;
  static void onGlobalPageChanged(int index) {
    _currentPage = index;
    print("Current page: $_currentPage");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        onPageChanged: (index) {
          globalCurrentPage.value = index;
        },
        children: [
          OnboardingScreen1(controller: _controller),
          OnboardingScreen2(controller: _controller),
          OnboardingScreen3(controller: _controller),
          OnboardingScreen4(controller: _controller),
          OnboardingScreen5(controller: _controller),
          OnboardingScreen6(controller: _controller),
        ],
      ),
    );
  }
}
