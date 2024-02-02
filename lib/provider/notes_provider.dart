import 'package:flutter/material.dart';

// class NotesModel extends ChangeNotifier {
//   final List<Note> _notes = [];

//   List<Note> get notes => _notes;

//   void addNotes(Note note) {
//     _notes.add(note);
//     notifyListeners();
//   }

//   void removeNotes(index) {
//     _notes.remove(index);
//     notifyListeners();
//   }
// }

class Note {
  final String title;
  final String description;
  // final DateTime date = DateTime.now();

  Note({
    required this.title,
    required this.description,
  });
}
