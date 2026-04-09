import 'package:flutter/material.dart';

import 'package:r_m_list/core/theme/app_colors.dart';
import 'package:r_m_list/core/theme/app_dimensions.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({required this.status, super.key});
  final String status;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: AppDimensions.statusDotSize,
          height: AppDimensions.statusDotSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _statusColor,
          ),
        ),
        const SizedBox(width: AppDimensions.statusDotTextGap),
        Text(status, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Color get _statusColor {
    return switch (status.toLowerCase()) {
      'alive' => AppColors.statusAlive,
      'dead' => AppColors.statusDead,
      _ => AppColors.statusUnknown,
    };
  }
}
