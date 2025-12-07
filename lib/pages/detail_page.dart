import 'package:flutter/material.dart';
import 'package:flutter_movie_app_dio_riverpod/data/providers/movie_detail_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailPage extends ConsumerWidget {
  final int movieId;

  const DetailPage({super.key, required this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieDetailAsync = ref.watch(movieDetailProvider(movieId));

    return Scaffold(
      appBar: AppBar(title: const Text('Movie Details')),
      body: movieDetailAsync.when(
        data: (movie) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Poster
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Text(
                movie.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              // Rating, runtime, release date
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const SizedBox(width: 4),
                  Text(movie.voteAverage.toString()),
                  const SizedBox(width: 16),
                  Text('${movie.runtime} min'),
                  const SizedBox(width: 16),
                  Text(movie.releaseDate),
                ],
              ),
              const SizedBox(height: 8),

              // Genres
              Wrap(
                spacing: 8,
                children: movie.genres
                    .map((g) => Chip(label: Text(g)))
                    .toList(),
              ),
              const SizedBox(height: 16),

              // Overview
              const Text(
                'Overview',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(movie.overview, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
