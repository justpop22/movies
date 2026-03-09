import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/datasources/data_source.dart';
import '../../features/auth/data/repositories/auth_repo_impl.dart';
import '../../features/auth/domain/repositories/auth_repo.dart';
import '../../features/auth/domain/use_case/deleteaccount_usecase.dart';
import '../../features/auth/domain/use_case/forgotpassword_usecase.dart';
import '../../features/auth/domain/use_case/getcurrentuser_usecase.dart';
import '../../features/auth/domain/use_case/login_usecase.dart';
import '../../features/auth/domain/use_case/loginwithgoogle_usecase.dart';
import '../../features/auth/domain/use_case/logout_usecase.dart';
import '../../features/auth/domain/use_case/signup_usecase.dart';

import '../../features/auth/presentation/cubit/auth_bloc.dart';
import '../../features/movies/data/datasources/movies_local_data_source.dart';
import '../../features/movies/data/datasources/movies_remote_data_source.dart';
import '../../features/movies/data/repositories/movie_repository_impl.dart';
import '../../features/movies/domain/repositories/movie_repository.dart';
import '../../features/movies/domain/usecases/get_movie_details.dart';
import '../../features/movies/domain/usecases/get_movie_list.dart';
import '../../features/movies/domain/usecases/get_movie_suggestions.dart';

import '../../features/movies/presentation/cubit/movie_detail_cubit/movie_details_bloc.dart';
import '../../features/movies/presentation/cubit/movie_list_cubit/movies_bloc.dart';
import '../../features/usre_arguments/data/datasources/user_remote_data_source.dart';
import '../../features/usre_arguments/data/repositories/user_repository_impl.dart';
import '../../features/usre_arguments/domain/repo/user_repo.dart';
import '../../features/usre_arguments/domain/use_cases/add_favorite_usecase.dart';
import '../../features/usre_arguments/domain/use_cases/add_history_usecase.dart';
import '../../features/usre_arguments/domain/use_cases/get_favorites_usecase.dart';
import '../../features/usre_arguments/domain/use_cases/get_history_usecase.dart';
import '../../features/usre_arguments/domain/use_cases/get_user_info_usecase.dart';
import '../../features/usre_arguments/domain/use_cases/remove_favorite_usecase.dart';
import '../../features/usre_arguments/domain/use_cases/remove_history_usecase.dart';
import '../../features/usre_arguments/domain/use_cases/update_user_usecase.dart';
import '../../features/usre_arguments/presentaion/bloc/user_bloc.dart';
import '../connection/network_info.dart';
import '../databases/api/auth_consumer.dart';
import '../databases/api/firebase_auth_consumer.dart';
import '../databases/api/api_consumer.dart';
import '../databases/api/dio_consumer.dart';
import '../databases/cache/cache_helper.dart';

final sl = GetIt.instance;

Future<void> init(SharedPreferences sharedPreferences) async {

  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => GoogleSignIn());

  sl.registerLazySingleton(() => sharedPreferences);


  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton<ApiConsumer>(() => DioConsumer(dio: sl()));
  sl.registerLazySingleton<AuthConsumer>(
        () => FirebaseAuthConsumer(firebaseAuth: sl()),
  );
  sl.registerLazySingleton<CacheHelper>(() => CacheHelper());

  sl.registerFactory(
        () => AuthBloc(
      loginUseCase: sl(),
      signUpUseCase: sl(),
      logoutUseCase: sl(),
      getCurrentUserUseCase: sl(),
      forgotPasswordUseCase: sl(),
      loginWithGoogleUseCase: sl(),
      deleteAccountUseCase: sl(),
    ),
  );
  sl.registerFactory(
        () => UserBloc(
      addFavorite: sl(),
      removeFavorite: sl(),
      addHistory: sl(),
      removeHistory: sl(),
      updateUser: sl(),
      getFavorites: sl(),
      getHistory: sl(),
      getUserInfo: sl(),
    ),
  );
  sl.registerFactory(() => MoviesBloc(getMoviesList: sl()));
  sl.registerFactory(
        () => MovieDetailsBloc(getMovieDetails: sl(), getMovieSuggestions: sl()),
  );

  sl.registerLazySingleton(() => LoginUseCase(repository: sl()));
  sl.registerLazySingleton(() => SignUpUseCase(repository: sl()));
  sl.registerLazySingleton(() => LogoutUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(repository: sl()));
  sl.registerLazySingleton(() => ForgotPasswordUseCase(repository: sl()));
  sl.registerLazySingleton(() => LoginWithGoogleUseCase(repository: sl()));
  sl.registerLazySingleton(() => DeleteAccountUseCase(repository: sl()));

  sl.registerLazySingleton(() => AddFavoriteMovieUseCase(repository: sl()));
  sl.registerLazySingleton(() => RemoveFavoriteMovieUseCase(repository: sl()));
  sl.registerLazySingleton(() => AddWatchHistoryUseCase(repository: sl()));
  sl.registerLazySingleton(() => RemoveWatchHistoryUseCase(repository: sl()));
  sl.registerLazySingleton(() => UpdateUserInfoUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetFavoritesUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetWatchHistoryUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetUserInfoUseCase(repository: sl()));

  sl.registerLazySingleton(() => GetMoviesList(repository: sl()));
  sl.registerLazySingleton(() => GetMovieDetails(repository: sl()));
  sl.registerLazySingleton(() => GetMovieSuggestions(repository: sl()));

  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  sl.registerLazySingleton<UserRepository>(
        () => UserRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  sl.registerLazySingleton<MovieRepository>(
        () => MovieRepositoryImpl(
      networkInfo: sl(),
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(
      authConsumer: sl(),
      firestore: sl(),
      googleSignIn: sl(),
    ),
  );

  sl.registerLazySingleton<UserRemoteDataSource>(
        () => UserRemoteDataSourceImpl(firestore: sl(), firebaseAuth: sl()),
  );

  sl.registerLazySingleton<MovieRemoteDataSource>(
        () => MovieRemoteDataSourceImpl(api: sl()),
  );

  sl.registerLazySingleton<MovieLocalDataSource>(
        () => MovieLocalDataSource(cache: sl()),
  );
}