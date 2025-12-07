import 'package:flutter_movie_app_dio_riverpod/data/models/movie_model.dart';
import 'package:flutter_movie_app_dio_riverpod/data/repositories/movie_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dio_provider.dart';

// Repository Provider
final movieRepositoryProvider = Provider<MovieRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return MovieRepository(dio: dio);
});

// MoviesNotifier infinite scroll + search
class MoviesNotifier extends Notifier<List<MovieModel>> {
  late final MovieRepository repository;
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasNext = true;

  bool get isLoading => _isLoading;

  @override
  List<MovieModel> build() {
    repository = ref.read(movieRepositoryProvider);
    fetchNextPage();
    return [];
  }

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

  Future<void> searchMovies(String query) async {
    _isLoading = true;
    _currentPage = 1;
    _hasNext = true;

    try {
      final results = await repository.searchMovies(query: query, page: 1);
      state = results;
    } finally {
      _isLoading = false;
    }
  }

  void reset() {
    _currentPage = 1;
    _hasNext = true;
    state = [];
    fetchNextPage();
  }
}

final moviesProvider = NotifierProvider<MoviesNotifier, List<MovieModel>>(
  () => MoviesNotifier(),
);
