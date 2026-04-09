import 'package:flutter/material.dart';

abstract final class AppDimensions {
  // Avatar
  static const double avatarSize = 120;
  static const double avatarPlaceholderStroke = 2;
  static const double brokenImageIconSize = 40;

  // Status badge
  static const double statusDotSize = 8;
  static const double statusDotTextGap = 4;

  // Icons
  static const double largeIconSize = 64;

  // Spacing
  static const double spacingXxs = 2;
  static const double spacingXs = 4;
  static const double spacingSm = 8;
  static const double spacingMd = 12;
  static const double spacingLg = 16;
  static const double spacingXl = 24;

  // Card content
  static const cardContentPadding = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 8,
  );

  // Card margin (matches CardThemeData in AppTheme)
  static const cardMargin = EdgeInsets.symmetric(horizontal: 12, vertical: 6);

  // List
  static const listBottomPadding = EdgeInsets.only(bottom: 16);
  static const listItemLoadingPadding = EdgeInsets.all(16);

  // Search field
  static const searchFieldPadding = EdgeInsets.fromLTRB(12, 8, 12, 4);
  static const double searchFieldBorderRadius = 12;

  // Scroll
  static const double paginationScrollThreshold = 200;

  // Animation
  static const favoriteAnimationDuration = Duration(milliseconds: 200);
  static const double favoriteScalePeak = 1.3;

  // Debounce
  static const searchDebounceDuration = Duration(milliseconds: 500);
}
