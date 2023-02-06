import 'dart:io';
import 'package:path/path.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/user.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "main.db");
    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE User(id INTEGER PRIMARY KEY, username TEXT, password TEXT)");
  }

  Future<int> saveUser(User user) async {
    var dbClient = await db;
    int res = await dbClient!.insert("User", user.toMap());
    return res;
  }

  Future<User> checkUser(User user) async{
    var dbClient = await db;
    List<Map<String,dynamic>> res = await
    dbClient!.query("User",where:'"username" = ? and "password"=?',whereArgs: [user.username,user.password]);
    for (var row in res)
    {
      return Future<User>.value(User.map(row));
    }
    return Future<User>.error("Unable to find User");
  }

  Future<List<User>> getAllUser() async {
    var dbClient = await db;
    List<User> users=[];
    List<Map<String,dynamic>> res = await dbClient!.query("User");
    for(var row in res)
    {
      users.add(User.map(row));
    }
    return Future<List<User>>.value(users);
  }
}
