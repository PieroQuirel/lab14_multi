import 'package:flutter_app2/note_view.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Laboratorio 14',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NotesView(),
    );
  }
}
