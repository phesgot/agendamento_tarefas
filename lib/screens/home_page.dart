import 'package:agenda/controllers/task_controller.dart';
import 'package:agenda/screens/theme.dart';
import 'package:agenda/services/notification_services.dart';
import 'package:agenda/services/theme_services.dart';
import 'package:agenda/widgets/add_task_bar.dart';
import 'package:agenda/widgets/button.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../widgets/task_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  DateTime selectedDate = DateTime.now();
  final _taskController = Get.put(TaskController());
  late NotifyHelper notifyHelper;

  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          const SizedBox(height: 10),
          _showTasks(),
        ],
      ),
    );
  }

  _showTasks(){
    return Expanded(
        child: Obx((){
          return ListView.builder(
            itemCount: _taskController.taskList.length,
              itemBuilder: (_, index){
              print(_taskController.taskList.length);
                return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                    child: FadeInAnimation(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: (){
                              print("Clicouu");
                            },
                            child: TaskTile(_taskController.taskList[index].title.toString()),
                          )
                        ],
                      ),
                    ),
                  ),
                );
          });
        }),
    );
  }

  // Container(
  // width: 100,
  // height: 50,
  // color: Colors.green,
  // margin: const EdgeInsets.only(bottom: 10),
  // child: Text(
  // _taskController.taskList[index].title.toString()
  // ),
  // );
  //

  _addDateBar(){
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20),
      child: DatePicker(
        locale: 'pt-BR',
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        dateTextStyle: GoogleFonts.lato(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey
        ),
        dayTextStyle: GoogleFonts.lato(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey
        ),
        monthTextStyle: GoogleFonts.lato(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey
        ),
        onDateChange: (date){
          selectedDate = date;
        },
      ),
    );
  }
  _addTaskBar(){
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd('pt_BR').format(DateTime.now()),
                style: subHeadingStyle,
              ),
              Text("Hoje", style: headingStyle,),
            ],
          ),
          MyButton(label: "Agendar", onTap: () async{
          await Get.to(const AddTaskPage());
          _taskController.getTasks();
          }),
        ],
      ),
    );
  }
  _appBar() {
    return AppBar(
      leading: GestureDetector(
        onTap: () {
          ThemeServices().switchTheme();
          notifyHelper.displayNotification(
              title: "Theme Changed", body: Get.isDarkMode ? "Activated Light Theme" : "Activated Dark Theme");
          notifyHelper.scheduledNotification();
        },
        child: Icon(
          Get.isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round,
          color: Get.isDarkMode ? Colors.white : Colors.black,
          size: 20,
        ),
      ),
      actions: const [
        CircleAvatar(
          backgroundImage: AssetImage("images/profile.png"),
        ),
        SizedBox(width: 20),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('notifyHelper', notifyHelper));
  }
}
