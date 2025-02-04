
import 'package:event_manager/db/db_helper.dart';
import 'package:event_manager/models/task.dart';
import 'package:get/get.dart';

class TaskController extends GetxController{

  @override
  void onReady(){
    super.onReady();
  }
var taskList = <Task>[].obs;

 Future<int> addTask({Task? task})async{
    return await DBHelper.insert(task);

 }

 //get all the data from table
void getTasks() async{
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data)=> new Task.fromJson(data)).toList());
}

// deleting
void delete(Task task){
  DBHelper.delete(task);
  getTasks();
  }

  //update
  void markTaskCompleted(int id) async{
    await DBHelper.update(id);
    getTasks();
  }



  Future<void> updateEvents(Task updatedTask) async {
    try {
      // Assuming you are using a database helper method
      int result = await DBHelper.updateTask(updatedTask);
      if (result != 0) {
        getTasks();
        print('Task updated successfully');
      } else {
        print('Update failed');
      }
    } catch (e) {
      print("Error updating task: $e");
    }
  }


}
