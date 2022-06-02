// Get a location using getDatabasesPath
import 'package:flutter_meteo/models/city.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'weather.db'),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE city(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL)",
        );
      },
      version: 1,
    );
  }

  Future<void> deleteCityById(int id) async {
    final db = await initializeDB();
    await db.delete(
      'city',
      where: "id = ?",
      whereArgs: [id],
    );
  }


  Future<void> deleteCityByName(String name) async {
    final db = await initializeDB();
    await db.delete(
      'city',
      where: "name = ?",
      whereArgs: [name],
    );
  }

  Future<List<City>> retrieveCity() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('city');
    return queryResult.map((e) => City.fromMap(e)).toList();
  }

  Future<int> insertCity(String cityname) async {
    int result = 0;
    final Database db = await initializeDB();
    result = await db.insert('city', City(name: cityname).toMap());

    return result;
  }
}
