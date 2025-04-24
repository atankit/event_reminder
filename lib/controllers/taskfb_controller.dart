import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_manager/models/task.dart';
import 'package:event_manager/db/fb_db_helper.dart';

class TaskFbController extends GetxController {
  var taskList = <Task>[].obs;

  @override
  void onReady() {
    super.onReady();
    getTasks();
  }

  ///  Add a task to Firebase
  Future<void> addTask({Task? task}) async {
    if (task != null) {
      await FBdbHelper.addTask(task);
      getTasks();
    }
  }

  ///  Fetch all tasks from Firebase
  void getTasks() async {
    taskList.value = await FBdbHelper.getTasks();
  }

  ///  Delete a task from Firebase
  Future<void> delete(Task task) async {
    if (task.id != null) {
      await FBdbHelper.deleteTask(task.id!);
      getTasks();
    }
  }

  /// Mark a task as completed
  Future<void> markTaskCompleted(String id) async {
    await FirebaseFirestore.instance.collection('tasks').doc(id).update({
      'isCompleted': 1,
    });
    getTasks();
  }

  /// Update a task in Firebase
  Future<void> updateEvents(Task updatedTask) async {
    try {
      if (updatedTask.id != null) {
        await FBdbHelper.updateTaskInFirebase(updatedTask);
        getTasks();
        print("Task updated successfully");
      }
    } catch (e) {
      print("Error updating task: $e");
    }
  }
}
