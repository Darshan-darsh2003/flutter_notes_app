import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes_provider_app/data/database.dart';
import 'package:notes_provider_app/provider/notes_provider.dart';
import 'package:notes_provider_app/provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _myNotes = Hive.box('notesBox');
  NotesDatabase db = NotesDatabase();

  @override
  void initState() {
    if (_myNotes.get("NOTESLIST") == null) {
      // db.createInitialData();
      db.updateDataBase();
    } else {
      db.loadNotes();
    }

    super.initState();
  }

  TextEditingController _titleTextController = TextEditingController();
  TextEditingController _descriptionTextController = TextEditingController();

  void handleTitleTextChange(String value) {
    setState(() {
      _titleTextController.text = value;
    });
  }

  void handleDescriptionTextChange(String value) {
    setState(() {
      _descriptionTextController.text = value;
    });
  }

//
  void createNote() {
    if (_titleTextController.text.isEmpty ||
        _descriptionTextController.text.isEmpty) {
      return;
    }
    // final notesModel = Provider.of<NotesModel>(context, listen: false);
    // Note note = Note(
    //   title: _titleTextController.text,
    //   description: _descriptionTextController.text,
    // );

    // notesModel.addNotes(note);
    setState(() {
      db.addNotes({
        'title': _titleTextController.text,
        'description': _descriptionTextController.text
      });
      _titleTextController.clear();
      _descriptionTextController.clear();
      Navigator.pop(context);
      db.updateDataBase();
    });
  }

  void handleRemoveNotes(note) {
    // final notesModel = Provider.of<NotesModel>(context, listen: false);
    // notesModel.removeNotes(note);
    setState(() {
      db.removeNotes(note);
      db.updateDataBase();
    });
  }

  void Function() handleNoteUpdate(index) {
    return () {
      // final notesModel = Provider.of<NotesModel>(context, listen: false);
      // notesModel.updateNotes(index, note);

      if (_titleTextController.text.isEmpty ||
          _descriptionTextController.text.isEmpty) {
        return;
      }

      var note = {
        'title': _titleTextController.text,
        'description': _descriptionTextController.text
      };
      setState(() {
        db.updateNotes(note, index);
        _titleTextController.clear();
        _descriptionTextController.clear();
        Navigator.pop(context);
        db.updateDataBase();
      });
    };
  }

  void handleAddNote() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(5), // This makes the corners square
            ),
            title: const Text('Add Note'),
            content: Container(
              margin: const EdgeInsets.all(10),
              height: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextField(
                      cursorColor: Provider.of<ThemeProvider>(context)
                                  .getTheme
                                  .brightness ==
                              Brightness.dark
                          ? Colors.white
                          : Colors.black,
                      onChanged: handleTitleTextChange,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(borderSide: BorderSide()),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Provider.of<ThemeProvider>(context)
                                            .getTheme
                                            .brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black)),
                        floatingLabelStyle: TextStyle(
                            color: Provider.of<ThemeProvider>(context)
                                        .getTheme
                                        .brightness ==
                                    Brightness.dark
                                ? Colors.white
                                : Colors.black),
                      )),
                  TextField(
                    cursorColor: Provider.of<ThemeProvider>(context)
                                .getTheme
                                .brightness ==
                            Brightness.dark
                        ? Colors.white
                        : Colors.black,
                    onChanged: handleDescriptionTextChange,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                      floatingLabelStyle: TextStyle(
                          color: Provider.of<ThemeProvider>(context)
                                      .getTheme
                                      .brightness ==
                                  Brightness.dark
                              ? Colors.white
                              : Colors.black),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Provider.of<ThemeProvider>(context)
                                          .getTheme
                                          .brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black)),
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel',
                    style: TextStyle(
                        color: Provider.of<ThemeProvider>(context)
                                    .getTheme
                                    .brightness ==
                                Brightness.dark
                            ? Colors.white
                            : Colors.black)),
              ),
              TextButton(
                onPressed: () {
                  createNote();
                },
                child: Text('Add',
                    style: TextStyle(
                        color: Provider.of<ThemeProvider>(context)
                                    .getTheme
                                    .brightness ==
                                Brightness.dark
                            ? Colors.white
                            : Colors.black)),
              ),
            ],
          );
        });
  }

  void handleNotesShow(note, index) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(5), // This makes the corners square
            ),
            // title: Text(
            //   note['title'],
            //   style: const TextStyle(
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),

            // content: Text(note['description']),
            content: Container(
              height: 200,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextField(
                      cursorColor: Provider.of<ThemeProvider>(context)
                                  .getTheme
                                  .brightness ==
                              Brightness.dark
                          ? Colors.white
                          : Colors.black,
                      controller: _titleTextController..text = note['title'],
                      onChanged: handleTitleTextChange,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Provider.of<ThemeProvider>(context)
                                            .getTheme
                                            .brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black)),
                        floatingLabelStyle: TextStyle(
                            color: Provider.of<ThemeProvider>(context)
                                        .getTheme
                                        .brightness ==
                                    Brightness.dark
                                ? Colors.white
                                : Colors.black),
                      ),
                    ),
                    TextField(
                      cursorColor: Provider.of<ThemeProvider>(context)
                                  .getTheme
                                  .brightness ==
                              Brightness.dark
                          ? Colors.white
                          : Colors.black,
                      controller: _descriptionTextController
                        ..text = note['description'],
                      onChanged: handleDescriptionTextChange,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Provider.of<ThemeProvider>(context)
                                            .getTheme
                                            .brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black)),
                        floatingLabelStyle: TextStyle(
                            color: Provider.of<ThemeProvider>(context)
                                        .getTheme
                                        .brightness ==
                                    Brightness.dark
                                ? Colors.white
                                : Colors.black),
                      ),
                    ),
                  ]),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close',
                    style: TextStyle(
                        color: Provider.of<ThemeProvider>(context)
                                    .getTheme
                                    .brightness ==
                                Brightness.dark
                            ? Colors.white
                            : Colors.black)),
              ),
              TextButton(
                  onPressed: handleNoteUpdate(index),
                  child: Text('Save',
                      style: TextStyle(
                          color: Provider.of<ThemeProvider>(context)
                                      .getTheme
                                      .brightness ==
                                  Brightness.dark
                              ? Colors.white
                              : Colors.black))),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 8, top: 5),
          child: Text('Notes',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary, fontSize: 30)),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: Icon(
                  Provider.of<ThemeProvider>(context).getTheme.brightness ==
                          Brightness.dark
                      ? Icons.wb_sunny
                      : Icons.nights_stay),
              onPressed: () {
                final themeProvider =
                    Provider.of<ThemeProvider>(context, listen: false);
                themeProvider.toggleTheme();
              },
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
      ),
      body: db.notesList.isEmpty
          ? const Center(
              child: Text('Tap on the + button to add new notes.'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: db.notesList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => handleNotesShow(db.notesList[index], index),
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(db.notesList[index]['title'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20)),
                                const SizedBox(height: 10),
                                SizedBox(
                                    width: 250,
                                    child: Text(
                                      db.notesList[index]['description'],
                                      style: const TextStyle(fontSize: 15),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                    )),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () =>
                              handleRemoveNotes(db.notesList[index]),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => handleAddNote(),
        child: Icon(
          Icons.add,
          color: Provider.of<ThemeProvider>(context).getTheme.brightness ==
                  Brightness.dark
              ? Colors.white
              : Colors.black,
        ),
      ),
    );
  }
}
