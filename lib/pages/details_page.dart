import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  final Map<String, dynamic> book; // Accept book data

  const DetailsPage({required this.book, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book['title'] ?? 'Book Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Book thumbnail
              if (book['imageLinks']?['thumbnail'] != null)
                Center(
                  child: Image.network(
                    book['imageLinks']['thumbnail'],
                    width: 150,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.broken_image,
                        size: 50,
                        color: Colors.grey,
                      );
                    },
                  ),
                ),
              const SizedBox(height: 16),

              // Title
              Text(
                book['title'] ?? 'No Title',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              // Author(s)
              if (book['authors'] != null)
                Text(
                  'Author(s): ${book['authors'].join(', ')}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              const SizedBox(height: 8),

              // Publisher
              if (book['publisher'] != null)
                Text(
                  'Publisher: ${book['publisher']}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              const SizedBox(height: 8),

              // Description
              if (book['description'] != null)
                Text(
                  book['description']!,
                  style: Theme.of(context).textTheme.bodyLarge,
                )
              else
                Text(
                  'No description available.',
                  style: TextStyle(color: Colors.grey),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
