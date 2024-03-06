import 'package:agenda/screens/theme.dart';
import 'package:agenda/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  DateTime _selectedDate = DateTime.now();
  String _endTime = "9:30";
  String _startTime = DateFormat("hh:mm" , "pt_BR").format(DateTime.now()).toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Agendar",
                style: headingStyle,
              ),
              const MyInputField(title: 'Titulo', hint: 'Entre com o titulo aqui'),
              const MyInputField(title: 'Nota', hint: 'Entre com a nota aqui'),
              MyInputField(
                title: 'Data',
                hint: DateFormat.yMd('pt_BR').format(_selectedDate),
                widget: IconButton(
                  onPressed: () {
                    _getDateFromUser();
                  },
                  icon: const Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.grey,
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: MyInputField(
                      title: "Hora inicial",
                      hint: _startTime,
                      widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(isStartTime: true);
                        },
                        icon: const Icon(Icons.access_time, color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: MyInputField(
                      title: "Término",
                      hint: _endTime,
                      widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(isStartTime: false);
                        },
                        icon: const Icon(Icons.access_time, color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _appBar(BuildContext context) {
    return AppBar(
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Icon(
          Icons.arrow_back_ios,
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

  _getDateFromUser() async {
    DateTime? pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime
          .now()
          .year - 2),
      lastDate: DateTime(DateTime
          .now()
          .year + 2),
    );
    if (pickerDate != null) {
      setState(() {
        _selectedDate = pickerDate;
        debugPrint(_selectedDate.toString());
      });
    } else {}
  }

  _getTimeFromUser({required bool isStartTime}) async {
    var pickedTime = _showTimePicker();
    String formatedTime = pickedTime.format(context);
    if (pickedTime == null) {
      debugPrint("Cancelar");
    } else if (isStartTime == true) {
      _startTime = formatedTime;
    } else if (isStartTime == false) {
      _endTime = formatedTime;
    }
  }

  _showTimePicker() {
    return showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.input,
      initialTime: TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute)
    );
  }
}
