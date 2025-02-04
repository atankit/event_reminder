import 'package:event_manager/controllers/task_controller.dart';
import 'package:event_manager/db/db_helper.dart';
import 'package:event_manager/pin/app_lock_service.dart';
import 'package:event_manager/pin/pin_screen.dart';
import 'package:event_manager/services/notification_services.dart';
import 'package:event_manager/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:event_manager/services/theme_services.dart';
import 'package:event_manager/SignIn/login_screen.dart';
import 'package:timezone/data/latest_all.dart' as tz;


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp();
  await DBHelper.initDb();
  tz.initializeTimeZones();
  await NotifyHelper.initNotification();
  Get.put(TaskController());
  bool isPinSet = await AppLockService.isPinSet();

  runApp(MyApp(isPinSet: isPinSet));
}

class MyApp extends StatelessWidget {
  final bool isPinSet;

  const MyApp({Key? key, required this.isPinSet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Event Manager',
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeService().theme,
      home: isPinSet ? PinEntryScreen() : LoginScreen(),
    );
  }
}
