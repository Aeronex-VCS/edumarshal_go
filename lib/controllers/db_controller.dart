import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'model.dart';

class DataBaseCon {
  Future<Database> initializedDB() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'db_user.db'),
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE userCred (id INTEGER PRIMARY KEY, accessToken TEXT NOT NULL, tokenType TEXT, expiresIn INTEGER, xContextId TEXT, xUserId TEXT, xLogoId TEXT, xRx TEXT, pChangeSetting TEXT, pChangeStatus TEXT, sessionId TEXT, xToken TEXT, issued TEXT, expires TEXT)',
        );
      },
    );
  }

  Future<Database> initializedComDB() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'db_userBoolee.db'),
      version: 1,
      onCreate: (Database db, int version) async {
        return await db.execute(
          'CREATE TABLE checkBoolee(id INTEGER PRIMARY KEY, boole INTEGER NOT NULL)',
        );
      },
    );
  }

// insert data
  Future<int> insertUser(User user) async {
    int result = 0;
    // Map<String, dynamic> userMap = <String, dynamic>{};
    // userMap['id'] = user.id;
    // userMap['accessToken'] = user.accessToken;
    // userMap['tokenType'] = user.tokenType;
    // userMap['expiresIn'] = user.expiresIn;
    // userMap['xContextId'] = user.xContextId;
    // userMap['xUserId'] = user.xUserId;
    // userMap['xLogoId'] = user.xLogoId;
    // userMap['xRx'] = user.xRx;
    // userMap['pChangeSetting'] = user.pChangeSetting;
    // userMap['pChangeStatus'] = user.pChangeStatus;
    // userMap['sessionId'] = user.sessionId;
    // userMap['xToken'] = user.xToken;
    // userMap['issued'] = user.issued;
    // userMap['expires'] = user.expires;
    final Database db = await initializedDB();
    result = await db.insert('userCred', user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return result;
  }

  Future<int> insertCom() async {
    int result = 0;
    BoolCom boolcom = BoolCom(
      id: 1,
      boole: 1,
    );
    final Database db = await initializedDB();
    result = await db.insert('checkBoolee', boolcom.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return result;
  }

// retrieve data
  Future<List<Object?>> retrieveUser() async {
    final Database db = await initializedDB();
    final List<Map<String, Object?>> queryResult = await db.query('userCred');
    return queryResult.map((e) => e['accessToken']).toList();
  }

  // get user by id
  Future<User?> getUserById(int userId) async {
    final Database db = await initializedDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'userCred',
      where: 'id = ?',
      whereArgs: [userId],
    );
    print("object");
    if (maps.isNotEmpty) {
      print("data got");
      return User.fromMap(maps.first);
    } else {
      print("empty");
      return null;
    }
  }

  Future<List<BoolCom>> retrieveComUser() async {
    final Database db = await initializedDB();
    final List<Map<String, Object?>> queryResult =
        await db.query('checkBoolee');
    return queryResult.map((e) => BoolCom.fromMap(e)).toList();
  }

// delete user
  Future<void> deleteUser(int id) async {
    final db = await initializedDB();
    await db.delete(
      'userCred',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> deleteComUser(int id) async {
    final db = await initializedDB();
    await db.delete(
      'checkBoolee',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
