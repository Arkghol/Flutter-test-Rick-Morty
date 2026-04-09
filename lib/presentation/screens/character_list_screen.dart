import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:r_m_list/core/network/network_info.dart';
import 'package:r_m_list/core/theme/app_dimensions.dart';
import 'package:r_m_list/injection.dart';
import 'package:r_m_list/l10n/app_localizations.dart';
import 'package:r_m_list/presentation/blocs/character_list/character_list_cubit.dart';
import 'package:r_m_list/presentation/blocs/character_list/character_list_state.dart';
import 'package:r_m_list/presentation/widgets/error_view.dart';
import 'package:r_m_list/presentation/widgets/loading_indicator.dart';
import 'package:r_m_list/presentation/widgets/paginated_character_list.dart';
import 'package:r_m_list/presentation/widgets/search_field.dart';

class CharacterListScreen extends StatefulWidget {
  const CharacterListScreen({super.key});

  @override
  State<CharacterListScreen> createState() => _CharacterListScreenState();
}

class _CharacterListScreenState extends State<CharacterListScreen> {
  final _scrollController = ScrollController();
  late final StreamSubscription<bool> _connectivitySubscription;
  bool _isOffline = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _connectivitySubscription =
        sl<NetworkInfo>().onConnectivityChanged.listen(_onConnectivityChanged);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _connectivitySubscription.cancel();
    super.dispose();
  }

  void _onConnectivityChanged(bool isConnected) {
    if (isConnected && _isOffline) {
      context.read<CharacterListCubit>().loadCharacters();
    }
    setState(() => _isOffline = !isConnected);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent -
            AppDimensions.paginationScrollThreshold) {
      context.read<CharacterListCubit>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

    return Column(
      children: [
        if (_isOffline)
          MaterialBanner(
            content: Text(l10n.networkError),
            leading: const Icon(Icons.wifi_off),
            actions: const [SizedBox.shrink()],
          ),
        SearchField(
          hintText: l10n.searchHint,
          onChanged: (query) =>
              context.read<CharacterListCubit>().search(query),
        ),
        Expanded(
          child: BlocBuilder<CharacterListCubit, CharacterListState>(
            builder: (context, state) {
              if (state.isLoading && state.characters.isEmpty) {
                return const LoadingIndicator();
              }

              if (state.errorMessage != null && state.characters.isEmpty) {
                return ErrorView(
                  message: state.errorMessage!,
                  onRetry: () =>
                      context.read<CharacterListCubit>().loadCharacters(),
                );
              }

              if (state.characters.isEmpty && !state.isSearching) {
                return Center(child: Text(l10n.noCharactersFound));
              }

              return Stack(
                children: [
                  PaginatedCharacterList(
                    characters: state.characters,
                    hasMore: state.hasMore && !_isOffline,
                    scrollController: _scrollController,
                    onRefresh: () =>
                        context.read<CharacterListCubit>().loadCharacters(),
                    onFavoriteTap: (id) =>
                        context.read<CharacterListCubit>().onToggleFavorite(id),
                  ),
                  if (state.isSearching) const LoadingIndicator(),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
