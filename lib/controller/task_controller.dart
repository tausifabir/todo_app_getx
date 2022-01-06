import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app_getx/dataBase_helper/db_helper.dart';
import 'package:todo_app_getx/model/task.dart';

class TaskController extends GetxController {
  @override
  void onReady() {
    super.onReady();
  }

  var taskList = <Task>[].obs;

  // insert task into database
  Future<int>? addTask(Task task) {
    return DBHelper.instanceExpense.insertIntoExpense(task);
  }

  Future<void> getTasks() async {
    List<Map<String, dynamic>> tasks =
        await DBHelper.instanceExpense.getAllTasks();
    taskList
        .assignAll(tasks.map((element) => new Task.fromJson(element)).toList());
  }

  Future<int>? delete(Task task) async {
    int deleledId = await DBHelper.instanceExpense.deleteTask(task);
    return deleledId;
  }
}
