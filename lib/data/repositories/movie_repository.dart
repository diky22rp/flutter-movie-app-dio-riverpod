import 'package:dio/dio.dart';
import 'package:flutter_movie_app_dio_riverpod/core/constants.dart';
import 'package:flutter_movie_app_dio_riverpod/data/models/movie_model.dart';

class MovieRepository {
  final Dio dio;

  MovieRepository({required this.dio});

  Future<List<MovieModel>> fetchMovies({
    required int page,
    String? query,
  }) async {
    final String url;
    final Map<String, dynamic> params = {
      'api_key': TMDB_API_KEY,
      'language': 'en-US',
      'page': page,
    };

    if (query != null && query.isNotEmpty) {
      url = '/search/movie';
      params['query'] = query;
    } else {
      url = '/movie/popular';
    }

    try {
      final response = await dio.get(url, queryParameters: params);
      final results = response.data['results'] as List;
      return results.map((e) => MovieModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception('Failed to fetch movies: ${e.message}');
    }
  }

  Future<List<MovieModel>> searchMovies({
    required String query,
    int page = 1,
  }) async {
    return fetchMovies(page: page, query: query);
  }
}
