import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:notes/services/notes_service.dart';
import 'package:notes/views/note_list.dart';

void setupLocator() {
  GetIt.instance.registerLazySingleton(() {
    return NotesService();
  });
}

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NoteList(),
    );
  }
}
