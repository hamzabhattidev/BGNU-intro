import 'package:flutter/material.dart';
import 'db_helper.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({Key? key}) : super(key: key);

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _notes = [];

  @override
  void initState() {
    super.initState();
    _fetchNotes();
  }

  void _fetchNotes() async {
    final data = await DBHelper.getNotes();
    setState(() {
      _notes = data;
    });
  }

  void _saveNote() async {
    if (_controller.text.trim().isEmpty) return;

    await DBHelper.insertNote(_controller.text.trim());
    _controller.clear();
    _fetchNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notes')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Enter note',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _saveNote,
              child: const Text('Save Note'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _notes.length,
                itemBuilder: (context, index) {
                  final note = _notes[index];
                  return ListTile(
                    leading: const Icon(Icons.note),
                    title: Text(note['content']),
                    subtitle: Text('ID: ${note['id']}'),
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
