import 'package:flutter_app2/note.dart';
import 'package:flutter_app2/note_database.dart';
import 'package:flutter_app2/note_details_view.dart';
import 'package:flutter/material.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  NoteDatabase noteDatabase = NoteDatabase.instance;
  List<NoteModel> notes = [];

  @override
  void initState() {
    refreshNotes();
    super.initState();
  }

  @override
  dispose() {
    // Close the database
    noteDatabase.close();
    super.dispose();
  }

  /// Gets all the notes from the database and updates the state
  refreshNotes() {
    noteDatabase.readAll().then((value) {
      setState(() {
        notes = value;
      });
    });
  }

  /// Navigates to the NoteDetailsView and refreshes the notes after the navigation
  goToNoteDetailsView({int? id}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteDetailsView(noteId: id)),
    );
    refreshNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Center(
        child: notes.isEmpty
            ? const Text(
                'Aún no hay alumnos',
                style: TextStyle(color: Colors.white),
              )
            : ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return GestureDetector(
                    onTap: () => goToNoteDetailsView(id: note.id),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Fecha de registro: ${note.createdTime?.toLocal().toString().split(' ')[0] ?? ''}',
                              ),
                              Text(
                                'Nombre: ${note.nombre}',
                                style: Theme.of(context).textTheme.headlineMedium,
                              ),
                              Text(
                                'Carrera: ${note.carrera}',
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              Text(
                                'Ingreso: ${note.ingreso?.toLocal().toString().split(' ')[0] ?? ''}',
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              Text(
                                'Edad: ${note.edad}',
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              if (note.isFavorite)
                                Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: goToNoteDetailsView,
        tooltip: 'Registrar estudiante',
        child: const Icon(Icons.add),
      ),
    );
  }
}
