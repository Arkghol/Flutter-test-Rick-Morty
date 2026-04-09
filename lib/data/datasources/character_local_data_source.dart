import 'package:r_m_list/data/database/database_helper.dart';
import 'package:r_m_list/domain/entities/character.dart';

class CharacterLocalDataSource {
  const CharacterLocalDataSource(this.dbHelper);
  final DatabaseHelper dbHelper;

  Future<void> cacheCharacters(List<Character> characters, int page) async {
    final db = await dbHelper.database;
    final batch = db.batch();

    for (final character in characters) {
      batch.rawInsert(
        '''
        INSERT OR REPLACE INTO ${DatabaseHelper.table}
        (id, name, status, species, type, gender, origin_name, location_name,
         image, episode_count, created, is_favorite, page)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,
                COALESCE((SELECT is_favorite FROM ${DatabaseHelper.table} WHERE id = ?), 0),
                ?)
      ''',
        [
          character.id,
          character.name,
          character.status,
          character.species,
          character.type,
          character.gender,
          character.originName,
          character.locationName,
          character.image,
          character.episodeCount,
          character.created.toIso8601String(),
          character.id, // for COALESCE subquery
          page,
        ],
      );
    }

    await batch.commit(noResult: true);
  }

  Future<List<Character>> getCharactersByPage(int page) async {
    final db = await dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.table,
      where: 'page = ?',
      whereArgs: [page],
    );
    return maps.map(_fromMap).toList();
  }

  Future<Set<int>> getFavoriteIds() async {
    final db = await dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.table,
      columns: ['id'],
      where: 'is_favorite = 1',
    );
    return maps.map((m) => m['id']! as int).toSet();
  }

  Future<List<Character>> getFavorites() async {
    final db = await dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.table,
      where: 'is_favorite = 1',
      orderBy: 'name ASC',
    );
    return maps.map(_fromMap).toList();
  }

  Future<void> setFavorite(int id, {required bool value}) async {
    final db = await dbHelper.database;
    await db.update(
      DatabaseHelper.table,
      {'is_favorite': value ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<bool> hasPage(int page) async {
    final db = await dbHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as cnt FROM ${DatabaseHelper.table} WHERE page = ?',
      [page],
    );
    return (result.first['cnt']! as int) > 0;
  }

  Future<Character?> getCharacterById(int id) async {
    final db = await dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.table,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return _fromMap(maps.first);
  }

  Character _fromMap(Map<String, dynamic> map) {
    return Character(
      id: map['id'] as int,
      name: map['name'] as String,
      status: map['status'] as String,
      species: map['species'] as String,
      type: map['type'] as String,
      gender: map['gender'] as String,
      originName: map['origin_name'] as String,
      locationName: map['location_name'] as String,
      image: map['image'] as String,
      episodeCount: map['episode_count'] as int,
      created: DateTime.parse(map['created'] as String),
      isFavorite: (map['is_favorite'] as int) == 1,
    );
  }
}
