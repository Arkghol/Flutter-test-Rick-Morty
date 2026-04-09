import 'package:r_m_list/data/models/character_model.dart';

class PaginatedResponse {
  const PaginatedResponse({required this.info, required this.results});

  factory PaginatedResponse.fromJson(Map<String, dynamic> json) {
    return PaginatedResponse(
      info: PageInfo.fromJson(json['info'] as Map<String, dynamic>),
      results: (json['results'] as List<dynamic>)
          .map((e) => CharacterModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
  final PageInfo info;
  final List<CharacterModel> results;
}

class PageInfo {
  const PageInfo({
    required this.count,
    required this.pages,
    this.next,
    this.prev,
  });

  factory PageInfo.fromJson(Map<String, dynamic> json) {
    return PageInfo(
      count: json['count'] as int,
      pages: json['pages'] as int,
      next: json['next'] as String?,
      prev: json['prev'] as String?,
    );
  }
  final int count;
  final int pages;
  final String? next;
  final String? prev;
}
