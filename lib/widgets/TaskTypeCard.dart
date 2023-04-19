import 'package:flutter/material.dart';
import 'package:tasks/controller/TaskController.dart';
import 'package:tasks/screens/TasksScreen.dart';
import 'package:get/get.dart';

class TaskTypeCard extends StatelessWidget {

  final bool? isLeft;
  final IconData icon;
  final Color color;
  final String category;
  final int count;
  TaskTypeCard({this.isLeft, required this.icon, required this.color, required this.category, required this.count});

  final TaskController taskController = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 180,
      child: Card(
        // margin: EdgeInsets.fromLTRB(isLeft!? 15: 7.5, 7.5, isLeft!? 7.5: 15, 7.5),
        child: InkWell(
          onTap: (){
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TasksScreen(icon: icon, color: color, category: category,))
            );
          },
          highlightColor: color,
          splashColor: color,
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 0, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  size: 35,
                  color: color,
                ),
                SizedBox(
                  height: 49,
                ),
                Text(
                  category,
                  style: TextStyle(
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500
                  ),
                ),
                Text(
                  '$count tasks',
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
