import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes_provider_app/pages/home_page.dart';
import 'package:notes_provider_app/provider/notes_provider.dart';
import 'package:notes_provider_app/provider/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure that Flutter is initialized
  await Hive.initFlutter(); // Initialize Hive
  var box = await Hive.openBox('notesBox'); // Open the box

  runApp(ChangeNotifierProvider(
    // providers: [
    //   ChangeNotifierProvider(create: (context) => NotesModel()),
    //   ChangeNotifierProvider(create: (context) => ThemeProvider()),
    // ],
    create: (context) => ThemeProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      theme: Provider.of<ThemeProvider>(context).getTheme,
    );
  }
}
