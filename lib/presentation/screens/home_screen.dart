import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:r_m_list/core/theme/app_icons.dart';
import 'package:r_m_list/core/theme/theme_cubit.dart';
import 'package:r_m_list/l10n/app_localizations.dart';
import 'package:r_m_list/presentation/blocs/favorites/favorites_cubit.dart';
import 'package:r_m_list/presentation/screens/character_list_screen.dart';
import 'package:r_m_list/presentation/screens/favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? AppIcons.themeLight
                  : AppIcons.themeDark,
            ),
            onPressed: () => context.read<ThemeCubit>().toggleTheme(),
            tooltip: l10n.toggleThemeTooltip,
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: const [CharacterListScreen(), FavoritesScreen()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
          if (index == 1) {
            context.read<FavoritesCubit>().loadFavorites();
          }
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(AppIcons.charactersTab),
            selectedIcon: const Icon(AppIcons.charactersTabSelected),
            label: l10n.charactersTab,
          ),
          NavigationDestination(
            icon: const Icon(AppIcons.favoritesTab),
            selectedIcon: const Icon(AppIcons.favoritesTabSelected),
            label: l10n.favoritesTab,
          ),
        ],
      ),
    );
  }
}
