import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;

  DBHelper._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<void> deleteAndRecreateDatabase() async {
    if (_db != null) {
      await _db!.close();
      _db = null;
    }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'apartments.db');

    if (await databaseExists(path)) {
      await deleteDatabase(path);
      print('Database successfully deleted');
    }

    _db = await _initDB();
    print('New database created');
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'apartments.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
        CREATE TABLE apartments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        idNumber TEXT,
        houseType TEXT,
        houseNumber TEXT,
        price REAL
        )
        ''');
      }
    );
  }

  Future<int> insertApartment(Map<String, dynamic> data) async {
    final db = await database;
    try {
      data.remove('id');
      return await db.insert('apartments', data);
    } catch (e) {
      print('Error inserting Apartment: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getApartments() async {
    final db = await database;
    return await db.query('apartments');
  }
}
