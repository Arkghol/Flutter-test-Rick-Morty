import 'package:dio/dio.dart';

import 'package:r_m_list/data/models/paginated_response.dart';

class CharacterRemoteDataSource {
  const CharacterRemoteDataSource(this.dio);
  final Dio dio;

  Future<PaginatedResponse> getCharacters(int page) async {
    final response = await dio.get<Map<String, dynamic>>(
      '/character',
      queryParameters: {'page': page},
    );
    return PaginatedResponse.fromJson(response.data!);
  }

  Future<PaginatedResponse> searchCharacters(String query, int page) async {
    final response = await dio.get<Map<String, dynamic>>(
      '/character',
      queryParameters: {'name': query, 'page': page},
    );
    return PaginatedResponse.fromJson(response.data!);
  }
}
