import 'package:r_m_list/domain/entities/character.dart';

class CharacterListState {
  const CharacterListState({
    this.characters = const [],
    this.currentPage = 1,
    this.hasMore = true,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.isSearching = false,
    this.searchQuery = '',
    this.errorMessage,
  });
  final List<Character> characters;
  final int currentPage;
  final bool hasMore;
  final bool isLoading;
  final bool isLoadingMore;
  final bool isSearching;
  final String searchQuery;
  final String? errorMessage;

  CharacterListState copyWith({
    List<Character>? characters,
    int? currentPage,
    bool? hasMore,
    bool? isLoading,
    bool? isLoadingMore,
    bool? isSearching,
    String? searchQuery,
    String? Function()? errorMessage,
  }) {
    return CharacterListState(
      characters: characters ?? this.characters,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isSearching: isSearching ?? this.isSearching,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}
