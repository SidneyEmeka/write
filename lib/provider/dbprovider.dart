import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:write/models/writesmodel.dart';

//import '../models/ritesmodel.dart';

class Dbproviders {
  //SINGLETON DESIGN PATTERN
  static Database? db;
  static Dbproviders instance = Dbproviders._constructor();

  Dbproviders._constructor();

  //DB HELPERS
  final String dbName = "rites.db";
  final String tableName = "myrites";
  final String tableID = "id";
  final String tableContent = "content";
  final String tableisDone = "isdone";

  // Future<Database> get database async {
  //   if (_db != null) return _db!;
  //   _db = await openMyDatabase();
  //   return _db!;
  // }

  ///CRUD///
  //CREATE//
  Future<Database> openMyDatabase() async {
    final dbLocation = await getDatabasesPath();
    final dbPath = join(dbLocation, "DBNAME");
    final mydb =
        await openDatabase(dbPath, version: 1, onCreate: (db, version) {
      db.execute(
          'CREATE TABLE $tableName ($tableID INTEGER PRIMARY KEY AUTOINCREMENT,$tableContent TEXT NOT NULL, $tableisDone INTEGER NOT NULL)');
    });
    return mydb;
  }

//INSERT
  void addRite({required String content}) async {
    final db = await openMyDatabase();
    final received = await db.insert(tableName, {
      tableContent: content,
      tableisDone: 0,
    });
    if (received != 0) {
      print("Succesful");
    }
  }

  //READ
  Future<List<Writesmodel>> getAllWrites() async {
    final db = await openMyDatabase();
    final data = await db.query(tableName);
//print(data);
    List<Writesmodel> theWrites = data.map((aRow) {
      return Writesmodel(
          userContent: aRow["content"] as String,
          userWroteID: aRow["id"] as int,
          userIsDone: aRow["isdone"] as int);
    }).toList();
    return theWrites;
  }
  //UPDATE
  void updateAWrite({required int id, required int isdone}) async {
    final db = await openMyDatabase();
    await db.update(tableName, {tableisDone: isdone}, where: "id = ?", whereArgs: [id] );
  }
//CLASS END
}
