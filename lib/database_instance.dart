import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'datamodel.dart';

class DatabasesInstance {
  final String _databasesName = 'my_note.db';

  Database? _database;

  String nametable = 'datanote';

  Future<Database> databases() async {
    if (_database != null) return _database!;
    _database = await _initDatabases();
    return _database!;
  }

  Future _initDatabases() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _databasesName);
    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  FutureOr _onCreate(Database db, int version) async {
    await db.execute(
        'create table $nametable(int integer primary key, name text null, description text null, create_at text null, update_at text null)');
  }

  Future<List<DataModel>> all() async {
    await databases();
    final data = await _database!.query(nametable);
    List<DataModel> result = data.map((e) => DataModel.fromJson(e)).toList();
    return result;
  }

  Future<int> insert(Map<String, dynamic> row) async {
    final query = await _database!.insert(nametable, row);
    return query;
  }

  Future<int> update(int idSelect, Map<String, dynamic> row) async {
    final query = await _database!
        .update(nametable, row, where: 'id = ?', whereArgs: [idSelect]);
    return query;
  }

  Future deleted(int idSelect) async {
    await _database!.delete(nametable, where: 'id = ?', whereArgs: [idSelect]);
  }
}
