
import 'package:event_manager/models/task.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper{
  static Database? _db;
  static final int _version = 1;
  static final String _tableName = "tasks";

  static Future<void> initDb() async{
    if(_db != null){
      return;
    }
    try{
      //join using your laptop
      String _path = await getDatabasesPath() + 'tasks.db';
      _db = await openDatabase(
          _path,
        version: _version,
        onUpgrade: (db,version,newVersion){
            //write upgrade query here
        },
        onCreate: (db, version){
            print('Creating a new one');
            return db.execute(
              "CREATE TABLE $_tableName("
                  "id INTEGER PRIMARY KEY AUTOINCREMENT,"
                  "title STRING,"
                  " description TEXT,"
                  " date STRING,"
                  "startTime STRING,"
                  " endTime STRING,"
                  "location STRING, "
                  "category STRING, "
                  "remind INTEGER, "
                  "repeat STRING,"
                  "color INTEGER,"
                  "photoPath TEXT,"
                  "videoPath TEXT,"
                   "filePath TEXT,"
                  "isCompleted INTEGER)",
            );
        }
      );
    }
    catch(e){
      print(e);
    }
  }
  static Future<int> insert(Task? task)async{
    print('insert function called');
    return await _db?.insert(_tableName, task!.toJson())??1;
  }

  static Future<List<Map<String, dynamic>>> query() async{
    print("query function called");
    return await _db!.query(_tableName);
  }

  static Future<int> updateTask(Task task) async {
    print("updateEvent function called");
    return await _db!.update(
      _tableName,
      task.toJson(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  static delete(Task task)async{
   return await _db!.delete(_tableName, where: 'id=?', whereArgs: [task.id]);
  }

  static update(int id)async{
   return await _db!.rawUpdate('''
      UPDATE tasks
      SET isCompleted = ?
      WHERE id = ?
    ''', [1, id]);
  }

  static Future<List<Map<String, dynamic>>> fetchAllTasks() async {
    final db = await _db;
    if (db == null) return [];

    return await db.query(_tableName); // Fetch all rows
  }


}