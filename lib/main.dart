import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/core/provider/app_provider.dart';
import 'package:movies/core/theme/app_theme.dart';
import 'package:movies/firebase_options.dart';
import 'package:movies/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'config/shared_pref/cache_manager.dart';
import 'core/routes/route_gen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/services/service_locater.dart' as di;
import 'features/auth/presentation/cubit/auth_bloc.dart';
import 'features/usre_arguments/presentaion/bloc/user_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await di.init();

  await CacheManager.init();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => di.sl<AuthBloc>()),

        BlocProvider(create: (context) => di.sl<UserBloc>()),
      ],
      child: ChangeNotifierProvider(
        create: (context) => AppProvider(),
        child: const MyApp(),
      ),
    ),
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
