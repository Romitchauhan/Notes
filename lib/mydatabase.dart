import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static Database? _database;
  final String DATABASENAME = "mynotes.db";
  final String CREATE_NOTE_TABLE =
      "create table IF NOT EXISTS notes (_id integer PRIMARY KEY AUTOINCREMENT, "
      "title text, notestype integer, detail text)";
  static final int DATABASE_VERSION = 1, SUCCESS = 1, ERROR = -1;
  DatabaseHelper.createInstance();
  factory DatabaseHelper() {
    if (_databaseHelper == null)
      _databaseHelper = DatabaseHelper.createInstance();
    return _databaseHelper!;
  }
  get database async {
    if (_database == null) _database = await initilizeDatabase();
    return _database;
  }

  Future<Database> initilizeDatabase() async {
    Directory DocumentDirectory = await getApplicationDocumentsDirectory();
    String DatabasePath = DocumentDirectory.path + DATABASENAME;
    var notesdb = openDatabase(DatabasePath,
        version: DATABASE_VERSION, onCreate: CreateTable);
    return notesdb;
  }

  Future<void> CreateTable(Database db, int version) async {
    db.execute(CREATE_NOTE_TABLE);
  }

  //insert, update, delete, sql query will be executed using this method
  int RunQuery(String sql) {
    print(sql);
    try {
      _database?.execute(sql);
      return SUCCESS;
    } catch (e) {
      print("Error occured ");
      print(e.toString());
      return ERROR;
    }
  }
  Future<List<Map<String, Object?>>?> FetchRow(String sql) async {
    print(sql);
    Database? db = await database;
    List<Map<String, Object?>>? result = await db?.rawQuery(sql);
    return result;
  }
}
