import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:r_m_list/domain/usecases/get_characters.dart';
import 'package:r_m_list/domain/usecases/search_characters.dart';
import 'package:r_m_list/domain/usecases/toggle_favorite.dart';
import 'package:r_m_list/presentation/blocs/character_list/character_list_state.dart';

class CharacterListCubit extends Cubit<CharacterListState> {
  CharacterListCubit({
    required GetCharacters getCharacters,
    required SearchCharacters searchCharacters,
    required ToggleFavorite toggleFavorite,
  })  : _getCharacters = getCharacters,
        _searchCharacters = searchCharacters,
        _toggleFavorite = toggleFavorite,
        super(const CharacterListState());
  final GetCharacters _getCharacters;
  final SearchCharacters _searchCharacters;
  final ToggleFavorite _toggleFavorite;

  bool _isLoadingMore = false;
  int _searchSequence = 0;

  Future<void> loadCharacters() async {
    emit(state.copyWith(isLoading: true, errorMessage: () => null));

    (state.searchQuery.isEmpty
            ? await _getCharacters(1)
            : await _searchCharacters(state.searchQuery, 1))
        .fold(
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          isSearching: false,
          errorMessage: () => failure.message,
        ),
      ),
      (page) => emit(
        state.copyWith(
          isLoading: false,
          isSearching: false,
          characters: page.characters,
          hasMore: page.hasMore,
          currentPage: 1,
          errorMessage: () => null,
        ),
      ),
    );
  }

  Future<void> loadMore() async {
    if (_isLoadingMore || !state.hasMore) return;
    _isLoadingMore = true;

    final nextPage = state.currentPage + 1;
    emit(state.copyWith(isLoadingMore: true));

    (state.searchQuery.isEmpty
            ? await _getCharacters(nextPage)
            : await _searchCharacters(state.searchQuery, nextPage))
        .fold(
      (failure) => emit(
        state.copyWith(
          isLoadingMore: false,
          errorMessage: () => failure.message,
        ),
      ),
      (page) => emit(
        state.copyWith(
          isLoadingMore: false,
          characters: [...state.characters, ...page.characters],
          hasMore: page.hasMore,
          currentPage: nextPage,
          errorMessage: () => null,
        ),
      ),
    );

    _isLoadingMore = false;
  }

  Future<void> search(String query) async {
    final seq = ++_searchSequence;

    emit(
      state.copyWith(
        searchQuery: query,
        currentPage: 1,
        hasMore: true,
        isSearching: true,
        errorMessage: () => null,
      ),
    );

    final result = query.isEmpty
        ? await _getCharacters(1)
        : await _searchCharacters(query, 1);

    // Stale response — a newer search was started while we awaited.
    if (seq != _searchSequence) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          isSearching: false,
          errorMessage: () => failure.message,
        ),
      ),
      (page) => emit(
        state.copyWith(
          isLoading: false,
          isSearching: false,
          characters: page.characters,
          hasMore: page.hasMore,
          currentPage: 1,
          errorMessage: () => null,
        ),
      ),
    );
  }

  Future<void> onToggleFavorite(int characterId) async {
    final result = await _toggleFavorite(characterId);
    result.fold((_) {}, (updated) {
      final newList = state.characters
          .map(
            (c) => c.id == characterId
                ? c.copyWith(isFavorite: updated.isFavorite)
                : c,
          )
          .toList();
      emit(state.copyWith(characters: newList));
    });
  }
}
