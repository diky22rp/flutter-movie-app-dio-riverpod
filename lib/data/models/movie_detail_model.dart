class MovieDetailModel {
  final int id;
  final String title;
  final String overview;
  final List<String> genres;
  final int runtime;
  final String releaseDate;
  final String posterPath;
  final double voteAverage;

  MovieDetailModel({
    required this.id,
    required this.title,
    required this.overview,
    required this.genres,
    required this.runtime,
    required this.releaseDate,
    required this.posterPath,
    required this.voteAverage,
  });

  factory MovieDetailModel.fromJson(Map<String, dynamic> json) {
    // parsing genres dari list object menjadi list string
    List<String> genreNames = [];
    if (json['genres'] != null) {
      genreNames = (json['genres'] as List)
          .map((g) => g['name'] as String)
          .toList();
    }

    return MovieDetailModel(
      id: json['id'],
      title: json['title'] ?? '',
      overview: json['overview'] ?? '',
      genres: genreNames,
      runtime: json['runtime'] ?? 0,
      releaseDate: json['release_date'] ?? '',
      posterPath: json['poster_path'] ?? '',
      voteAverage: (json['vote_average'] != null)
          ? (json['vote_average'] as num).toDouble()
          : 0.0,
    );
  }
}
