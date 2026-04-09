import 'package:flutter_test/flutter_test.dart';

import 'package:r_m_list/domain/entities/character.dart';

void main() {
  test('Character equality is based on id and isFavorite', () {
    final now = DateTime.now();
    final a = Character(
      id: 1,
      name: 'Rick',
      status: 'Alive',
      species: 'Human',
      type: '',
      gender: 'Male',
      originName: 'Earth',
      locationName: 'Earth',
      image: '',
      episodeCount: 1,
      created: now,
    );
    final b = Character(
      id: 1,
      name: 'Different Name',
      status: 'Dead',
      species: 'Alien',
      type: '',
      gender: 'Female',
      originName: 'Mars',
      locationName: 'Mars',
      image: '',
      episodeCount: 2,
      created: now,
    );

    // Same id + same isFavorite (default false) → equal
    expect(a, equals(b));
    expect(a.hashCode, equals(b.hashCode));

    // Different isFavorite → not equal
    final c = b.copyWith(isFavorite: true);
    expect(a, isNot(equals(c)));
    expect(a.hashCode, isNot(equals(c.hashCode)));
  });

  test('Character copyWith works correctly', () {
    final now = DateTime.now();
    final character = Character(
      id: 1,
      name: 'Rick',
      status: 'Alive',
      species: 'Human',
      type: '',
      gender: 'Male',
      originName: 'Earth',
      locationName: 'Earth',
      image: '',
      episodeCount: 1,
      created: now,
    );

    final toggled = character.copyWith(isFavorite: true);
    expect(toggled.isFavorite, isTrue);
    expect(toggled.name, equals('Rick'));
    expect(toggled.id, equals(1));
  });
}
