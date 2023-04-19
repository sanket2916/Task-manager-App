import 'package:flutter/material.dart';
import 'package:tasks/controller/TaskController.dart';
import 'package:tasks/screens/AddTaskScreen.dart';
import 'package:tasks/screens/ListTypeScreen.dart';
import 'package:get/get.dart';
import 'package:tasks/screens/LoginPage.dart';
import 'package:tasks/screens/ProfileScreen.dart';
import 'package:tasks/screens/SignupPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  // TaskController taskController = Get.put(TaskController());
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: LoginPage()
    );
  }
}
