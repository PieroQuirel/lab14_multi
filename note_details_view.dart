import 'package:flutter/material.dart';
import 'package:flutter_app2/note.dart';
import 'package:flutter_app2/note_database.dart';

class NoteDetailsView extends StatefulWidget {
  const NoteDetailsView({super.key, this.noteId});
  final int? noteId;

  @override
  State<NoteDetailsView> createState() => _NoteDetailsViewState();
}

class _NoteDetailsViewState extends State<NoteDetailsView> {
  NoteDatabase noteDatabase = NoteDatabase.instance;

  TextEditingController nombreController = TextEditingController();
  TextEditingController carreraController = TextEditingController();
  TextEditingController ingresoController = TextEditingController();
  TextEditingController edadController = TextEditingController();

  late NoteModel note;
  bool isLoading = false;
  bool isNewNote = false;
  bool isFavorite = false;

  @override
  void initState() {
    refreshNotes();
    super.initState();
  }

  /// Gets the note from the database and updates the state if the noteId is not null else it sets the isNewNote to true
  refreshNotes() {
    if (widget.noteId == null) {
      setState(() {
        isNewNote = true;
      });
      return;
    }
    noteDatabase.read(widget.noteId!).then((value) {
      setState(() {
        note = value;
        nombreController.text = note.nombre;
        carreraController.text = note.carrera;
        ingresoController.text = note.ingreso?.toLocal().toString().split(' ')[0] ?? '';
        edadController.text = note.edad?.toString() ?? '';
        isFavorite = note.isFavorite;
      });
    });
  }

  /// Creates a new note if the isNewNote is true else it updates the existing note
  createNote() {
    setState(() {
      isLoading = true;
    });
    final model = NoteModel(
      nombre: nombreController.text,
      number: 1,
      carrera: carreraController.text,
      ingreso: DateTime.parse(ingresoController.text),
      edad: int.parse(edadController.text),
      isFavorite: isFavorite,
      createdTime: DateTime.now(),
    );
    if (isNewNote) {
      noteDatabase.create(model);
    } else {
      model.id = note.id;
      noteDatabase.update(model);
    }
    setState(() {
      isLoading = false;
    });
    Navigator.pop(context);
  }

  /// Deletes the note from the database and navigates back to the previous screen
  deleteNote() {
    noteDatabase.delete(note.id!);
    Navigator.pop(context);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        ingresoController.text = picked.toLocal().toString().split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isFavorite = !isFavorite;
              });
            },
            icon: Icon(!isFavorite ? Icons.favorite_border : Icons.favorite),
          ),
          Visibility(
            visible: !isNewNote,
            child: IconButton(
              onPressed: deleteNote,
              icon: const Icon(Icons.delete),
            ),
          ),
          IconButton(
            onPressed: createNote,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      TextField(
                        controller: nombreController,
                        cursorColor: Colors.white,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Ingresar nombre del estudiante',
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextField(
                        controller: carreraController,
                        cursorColor: Colors.white,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Ingresar carrera a la que pertenece',
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      TextField(
                        controller: ingresoController,
                        cursorColor: Colors.white,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Ingresa la fecha de ingreso',
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          suffixIcon: Icon(Icons.calendar_today, color: Colors.white),
                        ),
                        readOnly: true,
                        onTap: () => _selectDate(context),
                      ),
                      TextField(
                        controller: edadController,
                        keyboardType: TextInputType.number,
                        cursorColor: Colors.white,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Ingresa la edad',
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
