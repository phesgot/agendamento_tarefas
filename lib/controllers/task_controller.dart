import 'package:agenda/db/db_helper.dart';
import 'package:get/get.dart';

import '../models/agendamento.dart';

class TaskController extends GetxController{

  @override
  void onReady(){
    getTasks();
    super.onReady();
  }

  var taskList = <Task>[].obs;

  Future<int> addTask({Task? task}) async{
    return await DBHelper.insert(task);
  }

  void getTasks() async {
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
  }

  void delete(Task task){
   DBHelper.delete(task);
  }
}