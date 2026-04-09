import 'package:flutter/material.dart';

abstract final class AppIcons {
  // Navigation
  static const charactersTab = Icons.people_outline;
  static const charactersTabSelected = Icons.people;
  static const favoritesTab = Icons.star_border;
  static const favoritesTabSelected = Icons.star;

  // Actions
  static const themeLight = Icons.light_mode;
  static const themeDark = Icons.dark_mode;
  static const search = Icons.search;
  static const clear = Icons.clear;
  static const refresh = Icons.refresh;
  static const favorite = Icons.star;
  static const favoriteOutline = Icons.star_border;

  // States
  static const error = Icons.error_outline;
  static const brokenImage = Icons.broken_image;
  static const emptyFavorites = Icons.star_border;
}
