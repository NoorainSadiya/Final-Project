import 'package:flutter/material.dart';
import 'dart:convert'; // For JSON encoding/decoding
import 'package:shared_preferences/shared_preferences.dart'; // For persistence
import 'add_book_page.dart';
import 'search_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeContent(),
    SearchPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BookBuddy'),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        ],
      ),
    );
  }
}

// Custom Book model
class Book {
  final String title;
  final String author;

  Book({required this.title, required this.author});

  Map<String, dynamic> toJson() => {'title': title, 'author': author};

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(title: json['title'], author: json['author']);
  }
}

class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  List<Book> _addedBooks = [];

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  // Load books from shared preferences
  Future<void> _loadBooks() async {
    final prefs = await SharedPreferences.getInstance();
    final booksJson = prefs.getString('addedBooks') ?? '[]';
    final List<dynamic> booksList = json.decode(booksJson);
    setState(() {
      _addedBooks = booksList.map((json) => Book.fromJson(json)).toList();
    });
  }

  // Save books to shared preferences
  Future<void> _saveBooks() async {
    final prefs = await SharedPreferences.getInstance();
    final booksJson =
        json.encode(_addedBooks.map((book) => book.toJson()).toList());
    await prefs.setString('addedBooks', booksJson);
  }

  // Add a new book to the list and save it
  void _addNewBook(String title, String author) {
    setState(() {
      _addedBooks.add(Book(title: title, author: author));
    });
    _saveBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Recently Added Books',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              _addedBooks.isEmpty
                  ? Center(
                      child: Text(
                        'No books added yet. Tap the + button to add a new book!',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: _addedBooks.length,
                        itemBuilder: (context, index) {
                          final book = _addedBooks[index];
                          return Card(
                            elevation: 2,
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              title: Text(
                                book.title,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text('by ${book.author}'),
                            ),
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddBookPage(onAddBook: _addNewBook),
                ),
              );
            },
            child: Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
