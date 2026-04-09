import 'package:dartz/dartz.dart';

import 'package:r_m_list/core/error/failures.dart';
import 'package:r_m_list/domain/entities/character.dart';
import 'package:r_m_list/domain/repositories/character_repository.dart';

class GetFavorites {
  const GetFavorites(this.repository);
  final CharacterRepository repository;

  Future<Either<Failure, List<Character>>> call() {
    return repository.getFavorites();
  }
}
