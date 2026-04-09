import 'package:flutter/material.dart';

import 'package:r_m_list/core/theme/app_dimensions.dart';
import 'package:r_m_list/domain/entities/character.dart';
import 'package:r_m_list/presentation/widgets/character_card.dart';

class PaginatedCharacterList extends StatelessWidget {
  const PaginatedCharacterList({
    required this.characters,
    required this.hasMore,
    required this.scrollController,
    required this.onRefresh,
    required this.onFavoriteTap,
    super.key,
  });
  final List<Character> characters;
  final bool hasMore;
  final ScrollController scrollController;
  final RefreshCallback onRefresh;
  final ValueChanged<int> onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        controller: scrollController,
        padding: AppDimensions.listBottomPadding,
        itemCount: characters.length + (hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= characters.length) {
            return const Padding(
              padding: AppDimensions.listItemLoadingPadding,
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: AppDimensions.avatarPlaceholderStroke,
                ),
              ),
            );
          }

          final character = characters[index];
          return CharacterCard(
            character: character,
            onFavoriteTap: () => onFavoriteTap(character.id),
          );
        },
      ),
    );
  }
}
