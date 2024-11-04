import 'package:flutter/material.dart';

class PaginationControls extends StatelessWidget {
  final int currentPage;
  final VoidCallback onNextPage;
  final VoidCallback onPreviousPage;

  PaginationControls({
    required this.currentPage,
    required this.onNextPage,
    required this.onPreviousPage,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color activeColor = Theme.of(context).primaryColor;
    final Color iconBackgroundColor = isDarkMode ? Colors.grey[800]! : Colors.grey[300]!;
    final Color iconColor = isDarkMode ? Colors.white : Colors.black87;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Previous Page Button
          InkWell(
            onTap: currentPage > 1 ? onPreviousPage : null,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: currentPage > 1 ? iconBackgroundColor : Colors.grey[400]!,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                color: currentPage > 1 ? iconColor : Colors.grey[600]!,
                size: 20,
              ),
            ),
          ),
          SizedBox(width: 16),

          // Current Page Indicator
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[800]! : Colors.grey[200]!,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Text(
              'Page $currentPage',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: iconColor,
              ),
            ),
          ),
          SizedBox(width: 16),

          // Next Page Button
          InkWell(
            onTap: onNextPage,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.arrow_forward_ios,
                color: iconColor,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
