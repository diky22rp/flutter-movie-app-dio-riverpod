import 'package:dio/dio.dart';
import 'package:flutter_movie_app_dio_riverpod/core/constants.dart';
import 'package:flutter_movie_app_dio_riverpod/data/models/movie_detail_model.dart';

class MovieDetailRepository {
  final Dio dio;

  MovieDetailRepository({required this.dio});

  Future<MovieDetailModel> fetchMovieDetail(int id) async {
    final response = await dio.get(
      '$TMDB_BASE_URL/movie/$id',
      queryParameters: {'api_key': TMDB_API_KEY, 'language': 'en-US'},
    );

    return MovieDetailModel.fromJson(response.data);
  }
}
