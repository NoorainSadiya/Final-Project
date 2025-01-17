import 'package:flutter/material.dart';

class AddBookPage extends StatefulWidget {
  final Function(String, String) onAddBook;

  AddBookPage({required this.onAddBook});

  @override
  _AddBookPageState createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();

  void _submitBook() {
    final title = _titleController.text;
    final author = _authorController.text;

    if (title.isNotEmpty && author.isNotEmpty) {
      widget.onAddBook(title, author); // Pass book info back to HomeContent
      Navigator.pop(context); // Go back to the HomePage
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in both fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a New Book'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Book Title'),
            ),
            TextField(
              controller: _authorController,
              decoration: InputDecoration(labelText: 'Author'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitBook,
              child: Text('Add Book'),
            ),
          ],
        ),
      ),
    );
  }
}
