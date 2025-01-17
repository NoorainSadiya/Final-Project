import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'details_page.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  List<dynamic> _books = [];
  bool _isLoading = false;

  // Fetch books from Google Books API
  Future<void> fetchBooks(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    final url =
        Uri.parse('https://www.googleapis.com/books/v1/volumes?q=$query');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _books = data['items'] ?? [];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to load books: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Books'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search for books',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => fetchBooks(_searchController.text),
                ),
              ),
              onSubmitted: (query) => fetchBooks(query),
            ),
            SizedBox(height: 16),

            // Search Results
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : _books.isEmpty
                    ? Expanded(child: Center(child: Text('No results found.')))
                    : Expanded(
                        child: ListView.builder(
                          itemCount: _books.length,
                          itemBuilder: (context, index) {
                            final book = _books[index]['volumeInfo'];
                            print(book['imageLinks']?['thumbnail'] ??
                                'No image URL');
                            return ListTile(
                              leading: book['imageLinks'] != null
                                  ? Image.network(
                                      book['imageLinks']['thumbnail'],
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Icon(
                                          Icons.broken_image,
                                          size: 50,
                                          color: Colors.grey,
                                        );
                                      },
                                    )
                                  : Icon(Icons.book, size: 50),
                              title: Text(book['title'] ?? 'No Title'),
                              subtitle: Text(book['authors']?.join(', ') ??
                                  'Unknown Author'),
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Book: ${book['title']}')),
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DetailsPage(book: book),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
