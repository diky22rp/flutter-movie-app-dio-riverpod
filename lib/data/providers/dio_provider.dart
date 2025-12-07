import 'package:dio/dio.dart';
import 'package:flutter_movie_app_dio_riverpod/core/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: TMDB_BASE_URL,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      queryParameters: {'api_key': TMDB_API_KEY},
    ),
  );
  return dio;
});
