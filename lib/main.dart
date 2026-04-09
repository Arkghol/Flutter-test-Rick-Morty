import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:r_m_list/app.dart';
import 'package:r_m_list/core/theme/theme_cubit.dart';
import 'package:r_m_list/injection.dart';
import 'package:r_m_list/presentation/blocs/character_list/character_list_cubit.dart';
import 'package:r_m_list/presentation/blocs/favorites/favorites_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  configureDependencies(prefs: prefs);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<CharacterListCubit>()..loadCharacters()),
        BlocProvider(create: (_) => sl<FavoritesCubit>()),
        BlocProvider(create: (_) => ThemeCubit(prefs: prefs)),
      ],
      child: const App(),
    ),
  );
}
