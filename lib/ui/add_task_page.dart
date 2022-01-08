import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app_getx/controller/task_controller.dart';
import 'package:todo_app_getx/model/task.dart';
import 'package:todo_app_getx/ui/theme.dart';
import 'package:todo_app_getx/widgets/button.dart';
import 'package:todo_app_getx/widgets/input_field.dart';
import 'package:todo_app_getx/widgets/input_note_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());

  final TextEditingController titleController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  String _endTime = "11.30 Pm";
  int _selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];
  String _selectedRepeat = 'None';
  List<String> repeatList = ['Daily', 'Weekly', 'Monthly', 'Yearly'];
  int isCompleted = 0;
  int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: context.theme.backgroundColor,
        // Custom AppBar
        appBar: _appBar(context),
        body: Container(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Heading Text
              Text(
                'Add Task',
                style: headingStyle,
              ),
              // Task Title
              MyInputField(
                  title: 'Title',
                  hint: 'Enter your task title',
                  textController: titleController),

              // Task Note
              MyInputNoteField(
                  title: 'Note',
                  hint: 'Enter your note',
                  textController: noteController),

              // Date Picker TextField
              MyInputField(
                title: 'Date',
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  icon: Icon(Icons.calendar_today_outlined),
                  color: Colors.grey,
                  onPressed: () {
                    _getDateFromUser();
                  },
                ),
              ),

              // Time Picker TextField
              Row(
                children: [
                  Expanded(
                    child: MyInputField(
                      title: 'Start Time',
                      hint: _startTime,
                      widget: IconButton(
                        icon: Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          _getTimeFromUser(isStartTime: true);
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: MyInputField(
                      title: 'End Time',
                      hint: _endTime,
                      widget: IconButton(
                        icon: Icon(
                          Icons.access_time_rounded,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          _getTimeFromUser(isStartTime: false);
                        },
                      ),
                    ),
                  ),
                ],
              ),

              // Reminder TextField
              MyInputField(
                title: 'Remind',
                hint: '$_selectedRemind minutes early',

                // don't understand this part
                widget: DropdownButton(
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                    iconSize: 32,
                    elevation: 4,
                    style: subtitleStyle,
                    underline: Container(height: 0),
                    // don't understand this part
                    items:
                        remindList.map<DropdownMenuItem<String>>((int value) {
                      return DropdownMenuItem<String>(
                          value: value.toString(),
                          child: Text(value.toString()));
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRemind = int.parse(newValue!);
                      });
                    }),
              ),
              // Repeat TextField
              MyInputField(
                title: 'Repeat', hint: '$_selectedRepeat',
                // don't understand this part
                widget: DropdownButton(
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                    iconSize: 32,
                    elevation: 4,
                    style: subtitleStyle,
                    underline: Container(height: 0),
                    // don't understand this part
                    items: repeatList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,
                              style: TextStyle(color: Colors.grey)));
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRepeat = newValue!;
                      });
                    }),
              ),
              SizedBox(height: 18),

              // Color Picker TextField
              Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _getColorPallete(),
                    MyButton(label: 'Create Task', onTap: () => vaildateDate()),
                  ],
                ),
              ),
            ]),
          ),
        ));
  }

  // Custom AppBar
  _appBar(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
          child: Icon(
            Icons.arrow_back_ios,
            color: Get.isDarkMode ? Colors.white : Colors.black,
            size: 20,
          ),
          onTap: () {
            Get.back();
          }),
      actions: [
        CircleAvatar(
          radius: 20.0,
          backgroundImage: AssetImage("images/person.png"),
          backgroundColor: Colors.white,
        ),
        SizedBox(
          width: 20,
        )
      ],
      title: Text('Task App'),
    );
  }

// Pick Date from User
  _getDateFromUser() async {
    DateTime? dateTimepicker = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015),
        lastDate: DateTime(2125));

    if (dateTimepicker != null) {
      setState(() {
        _selectedDate = dateTimepicker;
      });
    }
  }

// Pick Time from User
  _getTimeFromUser({required bool isStartTime}) async {
    var timePicker = await showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.input,
      initialTime: TimeOfDay(
        // => 10:30 AM
        hour: int.parse(_startTime.split(":")[0]),
        minute: int.parse(_startTime.split(":")[1].split(" ")[0]),
      ),
    );
    String _fomatedTime = timePicker!.format(context);

    if (_fomatedTime == null) {
    } else if (isStartTime == true) {
      setState(() {
        _startTime = _fomatedTime;
      });
    } else if (isStartTime == false) {
      setState(() {
        _endTime = _fomatedTime;
      });
    }
  }

// Pick Color Section from User
  _getColorPallete() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Color", style: titleStyle),
        SizedBox(height: 10),
        Wrap(
          children: List<Widget>.generate(3, (int index) {
            return GestureDetector(
              onTap: () => {
                setState(() {
                  _selectedColor = index;
                })
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: index == 0
                      ? primaryClr
                      : index == 1
                          ? pinkClr
                          : yellowClr,
                  child: _selectedColor == index
                      ? Icon(Icons.done, color: Colors.white, size: 16)
                      : Container(),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

// Validation of input Data
  vaildateDate() {
    if (titleController.text.isNotEmpty && noteController.text.isNotEmpty) {
      // Call method to pass data to controller
      _addTaskToDb();
      Get.back();
    } else if (titleController.text.isEmpty) {
      Get.snackbar("Required", "Task title is required!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: Colors.pink,
          icon: Icon(Icons.warning_amber_rounded),
          margin: EdgeInsets.only(bottom: 16, left: 16, right: 16));
    } else {
      Get.snackbar("Required", "Task note is required!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: Colors.pink,
          icon: Icon(Icons.warning_amber_rounded),
          margin: EdgeInsets.only(bottom: 16, left: 16, right: 16));
    }
  }

// Passing data to Controller
  _addTaskToDb() async {
    int? value = await _taskController.addTask(
      Task(
          title: titleController.text,
          note: noteController.text,
          date: DateFormat.yMd().format(_selectedDate),
          startTime: _startTime,
          endTime: _endTime,
          reminderTime: _selectedRemind,
          repeatTime: _selectedRepeat,
          color: _selectedColor,
          isCompleted: 0),
    );
    print('Start Time: $_startTime');
    print('End Time: $_endTime');
    print('inserted id: $value');
  }
}
