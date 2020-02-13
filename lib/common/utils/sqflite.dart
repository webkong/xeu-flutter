import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB {
  static Database db;

  init() async {
    print('init');
    var dataBasePath = await getDatabasesPath();
    String path = join(dataBasePath, 'xeu.db');
    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db
          .execute('CREATE TABLE Session (key TEXT PRIMARY KEY, value TEXT)');
    });
    print(database);
    db = database;
    await initSession();
  }

  initSession() async {
    await this.clear();
    await this.insert('token', null);
    await this.insert('u_id', null);
  }

  update(key, value) async {
    if (db == null) {
      await init();
    }
    try {
      int count = await db.rawUpdate(
          'UPDATE Session SET value = ? WHERE key = ?', [value, key]);
      print('updated: $count');
    } catch (e) {
      print('update error');
      print(e);
    }
  }

  query(key) async {
    print('------- query: $key -------');
    if (db == null) {
      await init();
    }
    List<Map> list =
        await db.rawQuery('SELECT value FROM Session WHERE key = ?', [key]);
    print('value : $list');
    return list[0]['value'] ?? null;
  }

  findAll() async {
    if (db == null) {
      await init();
    }
    List<Map> list = await db.rawQuery('SELECT * FROM Session ');
    print('db find all query');
    print(list);
    return list;
  }

  insert(key, value) async {
    if (db == null) {
      await init();
    }
    await db.transaction((txn) async {
      int id1 = await txn.rawInsert(
          'INSERT INTO Session(key, value) VALUES(?, ?)', [key, value]);
      print('inserted2: $id1');
    });
  }

  delete(key) async {
    if (db == null) {
      await init();
    }
    var count = await db.rawDelete('DELETE FROM Session WHERE key = ?', [key]);
    assert(count == 1);
  }

  clear() async {
    if (db == null) {
      await init();
    }
    await db.execute('DELETE FROM Session');
  }
}
