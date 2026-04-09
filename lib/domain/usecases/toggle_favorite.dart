import 'package:dartz/dartz.dart';

import 'package:r_m_list/core/error/failures.dart';
import 'package:r_m_list/domain/entities/character.dart';
import 'package:r_m_list/domain/repositories/character_repository.dart';

class ToggleFavorite {
  const ToggleFavorite(this.repository);
  final CharacterRepository repository;

  Future<Either<Failure, Character>> call(int characterId) {
    return repository.toggleFavorite(characterId);
  }
}
