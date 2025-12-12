import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:movies/core/provider/app_provider.dart';
import 'package:movies/core/theme/app_theme.dart';
import 'package:movies/firebase_options.dart';
import 'package:movies/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'config/shared_pref/cache_manager.dart';
import 'core/routes/route_gen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'modules/auth/manager/auth_provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await CacheManager.init();

  runApp(
      MultiProvider(
        providers: [
          // 1. AppProvider (Already existed)
          ChangeNotifierProvider(create: (context) => AppProvider()),

          // 2. AuthProvider (Necessary for ProfileScreen)
          ChangeNotifierProvider(create: (context) => AuthProvider()),
        ],
        child: const MyApp(),
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<AppProvider>();

    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('ar'), // Arabic
      ],
      locale: Locale(provider.local),
      debugShowCheckedModeBanner: false,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      onGenerateRoute: RouteGen.onGenerateRoute,
    );
  }
}