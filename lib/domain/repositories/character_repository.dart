import 'package:dartz/dartz.dart';

import 'package:r_m_list/core/error/failures.dart';
import 'package:r_m_list/domain/entities/character.dart';

typedef CharacterPage = ({List<Character> characters, bool hasMore});

abstract class CharacterRepository {
  Future<Either<Failure, CharacterPage>> getCharacters(int page);
  Future<Either<Failure, CharacterPage>> searchCharacters(
    String query,
    int page,
  );
  Future<Either<Failure, List<Character>>> getFavorites();
  Future<Either<Failure, Character>> toggleFavorite(int characterId);
}
