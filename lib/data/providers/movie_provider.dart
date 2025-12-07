import 'package:flutter_movie_app_dio_riverpod/data/models/movie_model.dart';
import 'package:flutter_movie_app_dio_riverpod/data/repositories/movie_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dio_provider.dart';

final movieRepositoryProvider = Provider<MovieRepository>((ref) {
  return MovieRepository(dio: ref.watch(dioProvider));
});

class MoviesNotifier extends Notifier<List<MovieModel>> {
  late final MovieRepository repository;
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasNext = true;

  @override
  List<MovieModel> build() {
    repository = ref.watch(movieRepositoryProvider);
    fetchNextPage();
    return [];
  }

  bool get isLoading => _isLoading;

  Future<void> fetchNextPage() async {
    if (_isLoading || !_hasNext) return;
    _isLoading = true;
    try {
      final movies = await repository.fetchMovies(page: _currentPage);
      if (movies.isEmpty) {
        _hasNext = false;
      } else {
        _currentPage++;
        state = [...state, ...movies];
      }
    } finally {
      _isLoading = false;
    }
  }
}

// Provider modern
final moviesProvider = NotifierProvider<MoviesNotifier, List<MovieModel>>(
  () => MoviesNotifier(),
);
