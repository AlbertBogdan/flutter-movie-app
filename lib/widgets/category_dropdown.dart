import 'package:flutter/material.dart';

class CategoryDropdown extends StatefulWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  CategoryDropdown({
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  _CategoryDropdownState createState() => _CategoryDropdownState();
}

class _CategoryDropdownState extends State<CategoryDropdown> {
  final List<String> categories = ['Popular', 'Top Rated', 'Upcoming', 'Now Playing'];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showCategoryDialog(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.selectedCategory,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_drop_down, color: Theme.of(context).iconTheme.color),
          ],
        ),
      ),
    );
  }

  void _showCategoryDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: categories.map((category) {
              return ListTile(
                title: Text(
                  category,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                onTap: () {
                  widget.onCategorySelected(category);
                  Navigator.pop(context);
                },
                selected: widget.selectedCategory == category,
                selectedTileColor: Theme.of(context).highlightColor.withOpacity(0.1),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
