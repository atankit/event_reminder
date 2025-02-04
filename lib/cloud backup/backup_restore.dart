import 'dart:io';
import 'package:event_manager/controllers/task_controller.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class BackupRestore {
  static Future<void> backupToLocal() async {
    try {
      String dbPath = await getDatabasesPath() + 'tasks.db';
      File dbFile = File(dbPath);

      Directory? externalDir = await getExternalStorageDirectory();
      String backupPath = '${externalDir!.path}/tasks_backup.db';

      await dbFile.copy(backupPath);
      print("Backup saved at: $backupPath");
    } catch (e) {
      print("Local backup failed: $e");
    }
  }
  static Future<void> restoreFromLocal() async {
    try {
      Directory? externalDir = await getExternalStorageDirectory();
      String backupPath = '${externalDir!.path}/tasks_backup.db';
      File backupFile = File(backupPath);

      if (!backupFile.existsSync()) {
        print("Backup file not found!");
        return;
      }

      String dbPath = await getDatabasesPath() + 'tasks.db';
      await backupFile.copy(dbPath);

      print("Database restored from local backup!");
      // Refresh task list after restore
      Get.find<TaskController>().getTasks();

    } catch (e) {
      print("Local restore failed: $e");
    }
  }
}
