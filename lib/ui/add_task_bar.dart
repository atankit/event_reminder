
import 'dart:io';
import 'package:event_manager/controllers/task_controller.dart';
import 'package:event_manager/models/task.dart';
import 'package:event_manager/services/notification_services.dart';
import 'package:event_manager/ui/theme.dart';
import 'package:event_manager/ui/widgets/button.dart';
import 'package:event_manager/ui/widgets/input_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddTaskPage extends StatefulWidget {
  final Task? task;
  const AddTaskPage({super.key, this.task});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController()); //find



  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String _endTime = "9:30 PM";

  String _selectedCategory = "Work";
  final List<String> categoryList = ["Work", "Personal", "Birthday", "Meeting"];

  int _selectedRemind = 5;
  final List<int> remindList = [5, 10, 15, 20];

  String _selectedRepeat = "None";
  final List<String> repeatList = ["None", "Daily", "Weekly", "Monthly"];

  File? _selectedImage;
  File? _selectedVideo;
  File? _selectedFile;

  int _selectedColor = 0;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _loadTaskData(widget.task!);
    }
  }


  void _loadTaskData(Task task) {
    _titleController.text = task.title!;
    _descController.text = task.description!;
    _locationController.text = task.location!;
    _selectedDate = DateFormat.yMd().parse(task.date!);
    _startTime = task.startTime!;
    _endTime = task.endTime!;
    _selectedCategory = task.category!;
    _selectedRemind = task.remind!;
    _selectedRepeat = task.repeat!;
    _selectedColor = task.color!;

    if (task.photoPath != "No Image Found!") {
      _selectedImage = File(task.photoPath!);
    }
    if (task.videoPath != "No Video Found!") {
      _selectedVideo = File(task.videoPath!);
    }
    if (task.filePath != "No File Found!") {
      _selectedFile = File(task.filePath!);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context, task: widget.task),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Text("Add Task", style: headingStyle),
              MyInputField(
                title: "Title",
                hint: "Enter your title",
                controller: _titleController,
              ),
              MyInputField(
                title: "Description",
                hint: "Enter your description",
                controller: _descController,
              ),
              // MyInputField(
              //   title: "Date",
              //   hint: DateFormat.yMd().format(_selectedDate),
              //   widget: IconButton(
              //     icon: const Icon(Icons.calendar_today_outlined, color: Colors.grey),
              //     onPressed: _getDateFromUser,
              //   ),
              // ),
              MyInputField(
                title: "Date",
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  icon: const Icon(Icons.calendar_today_outlined, color: Colors.grey),
                  onPressed: _getDateFromUser,
                ),
                onTap: () => _getDateFromUser(), // Add this line
              ),

              Row(
                children: [
                  Expanded(
                    child: MyInputField(
                      title: "Start Time",
                      hint: _startTime,
                      widget: IconButton(
                        icon: const Icon(Icons.access_time_rounded, color: Colors.grey),
                        onPressed: () => _getTimeFromUser(isStartTime: true),
                      ),
                      onTap: () => _getTimeFromUser(isStartTime: true),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: MyInputField(
                      title: "End Time",
                      hint: _endTime,
                      widget: IconButton(
                        icon: const Icon(Icons.access_time_rounded, color: Colors.grey),
                        onPressed: () => _getTimeFromUser(isStartTime: false),
                      ),
                      onTap: () => _getTimeFromUser(isStartTime: false),
                    ),
                  ),
                ],
              ),
              MyInputField(
                title: "Location",
                hint: "Enter your location",
                controller: _locationController,
              ),
              MyInputField(
                title: "Category",
                hint: _selectedCategory,
                widget:
                // DropdownButton(
                //   icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                //   iconSize: 32,
                //   elevation: 4,
                //   style: subTitleStyle,
                //   underline: Container(height: 0),
                //   items: categoryList.map((value) {
                //     return DropdownMenuItem(
                //       value: value,
                //       // child: Text(value, style: const TextStyle(color: Colors.black)),
                //       child: Text(value, style: TextStyle(color: Get.isDarkMode? Colors.white:Colors.black)),
                //     );
                //   }).toList(),
                //   onChanged: (newValue) {
                //     setState(() {
                //       _selectedCategory = newValue!;
                //     });
                //   },
                // ),
                DropdownButton(
                  padding: EdgeInsets.only(right: 20) ,
                  dropdownColor: Get.isDarkMode ? Colors.grey[900] : Colors.white, // Dark mode support
                  icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey), // Stylish blue icon
                  iconSize: 32,
                  elevation: 6,
                  style: subTitleStyle,
                  underline: SizedBox(), // Removes default underline
                  borderRadius: BorderRadius.circular(12), // Smooth rounded corners
                  items: categoryList.map((value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.3), // Light blue glow
                              blurRadius: 6,
                              offset: Offset(2, 3),
                            ),
                          ],
                        ),
                        child: Text(
                          value,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Get.isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedCategory = newValue!;
                    });
                  },
                ),

              ),
              MyInputField(
                title: "Remind",
                hint: "$_selectedRemind minutes early",
                widget:
                // DropdownButton(
                //   padding: EdgeInsets.only(right: 20),
                //   // dropdownColor: Colors.blueAccent,
                //   icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                //   iconSize: 32,
                //   elevation: 6,
                //   style: subTitleStyle,
                //   underline: Container(height: 0),
                //   items: remindList.map((value) {
                //     return DropdownMenuItem(
                //       value: value,
                //       child: Text(value.toString()),
                //     );
                //   }).toList(),
                //   onChanged: (newValue) {
                //     setState(() {
                //       _selectedRemind = int.parse(newValue.toString());
                //     });
                //   },
                // ),
                DropdownButton(
                  padding: EdgeInsets.only(right: 20) ,
                  dropdownColor: Get.isDarkMode ? Colors.grey[900] : Colors.white, // Dark mode support
                  icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey), // Stylish blue icon
                  iconSize: 32,
                  elevation: 6,
                  style: subTitleStyle,
                  underline: SizedBox(), // Removes default underline
                  borderRadius: BorderRadius.circular(12), // Smooth rounded corners
                  items: remindList.map((value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.3), // Light blue glow
                              blurRadius: 6,
                              offset: Offset(2, 3),
                            ),
                          ],
                        ),
                        child: Text(
                          value.toString(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Get.isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedRemind = int.parse(newValue.toString());
                    });
                  },
                ),


              ),
              MyInputField(
                title: "Repeat",
                hint: _selectedRepeat,
                widget:
                // DropdownButton(
                //   icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                //   iconSize: 32,
                //   elevation: 4,
                //   style: subTitleStyle,
                //   underline: Container(height: 0),
                //   items: repeatList.map((value) {
                //     return DropdownMenuItem(
                //       value: value,
                //       child: Text(value, style: TextStyle(color: Get.isDarkMode? Colors.white:Colors.black)),
                //     );
                //   }).toList(),
                //   onChanged: (newValue) {
                //     setState(() {
                //       _selectedRepeat = newValue!;
                //     });
                //   },
                // ),

                DropdownButton(
                  padding: EdgeInsets.only(right: 20) ,
                  dropdownColor: Get.isDarkMode ? Colors.grey[900] : Colors.white, // Dark mode support
                  icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey), // Stylish blue icon
                  iconSize: 32,
                  elevation: 6,
                  style: subTitleStyle,
                  underline: SizedBox(), // Removes default underline
                  borderRadius: BorderRadius.circular(12), // Smooth rounded corners
                  items: repeatList.map((value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.3), // Light blue glow
                              blurRadius: 6,
                              offset: Offset(2, 3),
                            ),
                          ],
                        ),
                        child: Text(
                          value,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Get.isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedRepeat = newValue!;
                    });
                  },
                ),

              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text("Attach Media", style: titleStyle),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _mediaButton("Image", Icons.image, Colors.blueAccent, _pickImage),
                  _mediaButton("Video", Icons.videocam, Colors.black, _pickVideo),
                  _mediaButton("File", Icons.attach_file, Colors.red, _pickFile),
                ],
              ),
              const SizedBox(height: 10),
              if (_selectedImage != null) _mediaPreview("Image", _selectedImage!.path),
              if (_selectedVideo != null) _mediaPreview("Video", _selectedVideo!.path),
              if (_selectedFile != null) _mediaPreview("File", _selectedFile!.path),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _colorPalette(),
                  // MyButton(label: widget.task == null ?  "Create Task" : "Update Task", onTap: _validateData),
                ],
              ),
              const SizedBox(height: 16),
               MyButton(label: widget.task == null ?  "Create Task" : "Update Task", onTap: _validateData),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context, {required task}) {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.primaryColor,
      leading: GestureDetector(
        onTap: Get.back,
        child: Icon(
          Icons.arrow_back_outlined,
          size: 20,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      title: Text(
        task == null ? "Add Task" : "Update Task",
        style: headingStyle,
      ),
    );
  }

  Future<void> _getDateFromUser() async {
    DateTime? pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2025),
      lastDate: DateTime(2028),
    );
    if (pickerDate != null) {
      setState(() {
        _selectedDate = pickerDate;
      });
    }
  }
  

  Future<void> _getTimeFromUser({required bool isStartTime}) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.input,
    );

    if (pickedTime != null) {
      String formattedTime = pickedTime.format(context);

      setState(() {
        if (isStartTime) {
          _startTime = formattedTime;
        } else {
          _endTime = formattedTime;
        }
      });
    }
  }




  Widget _colorPalette() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Color", style: titleStyle),
        const SizedBox(height: 8),
        Wrap(
          children: List.generate(3, (index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = index;
                });
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
                      ? const Icon(Icons.done, color: Colors.white, size: 16)
                      : Container(),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Future<void> _validateData() async {
    if (_titleController.text.isNotEmpty && _descController.text.isNotEmpty) {
      if (widget.task != null) {
        await _updateTaskInDb();
      } else {
        await _addTaskToDb();
      }
      Get.back();
    } else {
      Get.snackbar(
        "Required",
        "All fields are required!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: pinkClr,
        icon: const Icon(Icons.warning_amber_rounded, color: Colors.red),
      );
    }
  }

  Future<void> _addTaskToDb() async {
    Task task = Task(
      title: _titleController.text,
      description: _descController.text,
      date: DateFormat.yMd().format(_selectedDate),
      startTime: _startTime,
      endTime: _endTime,
      location: _locationController.text,
      category: _selectedCategory,
      remind: _selectedRemind,
      repeat: _selectedRepeat,
      color: _selectedColor,
      photoPath: _selectedImage?.path ?? "No Image Found!",
      videoPath: _selectedVideo?.path ?? "No Video Found!",
      filePath: _selectedFile?.path ?? "No File Found!",
      isCompleted: 0,
    );
    int value = await _taskController.addTask(task: task);
    print("Task added with ID: $value");
  }


  Future<void> _updateTaskInDb() async {
    Task updatedTask = Task(
      id: widget.task!.id, // Use the existing task ID
      title: _titleController.text,
      description: _descController.text,
      date: DateFormat.yMd().format(_selectedDate),
      startTime: _startTime,
      endTime: _endTime,
      location: _locationController.text,
      category: _selectedCategory,
      remind: _selectedRemind,
      repeat: _selectedRepeat,
      color: _selectedColor,
      photoPath: _selectedImage?.path ?? "No Image Found!",
      videoPath: _selectedVideo?.path ?? "No Video Found!",
      filePath: _selectedFile?.path ?? "No File Found!",
      isCompleted: widget.task!.isCompleted,
    );
    await _taskController.updateEvents(updatedTask);
    print("Task updated: ${updatedTask.title}");
    print('Updating Task with ID: ${widget.task!.id}');

  }


  Widget _mediaButton(String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey.shade200,
            child: Icon(icon, size: 30, color: color),
          ),
          const SizedBox(height: 5),
          Text(label, style: subTitleStyle),
        ],
      ),
    );
  }

  Widget _mediaPreview(String type, String path) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$type Preview:", style: subTitleStyle),
        const SizedBox(height: 10),
        type == "Image"
            ? Image.file(File(path), width: double.infinity, height: 200)
            : Text("$type: $path", style: subTitleStyle),
      ],
    );
  }

  Future<void> _pickImage() async {
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  Future<void> _pickVideo() async {
    final XFile? pickedVideo = await _picker.pickVideo(source: ImageSource.gallery);
    if (pickedVideo != null) {
      setState(() {
        _selectedVideo = File(pickedVideo.path);
      });
    }
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }
}
