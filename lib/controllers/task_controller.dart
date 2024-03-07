import 'package:agenda/db/db_helper.dart';
import 'package:get/get.dart';

import '../models/agendamento.dart';

class TaskController extends GetxController{

  @override
  void onReady(){
    super.onReady();
  }

  Future<int> addTask({Task? task}) async{
    return await DBHelper.insert(task);
  }
}