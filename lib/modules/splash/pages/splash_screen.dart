import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/shared_pref/cache_manager.dart';
import '../../../core/routes/app_route_name.dart';
import '../../../core/theme/app_colors.dart';
import '../../auth/manager/auth_provider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          Center(
            child: FadeInDownBig(
              duration: Duration(seconds: 2),
              child: Hero(
                tag: "logo",
                child: Image.asset("assets/logo/app_logo.png"),
              ),
            ),
          ),
          FadeInUpBig(
            duration: Duration(seconds: 2),
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
              final nextRoute = CacheManager.isFirstTime
                  ? RouteName.onBoarding
                  : provider.user == null ? RouteName.login : RouteName.layout;
              Navigator.pushReplacementNamed(context, nextRoute);
            },
            delay: Duration(seconds: 2),
            child: Image.asset("assets/logo/route_logo.png"),
          ),
          FadeInUp(
            delay: Duration(seconds: 2),
            child: Image.asset("assets/logo/supervised_logo.png"),
          ),
        ],
      ),
    );
  }
}