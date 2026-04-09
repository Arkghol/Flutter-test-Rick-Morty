import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:r_m_list/core/theme/app_dimensions.dart';
import 'package:r_m_list/presentation/blocs/favorites/favorites_cubit.dart';
import 'package:r_m_list/presentation/blocs/favorites/favorites_state.dart';
import 'package:r_m_list/presentation/widgets/character_card.dart';
import 'package:r_m_list/presentation/widgets/empty_favorites_view.dart';
import 'package:r_m_list/presentation/widgets/error_view.dart';
import 'package:r_m_list/presentation/widgets/loading_indicator.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, state) {
        return switch (state) {
          FavoritesInitial() || FavoritesLoading() => const LoadingIndicator(),
          FavoritesError(:final message) => ErrorView(
            message: message,
            onRetry: () => context.read<FavoritesCubit>().loadFavorites(),
          ),
          FavoritesLoaded(:final favorites) =>
            favorites.isEmpty
                ? const EmptyFavoritesView()
                : ListView.builder(
                    padding: AppDimensions.listBottomPadding,
                    itemCount: favorites.length,
                    itemBuilder: (context, index) {
                      final character = favorites[index];
                      return CharacterCard(
                        character: character,
                        onFavoriteTap: () => context
                            .read<FavoritesCubit>()
                            .onToggleFavorite(character.id),
                      );
                    },
                  ),
        };
      },
    );
  }
}
