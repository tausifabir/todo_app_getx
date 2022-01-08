import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app_getx/Services/notification_services.dart';
import 'package:todo_app_getx/Services/theme_services.dart';
import 'package:intl/intl.dart';
import 'package:todo_app_getx/controller/task_controller.dart';
import 'package:todo_app_getx/model/task.dart';
import 'package:todo_app_getx/ui/add_task_page.dart';
import 'package:todo_app_getx/ui/theme.dart';
import 'package:todo_app_getx/widgets/TaskTitle.dart';
import 'package:todo_app_getx/widgets/button.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _taskController = Get.put(TaskController());
  var notifyHelper;
  DateTime _selectedDate = DateTime.now();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
    _taskController.getTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: context.theme.backgroundColor,
        appBar: _appBar(),
        body: Column(
          children: [
            // customr appBar
            _addTaskBar(),
            // shows Heading Current date
            _addDateBar(),
            // show task lists
            SizedBox(
              height: 10,
            ),
            _showTaskLists(),
          ],
        ));
  }

  // customr appBar
  _appBar() {
    return AppBar(
      elevation: 0.0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        child: Icon(
          Get.isDarkMode
              ? Icons.wb_sunny_outlined
              : Icons.nightlight_round_rounded,
          color: Get.isDarkMode ? Colors.white : Colors.black,
          size: 20,
        ),
        onTap: () {
          ThemeService().switchThemeMode();
          notifyHelper.displayNotification(
              title: "Theme Changed",
              body: Get.isDarkMode
                  ? 'Actived Default Mode'
                  : 'Actived Dark Mode');

          //notifyHelper.scheduledNotification();
        },
      ),
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
      title: Text('Task App',
          style:
              TextStyle(color: Get.isDarkMode ? Colors.white : Colors.black)),
    );
  }

  // task button to add tasks into list
  _addTaskBar() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Text(
                DateFormat.yMMMd().format(DateTime.now()),
                style: subHeadings,
              ),
              Text('Today', style: headingStyle),
            ]),
          ),
          MyButton(
              label: '+ Add Task',
              onTap: () async {
                await Get.to(() => AddTaskPage());
                _taskController.getTasks();
              }),
        ],
      ),
    );
  }

  // shows Heading Current date
  _addDateBar() {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 20),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 70,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        dateTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        onDateChange: (date) {
          setState(() {
            _selectedDate = date;
          });
        },
      ),
    );
  }

  // shows all tasklists
  _showTaskLists() {
    return Expanded(
      child: Obx(() {
        return ListView.builder(
            itemCount: _taskController.taskList.length,
            itemBuilder: (_, index) {
              Task task = _taskController.taskList[index];

              if (task.repeatTime == 'Daily') {
                // convert timeobject into time
                DateTime scheduleTime =
                    DateFormat.jm().parse(task.startTime.toString());
                // converted new time into Hours & minutes
                var myTime = DateFormat('HH:mm').format(scheduleTime);
                notifyHelper.scheduledNotification(
                  int.parse(myTime.toString().split(":")[0]),
                  int.parse(myTime.toString().split(":")[1]),
                  task,
                );

                return AnimationConfiguration.staggeredList(
                  position: index,
                  child: GestureDetector(
                    onTap: () {
                      _showBottomSheet(context, task);
                    },
                    child: SlideAnimation(
                      child: FadeInAnimation(
                        child: Row(
                          children: [
                            TaskTile(task),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }

              if (task.date == DateFormat.yMd().format(_selectedDate)) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  child: GestureDetector(
                    onTap: () {
                      _showBottomSheet(context, task);
                    },
                    child: SlideAnimation(
                      child: FadeInAnimation(
                        child: Row(
                          children: [
                            TaskTile(task),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return Container();
              }

              /*return Dismissible(
              key: Key(_taskController.taskList[index].toString()),
              onDismissed: (direction) =>
                  _taskController.delete(_taskController.taskList[index]),
              direction: DismissDirection.startToEnd,
              child: Container(
                width: 100,
                height: 50,
                margin: EdgeInsets.only(bottom: 10, right: 10, left: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.pinkAccent,
                ),
                child: ListTile(
                  title: Text(_taskController.taskList[index].note.toString()),
                ),
              ),
            );*/
            });
      }),
    );
  }

  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.only(top: 4),
        height: task.isCompleted == 1
            ? MediaQuery.of(context).size.height * 0.24
            : MediaQuery.of(context).size.height * 0.32,
        color: Get.isDarkMode ? darkGreyClr : Colors.white,
        child: Column(
          children: [
            Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
              ),
            ),
            Spacer(),
            task.isCompleted == 1
                ? Container()
                : _bottomSheetButton(
                    context: context,
                    label: 'Task Completed',
                    onTap: () {
                      // _taskController.markTaskCompleted(task);
                      Get.back();
                    },
                    clr: primaryClr,
                    isClose: false,
                  ),
            SizedBox(height: 8),
            task.isCompleted == 1
                ? Container()
                : _bottomSheetButton(
                    context: context,
                    label: 'Delete Task',
                    onTap: () {
                      _taskController.delete(task);

                      Get.back();
                    },
                    clr: Colors.red[300]!,
                    isClose: false,
                  ),
            SizedBox(height: 20),
            task.isCompleted == 1
                ? Container()
                : _bottomSheetButton(
                    context: context,
                    label: 'Close',
                    onTap: () {
                      Get.back();
                    },
                    clr: Colors.white,
                    isClose: true,
                  ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  _bottomSheetButton({
    required BuildContext context,
    required String label,
    required Function()? onTap,
    required Color clr,
    bool isClose = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,
        child: Center(
            child: Text(label,
                style: isClose
                    ? titleStyle
                    : titleStyle.copyWith(color: Colors.white))),
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            //color: isClose == true ? Colors.red : clr,
            color: isClose == true
                ? Get.isDarkMode
                    ? Colors.grey[600]!
                    : Colors.grey[300]!
                : clr,
          ),
          //color: isClose == true ? Colors.red : clr,
          color: isClose == true ? Colors.transparent : clr,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
