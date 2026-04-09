import 'package:dartz/dartz.dart';

import 'package:r_m_list/core/error/failures.dart';
import 'package:r_m_list/domain/repositories/character_repository.dart';

class SearchCharacters {
  const SearchCharacters(this.repository);
  final CharacterRepository repository;

  Future<Either<Failure, CharacterPage>> call(String query, int page) {
    return repository.searchCharacters(query, page);
  }
}
