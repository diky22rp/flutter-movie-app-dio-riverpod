import 'package:flutter_movie_app_dio_riverpod/data/repositories/movie_detail_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

final movieDetailRepositoryProvider = Provider<MovieDetailRepository>(
  (ref) => MovieDetailRepository(dio: Dio()),
);

final movieDetailProvider = FutureProvider.family((ref, int id) async {
  final repo = ref.read(movieDetailRepositoryProvider);
  return repo.fetchMovieDetail(id);
});
