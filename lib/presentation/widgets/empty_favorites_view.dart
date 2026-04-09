import 'package:flutter/material.dart';

import 'package:r_m_list/core/theme/app_dimensions.dart';
import 'package:r_m_list/core/theme/app_icons.dart';
import 'package:r_m_list/l10n/app_localizations.dart';

class EmptyFavoritesView extends StatelessWidget {
  const EmptyFavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            AppIcons.emptyFavorites,
            size: AppDimensions.largeIconSize,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: AppDimensions.spacingLg),
          Text(
            l10n.noFavoritesYet,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: AppDimensions.spacingSm),
          Text(
            l10n.noFavoritesHint,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
