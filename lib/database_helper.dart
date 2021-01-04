import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:taskmanaging/model.dart';

class DataBaseHelper{

  DataBaseHelper._instance();
  static final DataBaseHelper instance =DataBaseHelper._instance();

  static final _dbName= 'myDatabase.db';
  static final _dbVersion= 1;
  //table column
  static final tableName= 'detailsTable';
  static final columnId='id';
  static final columnDetails='details';
  static final columnPriority='priority';
  static final columnDate='date';
  static final columnStatus='status';

  //create the database object and its getter
  Database _db;
  Future<Database> get database async{

    if(_db == null) {
      _db =await initDb();
    }

    return _db;
  }
  Future<Database> initDb() async{
    Directory directory = await getApplicationDocumentsDirectory();
   String path= join(directory.path,_dbName);
  return await openDatabase(path,version: _dbVersion,onCreate: _createDb);
  }

  void _createDb(Database db,int version) async{
  await  db.execute(
        """
        CREATE TABLE $tableName(
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnDetails TEXT ,
        $columnPriority TEXT,
        $columnDate TEXT,
        $columnStatus INTEGER NOT NULL);
        
        """
    );
  }

  //query
  Future<List<Map<String,dynamic>>> getTaskMapList() async{
    Database db=await instance.database;
    final List<Map<String,dynamic>> result= await db.query(tableName,
        where: '$columnPriority= ? AND $columnStatus= ? ',
        whereArgs: ['today', 0]
    );
    return result;
  }
  Future<List<Task>> getTaskList() async{
    final List<Map<String, dynamic>> taskMaplist= await getTaskMapList();
    final List<Task> taskList=[];
    taskMaplist.forEach((taskMap) {
      taskList.add(Task.fromMap(taskMap));
    });
    return taskList;
  }



//insert
Future<int> insert(Task task) async{
    Database db=await this.database;
    var result=await db.insert(tableName, task.toMap());
    return result;
}

//update
Future<int> update(Task task)async{
  Database db=await instance.database;
    final int result=await db.update(tableName, task.toMap(),
    where: '$columnId= ?',
      whereArgs: [task.id],
    );
    return result;
}
  Future<int> delete(int id) async{
    Database db=await instance.database;
    int result = await db.rawDelete('DELETE FROM $tableName WHERE $columnId = $id');
   /* final int result=await db.delete(_tableName,
        where: '$columnId= ?',
        whereArgs:[id],
    );*/
   return result;
  }

  // Get number of Note objects in database
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $tableName');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

//double
  Future<List<Map<String,dynamic>>> getPlanned() async{
    Database db=await instance.database;
    final List<Map<String,dynamic>> result= await db.query(tableName,
        where: '$columnPriority= ?AND $columnStatus= ? ',
        whereArgs: ['week plan', 0]

    );
    return result;
  }
  Future<List<Task>> getPlannedTwo() async{
    final List<Map<String, dynamic>> taskMaplist= await getPlanned();
    final List<Task> taskList=[];
    taskMaplist.forEach((taskMap) {
      taskList.add(Task.fromMap(taskMap));
    });
    return taskList;
  }
  //uudate the completed work
  Future<int> updateStatus(Task task)async{
    Database db=await instance.database;
    final int result=await db.rawUpdate(
        '''UPDATE $tableName SET $columnStatus=? WHERE $columnId= ?''',
        [1,task.id]

    );
    return result;
  }

  //get the competed list
  Future<List<Map<String,dynamic>>> getCompletedTask() async{
    Database db=await instance.database;
    final List<Map<String,dynamic>> result= await db.query(tableName,
        where: '$columnStatus= ?',
        whereArgs: [1]
    );
    return result;
  }
  Future<List<Task>> getCompleted() async{
    final List<Map<String, dynamic>> taskMaplist= await getCompletedTask();
    final List<Task> taskList=[];
    taskMaplist.forEach((taskMap) {
      taskList.add(Task.fromMap(taskMap));
    });
    return taskList;
  }

}