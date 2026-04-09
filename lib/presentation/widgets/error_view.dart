import 'package:flutter/material.dart';

import 'package:r_m_list/core/theme/app_dimensions.dart';
import 'package:r_m_list/core/theme/app_icons.dart';
import 'package:r_m_list/l10n/app_localizations.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({required this.message, super.key, this.onRetry});
  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              AppIcons.error,
              size: AppDimensions.largeIconSize,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: AppDimensions.spacingLg),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppDimensions.spacingLg),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(AppIcons.refresh),
                label: Text(L10n.of(context).retryButton),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
