import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DataBasePeople {

  static final String _dbName="peopleApp.db";
  static final int _dbVersion=1;
  static final String _tableName="peoples";
  static final String columnId="id";
  static final String columnName="name";
  static final String columnPhone="phone";
  static final String columnEmail="email";

  DataBasePeople._privateConstructor();
  static final DataBasePeople instance=DataBasePeople._privateConstructor();

  static Database _database;

  Future<Database> get dataBase async {

    if(_database!=null) return _database;
    _database=await _initiateDatabase();
    return _database;

  }
  _initiateDatabase() async {
    Directory directory=await getApplicationDocumentsDirectory();
    String path=join(directory.path,_dbName);
    return await openDatabase(path,version: _dbVersion,onCreate: _onCreate);
  }
  _onCreate(Database db,int version) {

    db.execute(
        '''
      CREATE TABLE $_tableName(
      $columnId INTEGER PRIMARY KEY,
      $columnName TEXT NOT NULL,
      $columnPhone TEXT,
      $columnEmail TEXT
      )
      '''
    );
  }

  Future<int> insertData(Map<String,dynamic> row) async {
    Database db=await instance.dataBase;
    return await db.insert(_tableName, row);
  }

  Future<List<Map<String,dynamic>>> allData() async{

    Database db=await instance.dataBase;
    return await db.query(_tableName);

  }
  
  Future<List<Map<String,dynamic>>> onIdData(String ID) async{

    Database db=await instance.dataBase;
    return await db.query(_tableName,where: '$columnId = ?',whereArgs: [ID]);

  }
  Future<int> deleteData(Map<String,dynamic> row) async{
    Database db=await instance.dataBase;
    int id=row[columnId];
    return await db.delete(_tableName,where: '$columnId = ?',whereArgs: [id]) ;

  }
  Future updateData(Map<String,dynamic> row) async {
    Database db=await instance.dataBase;
    int id=row[columnId];
    return await db.update(_tableName, row,where: '$columnId = ?',whereArgs: [id]);
  }
  Future truncateTable() async{
    Database db=await instance.dataBase;
    db.execute("DROP TABLE IF EXISTS $_tableName");
    db.execute(
        '''
      CREATE TABLE $_tableName(
      $columnId INTEGER PRIMARY KEY,
      $columnName TEXT NOT NULL,
      $columnPhone TEXT,
      $columnEmail TEXT
      )
      '''
    );
  }

}