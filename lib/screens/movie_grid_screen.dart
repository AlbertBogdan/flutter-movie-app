import 'package:flutter/material.dart';
import 'package:moviedb/widgets/category_dropdown.dart';
import 'package:moviedb/widgets/movie_card.dart';
import 'package:moviedb/widgets/pagination_controls.dart';
import 'package:moviedb/models/movie.dart';
import 'package:moviedb/services/api_service.dart';
import 'package:moviedb/delegates/movie_search_delegate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MovieGridScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final VoidCallback toggleLanguage;
  final bool isDarkMode;
  final String currentLanguage;
  final int pagelimit = 500;

  MovieGridScreen({
    required this.toggleTheme,
    required this.toggleLanguage,
    required this.isDarkMode,
    required this.currentLanguage,
  });

  @override
  _MovieGridScreenState createState() => _MovieGridScreenState();
}

class _MovieGridScreenState extends State<MovieGridScreen> {
  late Future<List<Movie>> futureMovies;
  int currentPage = 1;
  List<Movie> movies = [];
  String selectedCategory = 'Popular';
  String searchQuery = '';

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadMovies();
  }

  @override
  void didUpdateWidget(covariant MovieGridScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentLanguage != widget.currentLanguage) {
      loadMovies();
    }
  }

  Future<void> loadMovies() async {
    try {
      final fetchedMovies = searchQuery.isNotEmpty
          ? await ApiService().searchMovies(searchQuery, currentPage, widget.currentLanguage)
          : await ApiService().fetchMovies(selectedCategory, currentPage, widget.currentLanguage);

      setState(() {
        movies = fetchedMovies;
        futureMovies = Future.value(movies);
      });
    } catch (e) {
      setState(() {
        futureMovies = Future.error(e);
      });
    }
  }

  void loadNextPage() {
    setState(() {
      if (currentPage < widget.pagelimit) {
        currentPage++;
        loadMovies();
      }
    });
  }

  void loadPreviousPage() {
    setState(() {
      if (currentPage > 1) {
        currentPage--;
        loadMovies();
      }
    });
  }

  void onSearch(String query) {
    setState(() {
      searchQuery = query;
      currentPage = 1;
      loadMovies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.movieTitle),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: MovieSearchDelegate(
                  onSearch: onSearch,
                  searchController: _searchController,
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.language),
            onPressed: widget.toggleLanguage,
          ),
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: widget.toggleTheme,
          ),
          CategoryDropdown(
            selectedCategory: selectedCategory,
            onCategorySelected: (newCategory) {
              setState(() {
                selectedCategory = newCategory;
                currentPage = 1;
                loadMovies();
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Movie>>(
        future: futureMovies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final displayedMovies = searchQuery.isEmpty
                ? movies
                : movies.where((movie) => movie.title.toLowerCase().contains(searchQuery.toLowerCase())).toList();
            return LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = constraints.maxWidth < 600 ? 2 : 3;
                return Column(
                  children: [
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: 0.65,
                        ),
                        itemCount: displayedMovies.length,
                        itemBuilder: (context, index) {
                          final movie = displayedMovies[index];
                          return MovieCard(movie: movie);
                        },
                      ),
                    ),
                    PaginationControls(
                      currentPage: currentPage,
                      onNextPage: loadNextPage,
                      onPreviousPage: loadPreviousPage,
                    ),
                  ],
                );
              },
            );
          }
          return Center(child: Text('No data found'));
        },
      ),
    );
  }
}
