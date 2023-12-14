import 'dart:developer';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper{
  static Database? _database;

  Future<Database> get database async{
    if(_database != null){
      return _database!;
    }
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase()async{
    final Directory directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path,'notesDatabase.db');

    await databaseExists(path);
    final exits = await databaseExists(path);
    if(exits){
      log("{===================>Database exist}");
    }else{
      log("{===================>Database not exist}");
    }

    _database = await openDatabase(path, version: 1, onCreate: _onCreate);
    return _database!;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE notesTable(id INTEGER PRIMARY KEY AUTOINCREMENT,time TEXT, date TEXT ,title TEXT,note TEXT);
  ''');

    await db.execute('''
    CREATE TABLE trashTable(id INTEGER PRIMARY KEY,time TEXT, date TEXT ,title TEXT,note TEXT,deletedDate TEXT);
  ''');

    await db.execute('''
    CREATE TABLE shoppingNotesTable(
             id INTEGER PRIMARY KEY AUTOINCREMENT,
             time TEXT, 
             date TEXT,
             title TEXT,
             capital REAL,
             remain REAL,
             itemTitles TEXT, 
             prices TEXT, 
             totalCost REAL 
             );
  ''');

    await db.execute('''
    CREATE TABLE recycleBinTable(
              id INTEGER PRIMARY KEY,
              time TEXT, 
              date TEXT,
              title TEXT,
              capital REAL,
              remain REAL,
              itemTitles TEXT, 
              prices TEXT, 
              totalCost REAL, 
              deletedDate TEXT);
  ''');
  }
  Future<void> closeDatabase() async{
    if(_database != null && _database!.isOpen){
      await _database!.close();
      _database = null; // Set to null to indicate that the database is closed
      log("{===================>Database closed}");
    }
  }
}
  //-- Use TEXT for storing JSON array as a string
//-- Use TEXT for storing JSON array as a string
//-- Use REAL for storing double values