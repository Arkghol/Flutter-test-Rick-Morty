import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:r_m_list/core/theme/app_theme.dart';
import 'package:r_m_list/core/theme/theme_cubit.dart';
import 'package:r_m_list/l10n/app_localizations.dart';
import 'package:r_m_list/presentation/screens/home_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: themeMode,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          localizationsDelegates: L10n.localizationsDelegates,
          supportedLocales: L10n.supportedLocales,
          onGenerateTitle: (context) => L10n.of(context).appTitle,
          home: const HomeScreen(),
        );
      },
    );
  }
}
