import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:moviedb/models/movie.dart';
import 'package:moviedb/models/genre.dart';


class ApiService {
  final String apiKey = 'api';
  final String baseUrl = 'https://api.themoviedb.org/3';

  List<Genre>? _cachedGenres;
  Map<int, String>? _genreMap;

  Future<List<Genre>> fetchGenres({String language = 'en-US'}) async {
    if (_cachedGenres != null) return _cachedGenres!;

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/genre/movie/list?api_key=$apiKey&language=$language'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> genreJson = json.decode(response.body)['genres'];
        _cachedGenres = genreJson.map((json) => Genre.fromJson(json)).toList();
        _genreMap = {for (var genre in _cachedGenres!) genre.id: genre.name};
        return _cachedGenres!;
      } else {
        throw Exception('Failed to load genres');
      }
    } catch (e) {
      throw Exception('Network error');
    }
  }

  Future<List<Movie>> fetchMovies(String category, int page, String language) async {
    await fetchGenres(language: language);

    String endpoint;
    switch (category) {
      case 'Now Playing':
        endpoint = 'movie/now_playing';
        break;
      case 'Top Rated':
        endpoint = 'movie/top_rated';
        break;
      case 'Upcoming':
        endpoint = 'movie/upcoming';
        break;
      case 'Popular':
      default:
        endpoint = 'movie/popular';
        break;
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$endpoint?api_key=$apiKey&language=$language&page=$page'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> movieJson = json.decode(response.body)['results'];
        return Future.wait(movieJson.map((json) async {
          final movie = Movie.fromJson(json);
          movie.genres = movie.genreIds?.map((id) {
            final genreName = _genreMap?[id] ?? 'Unknown';
            return Genre(id: id, name: genreName);
          }).toList() ?? [];

          final detailedMovie = await fetchMovieDetails(movie.id, language);
          movie.budget = detailedMovie.budget;

          return movie;
        }).toList());
      } else {
        throw Exception('Failed to load movies: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error');
    }
  }

  Future<Movie> fetchMovieDetails(int movieId, String language) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/movie/$movieId?api_key=$apiKey&language=$language'),
      );

      if (response.statusCode == 200) {
        final movieJson = json.decode(response.body);
        return Movie.fromJson(movieJson);
      } else {
        throw Exception('Failed to load movie');
      }
    } catch (e) {
      throw Exception('Network error');
    }
  }
  Future<List<Movie>> searchMovies(String query, int page, String language) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/search/movie?api_key=$apiKey&query=$query&include_adult=false&language=$language&page=$page'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> movieJson = json.decode(response.body)['results'];
        return movieJson.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load search results');
      }
    } catch (e) {
      throw Exception('Network error');
    }
  }

}
