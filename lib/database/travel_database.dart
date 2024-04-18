import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:app_travel/models/travel.dart';

class TravelDatabase {
  static final TravelDatabase instance = TravelDatabase._init();

  TravelDatabase._init();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('travels.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE travels(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        city TEXT NOT NULL,
        numberOfPersons INTEGER NOT NULL,
        travelDate TEXT NOT NULL,
        image TEXT NOT NULL,
        cost REAL NOT NULL
      )
    ''');
  }

  Future<Travel> create(Travel travel) async {
    final db = await instance.database;
    final id = await db.insert('travels', travel.toJson());
    return travel.copy(id: id);
  }

  Future<List<Travel>> getAllTravels() async {
    final db = await instance.database;
    final result = await db.query('travels');
    return result.map((json) => Travel.fromJson(json)).toList();
  }

  Future<Travel> getTravelById(int id) async {
    final db = await instance.database;
    final result = await db.query('travels', where: 'id = ?', whereArgs: [id]);
    return Travel.fromJson(result.first);
  }

  Future<int> updateTravel(Travel travel) async {
    final db = await instance.database;
    return await db.update('travels', travel.toJson(),
        where: 'id = ?', whereArgs: [travel.id]);
  }

  Future<int> deleteTravelById(int id) async {
    final db = await instance.database;
    return await db.delete('travels', where: 'id = ?', whereArgs: [id]);
  }
}
