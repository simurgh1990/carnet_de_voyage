import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // Utilisation de 'const' au lieu de 'final' car ces variables sont des constantes
  static const _databaseName = "voyages.db";
  static const _databaseVersion = 1;

  static const table = 'voyage';

  static const columnId = '_id';
  static const columnName = 'name';
  static const columnDescription = 'description';
  static const columnStartDate = 'start_date';
  static const columnEndDate = 'end_date';

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnDescription TEXT NOT NULL,
            $columnStartDate TEXT NOT NULL,
            $columnEndDate TEXT NOT NULL
          )
          ''');
  }

  // Méthode pour insérer un nouveau voyage dans la base de données
  Future<int?> insert(Map<String, dynamic> row) async {
    Database? db = await database;
    return await db?.insert(table, row);
  }

  // Méthode pour récupérer tous les voyages de la base de données
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database? db = await database;
    return await db?.query(table) ?? [];
  }

  // Méthode pour récupérer un voyage par ID
  Future<Map<String, dynamic>?> queryRowById(int id) async {
    Database? db = await database;
    var result = await db?.query(table, where: '$columnId = ?', whereArgs: [id]);
    return result?.isNotEmpty == true ? result?.first : null;
  }

  // Méthode pour mettre à jour un voyage existant
  Future<int?> update(Map<String, dynamic> row) async {
    Database? db = await database;
    int id = row[columnId];
    return await db?.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  // Méthode pour supprimer un voyage
  Future<int?> delete(int id) async {
    Database? db = await database;
    return await db?.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}