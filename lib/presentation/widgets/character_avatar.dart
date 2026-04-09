import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:r_m_list/core/theme/app_dimensions.dart';
import 'package:r_m_list/core/theme/app_icons.dart';

class CharacterAvatar extends StatelessWidget {
  const CharacterAvatar({
    required this.imageUrl,
    super.key,
    this.size = AppDimensions.avatarSize,
  });
  final String imageUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: size,
      height: size,
      fit: BoxFit.cover,
      placeholder: (_, _) => SizedBox(
        width: size,
        height: size,
        child: const Center(
          child: CircularProgressIndicator(
            strokeWidth: AppDimensions.avatarPlaceholderStroke,
          ),
        ),
      ),
      errorWidget: (_, _, _) => SizedBox(
        width: size,
        height: size,
        child: const Icon(
          AppIcons.brokenImage,
          size: AppDimensions.brokenImageIconSize,
        ),
      ),
    );
  }
}
