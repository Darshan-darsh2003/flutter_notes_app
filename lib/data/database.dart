import 'package:hive/hive.dart';
import 'package:notes_provider_app/provider/notes_provider.dart';

class NotesDatabase {
  List notesList = [];

  final _myBox = Hive.box('notesBox');

  // void createInitialData() {
  //   notesList = [
  //     {'title': 'Note 1', 'description': 'This is the first note'},
  //     {'title': 'Note 2', 'description': 'This is the second note'},
  //     {'title': 'Note 3', 'description': 'This is the third note'}
  //   ];
  // }

  void loadNotes() {
    notesList = _myBox.get('NOTESLIST', defaultValue: notesList);
  }

  void updateDataBase() {
    _myBox.put('NOTESLIST', notesList);
  }

  void addNotes(note) {
    notesList.add(note);
    updateDataBase();
  }

  void removeNotes(note) {
    notesList.remove(note);
    updateDataBase();
  }

  void updateNotes(note, index) {
    print("updated note $note");
    notesList[index] = note;
    updateDataBase();
  }
}
