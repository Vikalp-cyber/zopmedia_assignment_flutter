import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:zopmedia_assignment/models/vehicle.dart';
class VehicleDatabase {
  static final VehicleDatabase instance = VehicleDatabase._init();

  static Database? _database;

  VehicleDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('vehicles.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE vehicles (
        id INTEGER PRIMARY KEY,
        make TEXT,
        model TEXT,
        price INTEGER,
        image TEXT
      )
    ''');
  }

  Future<void> insertVehicles(List<Vehicle> vehicles) async {
    final db = await instance.database;
    final batch = db.batch();

    for (var vehicle in vehicles) {
      batch.insert(
        'vehicles',
        vehicle.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<List<Vehicle>> getAllVehicles() async {
    final db = await instance.database;
    final maps = await db.query('vehicles');

    return maps.map((e) => Vehicle.fromMap(e)).toList();
  }

  Future<void> clearVehicles() async {
    final db = await instance.database;
    await db.delete('vehicles');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
