import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class MovieSearchDelegate extends SearchDelegate {
  final Function(String) onSearch;
  final TextEditingController searchController;

  MovieSearchDelegate({
    required this.onSearch,
    required this.searchController,
  });

  @override
  String get searchFieldLabel => 'Search movies';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          searchController.clear();
          onSearch(''); // Clears the search
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      onSearch(query);
    });
    close(context, null);
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
