import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'item.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('items.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        buyPrice REAL NOT NULL,
        sellPrice REAL NOT NULL,
        quantity INTEGER NOT NULL
      )
    ''');
  }

  Future<int> insertItem(Item item) async {
    final db = await instance.database;
    final id = await db.insert('items', item.toMap());
    print('Inserted item id: $id');
    return id;
  }

  Future<int> updateItem(Item item) async {
    final db = await instance.database;
    return db.update(
      'items',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<int> deleteItem(int id) async {
    final db = await instance.database;
    return db.delete(
      'items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Item>> getAllItems() async {
    final db = await instance.database;
    final result = await db.query('items');
    return result.map((json) => Item.fromMap(json)).toList();
  }
}