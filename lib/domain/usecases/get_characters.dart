import 'package:dartz/dartz.dart';

import 'package:r_m_list/core/error/failures.dart';
import 'package:r_m_list/domain/repositories/character_repository.dart';

class GetCharacters {
  const GetCharacters(this.repository);
  final CharacterRepository repository;

  Future<Either<Failure, CharacterPage>> call(int page) {
    return repository.getCharacters(page);
  }
}
