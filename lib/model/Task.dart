import 'package:get/get.dart';

class Task {
  int? id;
  String name;
  RxBool isDone = false.obs;
  final String category;
  final DateTime dateTime;

  Task({required this.name, required this.category, required this.dateTime, required this.isDone, this.id});

  void toggleDone(){
    isDone.value = !isDone.value;
  }

  @override
  String toString() {
    return '$id $name, $isDone, $category, $dateTime';
  }


}