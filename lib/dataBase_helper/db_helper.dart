import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app_getx/model/task.dart' as task;
import 'package:todo_app_getx/model/task.dart';

class DBHelper {
  late Database _database;
  static String taskTable = "taskTable";
  static final String columnId = "id";
  static final String columnTitle = "title";
  static final String columnNote = "note";
  static final String columnIsCompleted = "isCompleted";
  static final String columnDate = "date";
  static final String columnStartTime = "startTime";
  static final String columnEndTime = "endTime";
  static final String columnReminderTime = "reminderTime";
  static final String columnRepeatTime = "repeatTime";
  static final String columnColor = "color";
  static final _taskDBName = "task.db";
  static final _taskDBVersion = 1;

  DBHelper._privateConstructor();
  static final DBHelper instanceExpense = DBHelper._privateConstructor();

  Future<Database> get database async {
    // ignore: unnecessary_null_comparison
    //if (_database != null) return database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    String path = join(documentsDirectory.path, _taskDBName);

    return await openDatabase(path,
        version: _taskDBVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    /*await db.execute('''CREATE TABLE $expenseTbl(
        $columnId INTEGER PRIMARY KEY,
        $columnTittle TEXT NOT NULL,
        $columnAmount REAL NOT NULL,
        $columnDate TEXT NOT NULL,
      )''');*/

    await db.execute("CREATE TABLE  $taskTable ("
        "$columnId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,"
        "$columnTitle TEXT,"
        "$columnNote TEXT,"
        "$columnIsCompleted INTEGER,"
        "$columnDate TEXT,"
        "$columnStartTime TEXT,"
        "$columnEndTime TEXT,"
        "$columnReminderTime INTEGER NOT NULL,"
        "$columnRepeatTime INTEGER NOT NULL,"
        "$columnColor INTEGER NOT NULL"
        ")");
  }

  // insert new expenses
  Future<int> insertIntoExpense(task.Task element) async {
    Database db = await database;
    int id = await db.insert(taskTable, element.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  Future<List<Map<String, dynamic>>> getAllTasks() async {
    Database db = await database;
    return await db.query(taskTable);
  }

  Future<int> deleteTask(Task task) async {
    Database db = await database;
    return await db
        .delete(taskTable, where: '$columnId= ?', whereArgs: [task.id]);
  }

  Future<int> updateTaskComplete(int id) async {
    Database db = await database;
    return await db.rawUpdate('''
    UPDATE tasks
    SET isCompleted = ?
    WHERE id = ?
''', [1, id]);
    //return await db.update(taskTable, row,
    //  where: '$columnId= ?,$columnIsCompleted = ?', whereArgs: [id, 1]);
  }

  Future<int> updateTaskRow(Task task) async {
    Database db = await database;
    return await db.update(taskTable, task.toJson(),
        where: '$columnIsCompleted = ?', whereArgs: [1]);
  }
}
