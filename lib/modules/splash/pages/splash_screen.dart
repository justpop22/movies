import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../config/shared_pref/cache_manager.dart';
import '../../../core/routes/app_route_name.dart';
import '../../../core/services/service_locater.dart'; // To access 'sl'
import '../../../core/theme/app_colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          Center(
            child: FadeInDownBig(
              duration: const Duration(seconds: 2),
              child: Hero(
                tag: "logo",
                child: Image.asset("assets/logo/app_logo.png"),
              ),
            ),
          ),
          FadeInUpBig(
            duration: const Duration(seconds: 2),
            child: Hero(
              tag: "app_name",
              child: Material(
                elevation: 0,
                color: Colors.transparent,
                child: Text(
                  "Movie Player",
                  style: TextStyle(
                    color: AppColors.secondaryColor,
                    fontSize: 36,
                  ),
                ),
              ),
            ),
          ),
          const Spacer(),
          FadeInUpBig(
            onFinish: (direction) {
              // 1. Get current user directly from Service Locator
              final user = sl<FirebaseAuth>().currentUser;

              // 2. Decide logic
              final nextRoute = CacheManager.isFirstTime
                  ? RouteName.onBoarding
                  : (user == null ? RouteName.login : RouteName.layout);

              // 3. Navigate
              Navigator.pushReplacementNamed(context, nextRoute);
            },
            delay: const Duration(seconds: 2),
            child: Image.asset("assets/logo/route_logo.png"),
          ),
          FadeInUp(
            delay: const Duration(seconds: 2),
            child: Image.asset("assets/logo/supervised_logo.png"),
          ),
        ],
      ),
    );
  }
}