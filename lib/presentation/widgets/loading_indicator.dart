import 'package:flutter/material.dart';

import 'package:r_m_list/core/theme/app_dimensions.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.spacingXl),
        child: CircularProgressIndicator(),
      ),
    );
  }
}
