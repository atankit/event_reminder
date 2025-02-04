import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:event_manager/controllers/task_controller.dart';
import 'package:event_manager/models/task.dart';
import 'package:event_manager/services/notification_services.dart';
import 'package:event_manager/services/theme_services.dart';
import 'package:event_manager/ui/add_task_bar.dart';
import 'package:event_manager/ui/theme.dart';
import 'package:event_manager/ui/widgets/button.dart';
import 'package:event_manager/ui/widgets/popup_menu.dart';
import 'package:event_manager/ui/widgets/task_tile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();
  final _taskController = Get.put(TaskController());

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshTasks();
    NotifyHelper();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(),
        body: Column(
          children: [

            _addTaskBar(),
            _addDateBar(),
            const SizedBox(
              height: 10,
            ),
            _searchBar(),
            _showTasks(),
          ],
        ));
  }



  // Customized appbar
  _appBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: context.theme.primaryColor,
      leading: GestureDetector(
        onTap: () {
          ThemeService().switchTheme();
        },
        child: Icon(
            Get.isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round,
            size: 20,
            color: Get.isDarkMode ? Colors.white : Colors.black),
      ),
      actions: [
        CircleAvatar(
          backgroundImage: AssetImage("images/profile_img.jpg"),
          radius: 20,
        ).popupMenu(context: context),
        const SizedBox(width: 20),
      ],
    );

  }

  _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMd().format(DateTime.now()),
                  style: subHeadingStyle,
                ),
                Text(
                  'Today',
                  style: headingStyle,
                )
              ],
            ),
          ),
          MyButton(
              label: "+ Add Task",
              onTap: () async {
                await Get.to(() => AddTaskPage());
                _taskController.getTasks();
              })
        ],
      ),
    );
  }

  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 5, left: 20),
      child:
      DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        dateTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey)),
        dayTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey)),
        monthTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey)),
        onDateChange: (date) {
          setState(() {
            _selectedDate = date;
          });
        },
      ),
    );
  }

  _searchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value.toLowerCase();
          });
        },
        decoration: InputDecoration(
          hintText: "Search tasks by title, description, or category",
          hintStyle: subTitleStyle,
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          filled: true,
          fillColor: Get.isDarkMode ? darkGreyClr : Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  _showTasks() {
  return Expanded(

    child: Obx(() {

      final filteredTasks = _taskController.taskList.where((task) {
        return task.title!.toLowerCase().contains(_searchQuery) ||
            task.description!.toLowerCase().contains(_searchQuery) ||
            task.category!.toLowerCase().contains(_searchQuery);
      }).toList();

      final tasksToDisplay = _searchQuery.isNotEmpty ? filteredTasks : _taskController.taskList;

      return ListView.builder(
          itemCount: tasksToDisplay.length,
          itemBuilder: (_, index) {
            // print(_taskController.taskList.length);

            Task task = tasksToDisplay[index];
            print(task.toJson());

            if(task.repeat=='Daily'  || task.date == DateFormat.yMd().format(_selectedDate)){

              return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                      child: FadeInAnimation(
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _showBottomSheet(
                                      context,task);
                                },
                                child: TaskTile(task),
                              )
                            ],
                          ))));
            };

            if(task.date==DateFormat.yMd().format(_selectedDate)){
              return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                      child: FadeInAnimation(
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _showBottomSheet(
                                      context,task);
                                },
                                child: TaskTile(task),
                              )
                            ],
                          ))));
            }else{
              return Container();
            }


          });
    }),

  );
}


  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 4),
        height: task.isCompleted == 1
            ? MediaQuery.of(context).size.height * 0.32
            : MediaQuery.of(context).size.height * 0.4,
        width: MediaQuery.of(context).size.width,
        color: Get.isDarkMode
            ? darkGreyClr
            : Colors.white, // Adjust color for dark mode

        child: Column(
          children: [
            Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300]),
            ),
            Spacer(),
            task.isCompleted == 1
                ? Container()
                : _bottomSheetButton(
              label: "Task Completed",
              onTap: () {
                _taskController.markTaskCompleted(task.id!);
                Get.back();
              },
              clr: primaryClr,
              context: context,
            ),
            // update button
            _bottomSheetButton(
              label: "Update Task",
              onTap: (){
                Get.off(() => AddTaskPage(task: task));
              },
              clr: Colors.blue,
              context: context,
            ),
            // Delete button
            _bottomSheetButton(
              label: "Delete Task",
              onTap: () {
                _taskController.delete(task);
                Get.back();
              },
              clr: Colors.red[300]!,
              context: context,
            ),
            const SizedBox(
              height: 20,
            ),
            // Close button
            _bottomSheetButton(
              label: "Close",
              onTap: () {
                Get.back();
              },
              clr: Colors.red[300]!,
              isClose: true,
              context: context,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }


  _bottomSheetButton({
    required String label,
    required Function()? onTap,
    required Color clr,
    bool isClose = false,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          border:
              Border.all(width: 2, color: isClose == true ?Get.isDarkMode? Colors.grey[600]!: Colors.grey[300]! : clr),
          borderRadius: BorderRadius.circular(20),
          color: isClose == true ? Colors.transparent : clr,
        ),
        child: Center(
            child: Text(
                label,
                 style: isClose?titleStyle:titleStyle.copyWith(color: Colors.white),
            ),
        ),
      ),
    );
  }
  void refreshTasks() {
    _taskController.getTasks();
    setState(() {});
  }
}
