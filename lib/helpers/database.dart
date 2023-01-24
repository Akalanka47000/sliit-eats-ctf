import 'package:sqflite/sqflite.dart';

class DB {
  static late Database _db;
  
  static init() async {
    _db = await openDatabase('local.db', version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('CREATE TABLE Config (id INTEGER PRIMARY KEY, name TEXT, value TEXT)');
          await db.execute('INSERT INTO Config (name, value) VALUES ("enc_temp_key", "23de45Bch4%dfsv43DcYfdgerfdfgdfg")');
        });

  }

  static close() async {
    await _db.close();
  }
}