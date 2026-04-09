import 'package:flutter/foundation.dart';

@immutable
class Character {
  const Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.type,
    required this.gender,
    required this.originName,
    required this.locationName,
    required this.image,
    required this.episodeCount,
    required this.created,
    this.isFavorite = false,
  });
  final int id;
  final String name;
  final String status;
  final String species;
  final String type;
  final String gender;
  final String originName;
  final String locationName;
  final String image;
  final int episodeCount;
  final DateTime created;
  final bool isFavorite;

  Character copyWith({
    int? id,
    String? name,
    String? status,
    String? species,
    String? type,
    String? gender,
    String? originName,
    String? locationName,
    String? image,
    int? episodeCount,
    DateTime? created,
    bool? isFavorite,
  }) {
    return Character(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      species: species ?? this.species,
      type: type ?? this.type,
      gender: gender ?? this.gender,
      originName: originName ?? this.originName,
      locationName: locationName ?? this.locationName,
      image: image ?? this.image,
      episodeCount: episodeCount ?? this.episodeCount,
      created: created ?? this.created,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Character &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          isFavorite == other.isFavorite;

  @override
  int get hashCode => Object.hash(id, isFavorite);
}
