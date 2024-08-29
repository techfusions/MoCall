import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MapTypeDB {
  Future<Database> conn() async {
    return openDatabase(
      join(await getDatabasesPath(), "MapType.db"),
      version: 1,
      onCreate: (Database db, version) async {
        await db.execute("""
          
            CREATE TABLE IF NOT EXISTS Users (
              id INTEGER,
              mapType TEXT
            )
          
          """);
      },
    );
  }

  Future insert(int id, String maptype) async {
    Database db = await conn();

    // var id = await  db.insert("Users", {"firstname":firstname.toString(), "lastname":lastname.toString()});
  int result = await db.rawInsert(
        "INSERT INTO Users(id, mapType) VALUES(?,?)",
        [id, maptype]);
    return result;
  }


  Future update(int id, String maptype) async {
    final Database database = await conn();

    var updateResult = await database.rawUpdate(
        "UPDATE Users SET mapType = ? WHERE id = ?",
        [maptype, id]);
    return updateResult;
  }
}
