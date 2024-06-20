import 'package:flutter_app2/note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class NoteDatabase {
  static final NoteDatabase instance = NoteDatabase._internal();

  static Database? _database;

  NoteDatabase._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'notes.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDatabase,
      onUpgrade: _upgradeDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    return await db.execute('''
        CREATE TABLE ${NoteFields.tableName} (
          ${NoteFields.id} ${NoteFields.idType},
          ${NoteFields.number} ${NoteFields.intType},
          ${NoteFields.nombre} ${NoteFields.textType},
          ${NoteFields.carrera} ${NoteFields.textType},
          ${NoteFields.ingreso} ${NoteFields.textType},
          ${NoteFields.edad} ${NoteFields.intType},
          ${NoteFields.isFavorite} ${NoteFields.intType},
          ${NoteFields.createdTime} ${NoteFields.textType}
        )
      ''');
  }

  Future<void> _upgradeDatabase(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        ALTER TABLE ${NoteFields.tableName} ADD COLUMN ${NoteFields.ingreso} ${NoteFields.textType}
      ''');
      await db.execute('''
        ALTER TABLE ${NoteFields.tableName} ADD COLUMN ${NoteFields.edad} ${NoteFields.intType}
      ''');
    }
  }

  Future<NoteModel> create(NoteModel note) async {
    final db = await instance.database;
    final id = await db.insert(NoteFields.tableName, note.toJson());
    return note.copy(id: id);
  }

  Future<NoteModel> read(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      NoteFields.tableName,
      columns: NoteFields.values,
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return NoteModel.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<NoteModel>> readAll() async {
    final db = await instance.database;
    const orderBy = '${NoteFields.createdTime} DESC';
    final result = await db.query(NoteFields.tableName, orderBy: orderBy);
    return result.map((json) => NoteModel.fromJson(json)).toList();
  }

  Future<int> update(NoteModel note) async {
    final db = await instance.database;
    return db.update(
      NoteFields.tableName,
      note.toJson(),
      where: '${NoteFields.id} = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      NoteFields.tableName,
      where: '${NoteFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
