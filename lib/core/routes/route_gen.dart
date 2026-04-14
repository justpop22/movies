import 'package:flutter/material.dart';
import '../../modules/auth/pages/forget_password_screen.dart';
import '../../modules/auth/pages/login_screen.dart';
import '../../modules/auth/pages/register_screen.dart';
import '../../modules/layout/pages/main_layout.dart';
import '../../modules/layout/pages/movieDetails/movie_details.dart';
import '../../modules/onboarding/onboarding.dart';
import '../../modules/splash/pages/splash_screen.dart';
import 'app_route_name.dart';

class RouteGen {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.splash:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return SplashScreen();
          },
        );

      case RouteName.onBoarding:
        return PageRouteBuilder(
          transitionDuration: Duration(seconds: 1),
          pageBuilder: (context, animation, secondaryAnimation) {
            return OnBoarding();
          },
        );

      case RouteName.login:
        return PageRouteBuilder(
          transitionDuration: Duration(seconds: 1),
          pageBuilder: (context, animation, secondaryAnimation) {
            return LoginScreen();
          },
        );

      case RouteName.register:
        return PageRouteBuilder(
          transitionDuration: Duration(seconds: 1),
          pageBuilder: (context, animation, secondaryAnimation) {
            return RegisterScreen();
          },
        );

      case RouteName.forgetPassword:
        return PageRouteBuilder(
          transitionDuration: Duration(seconds: 1),
          pageBuilder: (context, animation, secondaryAnimation) {
            return ForgetPasswordScreen();
          },
        );

      case RouteName.layout:
        return PageRouteBuilder(
          transitionDuration: Duration(seconds: 1),
          pageBuilder: (context, animation, secondaryAnimation) {
            return MainLayout();
          },
        );
      case RouteName.movieDetail:
        return PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (context, animation, secondaryAnimation) {
            final args = settings.arguments as Map<String, dynamic>;
            final movieId = args['movieId'] as int;
            final heroTag = args['heroTag'] as String;
            final imageUrl = args['imageUrl'] as String;

            return MovieDetailsScreen(
              movieId: movieId,
              heroTag: heroTag,
              imageUrl: imageUrl,
            );
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurveTween(curve: Curves.easeOut).animate(animation),
              child: child,
            );
          },
        );

      default:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return NotFoundScreen();
          },
        );
    }
  }
}

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
