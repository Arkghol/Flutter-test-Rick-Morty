import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:r_m_list/core/network/network_info.dart';
import 'package:r_m_list/core/util/constants.dart';
import 'package:r_m_list/data/database/database_helper.dart';
import 'package:r_m_list/data/datasources/character_local_data_source.dart';
import 'package:r_m_list/data/datasources/character_remote_data_source.dart';
import 'package:r_m_list/data/repositories/character_repository_impl.dart';
import 'package:r_m_list/domain/repositories/character_repository.dart';
import 'package:r_m_list/domain/usecases/get_characters.dart';
import 'package:r_m_list/domain/usecases/get_favorites.dart';
import 'package:r_m_list/domain/usecases/search_characters.dart';
import 'package:r_m_list/domain/usecases/toggle_favorite.dart';
import 'package:r_m_list/presentation/blocs/character_list/character_list_cubit.dart';
import 'package:r_m_list/presentation/blocs/favorites/favorites_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

void configureDependencies({required SharedPreferences prefs}) {
  sl
    // External
    ..registerLazySingleton(
      () =>
          Dio(BaseOptions(baseUrl: baseUrl))
            ..interceptors.add(LogInterceptor(responseBody: true)),
    )
    ..registerLazySingleton(Connectivity.new)
    // Core
    ..registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()))
    // Database
    ..registerLazySingleton(DatabaseHelper.new)
    // Data sources
    ..registerLazySingleton(() => CharacterRemoteDataSource(sl()))
    ..registerLazySingleton(() => CharacterLocalDataSource(sl()))
    // Repository
    ..registerLazySingleton<CharacterRepository>(
      () => CharacterRepositoryImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
        networkInfo: sl(),
      ),
    )
    // Use cases
    ..registerLazySingleton(() => GetCharacters(sl()))
    ..registerLazySingleton(() => SearchCharacters(sl()))
    ..registerLazySingleton(() => GetFavorites(sl()))
    ..registerLazySingleton(() => ToggleFavorite(sl()))
    // Cubits
    ..registerFactory(
      () => CharacterListCubit(
        getCharacters: sl(),
        searchCharacters: sl(),
        toggleFavorite: sl(),
      ),
    )
    ..registerFactory(
      () => FavoritesCubit(getFavorites: sl(), toggleFavorite: sl()),
    );
}
