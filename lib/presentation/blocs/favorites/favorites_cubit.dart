import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:r_m_list/domain/usecases/get_favorites.dart';
import 'package:r_m_list/domain/usecases/toggle_favorite.dart';
import 'package:r_m_list/presentation/blocs/favorites/favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit({
    required GetFavorites getFavorites,
    required ToggleFavorite toggleFavorite,
  })  : _getFavorites = getFavorites,
        _toggleFavorite = toggleFavorite,
        super(const FavoritesInitial());
  final GetFavorites _getFavorites;
  final ToggleFavorite _toggleFavorite;

  Future<void> loadFavorites() async {
    emit(const FavoritesLoading());
    final result = await _getFavorites();
    result.fold(
      (failure) => emit(FavoritesError(failure.message)),
      (favorites) => emit(FavoritesLoaded(favorites)),
    );
  }

  Future<void> onToggleFavorite(int characterId) async {
    final result = await _toggleFavorite(characterId);
    result.fold(
      (failure) => emit(FavoritesError(failure.message)),
      (_) => unawaited(loadFavorites()),
    );
  }
}
