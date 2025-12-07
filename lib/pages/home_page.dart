import 'package:flutter/material.dart';
import 'package:flutter_movie_app_dio_riverpod/data/providers/movie_provider.dart';
import 'package:flutter_movie_app_dio_riverpod/widgets/movie_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'detail_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      ref.read(moviesProvider.notifier).fetchNextPage();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final movies = ref.watch(moviesProvider);
    final notifier = ref.read(moviesProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Popular Movies')),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: movies.length + 1, // +1 untuk loading spinner
        itemBuilder: (context, index) {
          if (index < movies.length) {
            final movie = movies[index];
            return MovieCard(
              movie: movie,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailPage(movieId: movie.id),
                ),
              ),
            );
          } else {
            // item terakhir -> tampilkan loading spinner
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: notifier.isLoading
                    ? const CircularProgressIndicator()
                    : const SizedBox.shrink(),
              ),
            );
          }
        },
      ),
    );
  }
}
