import 'package:flutter/material.dart';

import 'package:r_m_list/core/theme/app_colors.dart';
import 'package:r_m_list/core/theme/app_dimensions.dart';
import 'package:r_m_list/core/theme/app_icons.dart';
import 'package:r_m_list/domain/entities/character.dart';
import 'package:r_m_list/l10n/app_localizations.dart';
import 'package:r_m_list/presentation/widgets/character_avatar.dart';
import 'package:r_m_list/presentation/widgets/status_badge.dart';

class CharacterCard extends StatelessWidget {
  const CharacterCard({
    required this.character,
    required this.onFavoriteTap,
    super.key,
  });
  final Character character;
  final VoidCallback onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          children: [
            CharacterAvatar(imageUrl: character.image),
            Expanded(
              child: Padding(
                padding: AppDimensions.cardContentPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      character.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppDimensions.spacingXs),
                    Row(
                      children: [
                        StatusBadge(status: character.status),
                        const SizedBox(width: AppDimensions.spacingSm),
                        Text(
                          '- ${character.species}',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.spacingXs),
                    Text(
                      character.locationName,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppDimensions.spacingXxs),
                    Text(
                      L10n.of(context).episodesCount(character.episodeCount),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _FavoriteButton(
              isFavorite: character.isFavorite,
              onTap: onFavoriteTap,
            ),
          ],
        ),
      ),
    );
  }
}

class _FavoriteButton extends StatefulWidget {
  const _FavoriteButton({required this.isFavorite, required this.onTap});
  final bool isFavorite;
  final VoidCallback onTap;

  @override
  State<_FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<_FavoriteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppDimensions.favoriteAnimationDuration,
      vsync: this,
    );
    _scale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1, end: AppDimensions.favoriteScalePeak),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: AppDimensions.favoriteScalePeak, end: 1),
        weight: 50,
      ),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(covariant _FavoriteButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isFavorite != widget.isFavorite) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: IconButton(
        icon: Icon(
          widget.isFavorite ? AppIcons.favorite : AppIcons.favoriteOutline,
          color: widget.isFavorite ? AppColors.favoriteActive : null,
        ),
        onPressed: widget.onTap,
      ),
    );
  }
}
