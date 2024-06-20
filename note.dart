class NoteFields {
  static const List<String> values = [
    id,
    number,
    nombre,
    carrera,
    ingreso,
    edad,
    isFavorite,
    createdTime,
  ];
  static const String tableName = 'notes';
  static const String idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
  static const String textType = 'TEXT NOT NULL';
  static const String intType = 'INTEGER NOT NULL';
  static const String id = '_id';
  static const String nombre = 'nombre';
  static const String number = 'number';
  static const String carrera = 'carrera';
  static const String ingreso = 'ingreso';
  static const String edad = 'edad';
  static const String isFavorite = 'is_favorite';
  static const String createdTime = 'created_time';
}


class NoteModel {
   int? id;
  final int? number;
  final String nombre;
  final String carrera;
  final DateTime? ingreso;
  final int? edad;
  final bool isFavorite;
  final DateTime? createdTime;
  NoteModel({
    this.id,
    this.number,
    required this.nombre,
    required this.carrera,
    required this. ingreso,
    required this. edad,
    this.isFavorite = false,
    this.createdTime,
  });
   Map<String, Object?> toJson() => {
        NoteFields.id: id,
        NoteFields.number: number,
        NoteFields.nombre: nombre,
        NoteFields.carrera: carrera,
        NoteFields.edad: edad,
        NoteFields.isFavorite: isFavorite ? 1 : 0,
        NoteFields.createdTime: createdTime?.toIso8601String(),
      };


  factory NoteModel.fromJson(Map<String, Object?> json) => NoteModel(
        id: json[NoteFields.id] as int?,
        number: json[NoteFields.number] as int?,
        nombre: json[NoteFields.nombre] as String,
        carrera: json[NoteFields.carrera] as String,
        ingreso:
            DateTime.tryParse(json[NoteFields.ingreso] as String? ?? ''),
        edad: json[NoteFields.id] as int?,
        isFavorite: json[NoteFields.isFavorite] == 1,
        createdTime:
            DateTime.tryParse(json[NoteFields.ingreso] as String? ?? ''),
      );
      
  NoteModel copy({
    int? id,
    int? number,
    String? nombre,
    String? carrera,
    int? edad,
    DateTime? ingreso,
    bool? isFavorite,
    DateTime? createdTime,
  }) =>
      NoteModel(
        id: id ?? this.id,
        number: number ?? this.number,
        nombre: nombre ?? this.nombre,
        carrera: carrera ?? this.carrera,
        ingreso: ingreso ?? this.ingreso,
        edad: edad ?? this.edad,
        isFavorite: isFavorite ?? this.isFavorite,
        createdTime: createdTime ?? this.createdTime,
      );
}
