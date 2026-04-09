import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:r_m_list/core/error/failures.dart';
import 'package:r_m_list/core/network/network_info.dart';
import 'package:r_m_list/data/datasources/character_local_data_source.dart';
import 'package:r_m_list/data/datasources/character_remote_data_source.dart';
import 'package:r_m_list/data/models/paginated_response.dart';
import 'package:r_m_list/domain/entities/character.dart';
import 'package:r_m_list/domain/repositories/character_repository.dart';

class CharacterRepositoryImpl implements CharacterRepository {
  CharacterRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });
  final CharacterRemoteDataSource remoteDataSource;
  final CharacterLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  Set<int>? _favoriteIdsCache;

  @override
  Future<Either<Failure, CharacterPage>> getCharacters(int page) async {
    if (await networkInfo.isConnected) {
      return _fetchFromRemote(() => remoteDataSource.getCharacters(page), page);
    }
    return _fetchFromCache(page);
  }

  @override
  Future<Either<Failure, CharacterPage>> searchCharacters(
    String query,
    int page,
  ) async {
    if (await networkInfo.isConnected) {
      return _fetchFromRemote(
        () => remoteDataSource.searchCharacters(query, page),
        page,
      );
    }
    return const Left(NetworkFailure());
  }

  @override
  Future<Either<Failure, List<Character>>> getFavorites() async {
    try {
      final favorites = await localDataSource.getFavorites();
      _favoriteIdsCache = favorites.map((c) => c.id).toSet();
      return Right(favorites);
    } on Exception catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Character>> toggleFavorite(int characterId) async {
    try {
      final character = await localDataSource.getCharacterById(characterId);
      if (character == null) {
        return const Left(CacheFailure('Character not found'));
      }
      final newValue = !character.isFavorite;
      await localDataSource.setFavorite(characterId, value: newValue);

      // Update in-memory cache.
      if (newValue) {
        _favoriteIdsCache?.add(characterId);
      } else {
        _favoriteIdsCache?.remove(characterId);
      }

      return Right(character.copyWith(isFavorite: newValue));
    } on Exception catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  Future<Either<Failure, CharacterPage>> _fetchFromRemote(
    Future<PaginatedResponse> Function() fetch,
    int page,
  ) async {
    try {
      final response = await fetch();
      final favoriteIds =
          _favoriteIdsCache ?? await localDataSource.getFavoriteIds();
      _favoriteIdsCache = favoriteIds;

      final entities = response.results.map((model) {
        return model.toEntity(isFavorite: favoriteIds.contains(model.id));
      }).toList();

      await localDataSource.cacheCharacters(entities, page);

      return Right((characters: entities, hasMore: response.info.next != null));
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Request failed'));
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, CharacterPage>> _fetchFromCache(int page) async {
    try {
      final cached = await localDataSource.getCharactersByPage(page);
      if (cached.isEmpty) {
        return const Left(NetworkFailure('No internet and no cached data'));
      }
      final hasMore = await localDataSource.hasPage(page + 1);
      return Right((characters: cached, hasMore: hasMore));
    } on Exception catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
