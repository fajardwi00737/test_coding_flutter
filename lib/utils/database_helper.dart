import 'dart:io';
import 'package:path/path.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test_live_code/model/catatan_model.dart';
import 'package:test_live_code/model/user_model.dart';
import 'package:test_live_code/utils/general_sharedpreference.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static Database _db;
  final String tableUser = "User";
  final String tableCatatan = "Catatan";
  final String columnName = "name";
  final String columnUserName = "email";
  final String columnPassword = "password";

  Future<Database> get db async {
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
    await db.execute(
        "CREATE TABLE User(id INTEGER PRIMARY KEY, namaDepan TEXT,namaBelakang TEXT, email TEXT,tanggalLahir TEXT,jenisKelamin TEXT, password TEXT, fotoProfil TEXT)");
    await db.execute(
        "CREATE TABLE Catatan(id INTEGER PRIMARY KEY, judul TEXT, deskripsi TEXT, waktuPengingat TEXT, intervalPengingat TEXT, lampiran TEXT)");
    print("Table is created");
  }

  ///User Query
  //Save data
  Future<int> saveUser(UserModel user) async {
    var dbClient = await db;
    print(user.namaDepan);
    List<Map> maps = await dbClient.query(tableUser,
        columns: [columnUserName],
        where: "$columnUserName = ?",
        whereArgs: [user.email]);

    if(maps.length != 0){
      print("email has been used");
      return null;
    } else {
      int res = await dbClient.insert("User", user.toMap());
      List<Map> list = await dbClient.rawQuery('SELECT * FROM User');
      print(list);
      print("hasil regis");
      return res;
    }


  }
  //update data
  Future<Map> updateUser(UserModel userModel) async{
    var dbClient = await db;

    var userRes = await dbClient.update(
      tableUser,
      userModel.toMap(),
      where: 'id = ?',
      whereArgs: [GeneralSharedPreferences.readInt("user_id")],
    );
    print(userRes);
    List<Map> lists = await dbClient.rawQuery('SELECT * FROM User where id = ? ',[GeneralSharedPreferences.readInt("user_id")]);
    print(lists);
    print("hasil Update");

    if (lists.length > 0) {
      print("User Exist !!!");
      return lists[0];
    }else {
      return null;
    }
  }

  //delete data
  Future<int> deleteUser(UserModel user) async {
    var dbClient = await db;
    int res = await dbClient.delete("User");
    return res;
  }
  Future<Map> selectUser(UserModel user) async{
    print("Select User");
    print(user.email);
    print(user.password);
    var dbClient = await db;
    List<Map> lists = await dbClient.rawQuery('SELECT * FROM User where email = ? and password = ?',[user.email,user.password]);
    // print(maps);
    print(lists);
    print("id user => "+lists[0]['id'].toString());
    await GeneralSharedPreferences.writeInt("user_id", lists[0]['id']);
    print("hasil Login");
    if (lists.length > 0) {
      print("User Exist !!!");
      return lists[0];
    }else {
      return null;
    }
  }

  ///Catatan Query

  //Save data
  Future<int> saveCatatan(CatatanModel catatan) async {
    var dbClient = await db;
    int res = await dbClient.insert("Catatan", catatan.toMap());
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Catatan');
    print(list);
    print("hasil save catatan");
    return res;
  }

  //delete data
  Future<int> deleteCatatan(CatatanModel catatan) async {
    var dbClient = await db;
    int res = await dbClient.delete("Catatan",where: 'id = ?',whereArgs: [catatan.id]);
    print("hasil delete catatan");
    return res;
  }

  //update data
  Future<Map> updateCatatan(CatatanModel catatan) async{
    var dbClient = await db;

    var userRes = await dbClient.update(
      tableCatatan,
      catatan.toMap(),
      where: 'id = ?',
      whereArgs: [catatan.id],
    );
    print(userRes);
    List<Map> lists = await dbClient.rawQuery('SELECT * FROM Catatan where id = ? ',[catatan.id]);
    print(lists);
    print("hasil Update Catatan");

    if (lists.length > 0) {
      print("User Exist !!!");
      return lists[0];
    }else {
      return null;
    }
  }

  //select data
  Future<List<Map<String, dynamic>>> selectCatatan(int userId) async{
    print("Select catatan");
    var dbClient = await db;
    List<Map> lists = await dbClient.rawQuery('SELECT * FROM Catatan');
    print(lists);
    if (lists.length > 0) {
      print("Catatan Exist !!!");
      return lists;
    }else {
      return null;
    }
  }
}