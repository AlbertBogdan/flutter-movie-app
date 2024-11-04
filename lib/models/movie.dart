// movie.dart
import 'package:moviedb/models/genre.dart';

class Movie {
  final int id;
  final String title;
  final String posterPath;
  final String overview;
  final double voteAverage;
  final int voteCount;
  String budget;
  List<Genre> genres;
  List<int> genreIds;

  Movie({
    required this.id,
    required this.title,
    this.posterPath = '',
    this.overview = '',
    this.voteAverage = 0.0,
    this.voteCount = 0,
    this.budget = 'Unknown',
    this.genres = const [],
    this.genreIds = const [],
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'] ?? 'No title',
      posterPath: json['poster_path'] ?? '',
      overview: json['overview'] ?? '',
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      voteCount: json['vote_count'] ?? 0,
      budget: json.containsKey('budget') ? json['budget'].toString() : 'Unknown',
      genreIds: List<int>.from(json['genre_ids'] ?? []),
    );
  }
}
