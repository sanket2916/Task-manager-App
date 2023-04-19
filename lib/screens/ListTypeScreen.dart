import 'dart:core';
import 'package:flutter/material.dart';
import 'package:tasks/controller/TaskController.dart';
import 'package:tasks/controller/UserController.dart';
import 'package:tasks/screens/ProfileScreen.dart';
import 'package:tasks/widgets/TaskTypeCard.dart';
import 'package:get/get.dart';

import 'AddTaskScreen.dart';

class ListScreen extends StatelessWidget {

  static final Map months = {1:"January", 2:"February", 3:"March", 4:"April", 5:"May", 6:"June", 7:"July", 8:"August", 9:"September", 10:"October",
    11:"November", 12:"December"};
  static final Map days = {1:"Monday", 2:"Tuesday", 3:"Wednesday", 4:"Thursday", 5:"Friday", 6:"Saturday", 7:"Sunday"};
  final List<IconData> icons = [Icons.format_list_bulleted, Icons.work_outline_outlined, Icons.music_note_outlined,
        Icons.airplane_ticket_outlined, Icons.book_outlined, Icons.shopping_cart, Icons.home, Icons.medication_sharp];
  final List<Color> colors = [Colors.blue, Color(0xFF0A2647), Colors.orange, Colors.green, Colors.pink, Colors.purple, Colors.brown, Colors.red];
  final List<String> categories = ['All', 'Work', 'Music', 'Travel', 'Study', 'Shopping', 'Home', 'Medicine'];

  final TaskController taskController = Get.put(TaskController());
  final UserController userController = Get.put(UserController());

  List<int> indexes() {
    List<int> index = [0];
    for(int i = 1; i < categories.length; i++) {
      if(taskController.taskCount(categories[i]) > 0) {
        index.add(i);
      }
    }
    return index;
  }

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.now();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskScreen(color: Colors.blue, category: 'Work',))
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(30, 55, 20, 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      'Hello',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w300
                      ),
                    ),
                    Text(
                      '${userController.user.firstName}',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text(
                          '${days[dateTime.weekday]}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey
                          ),
                        ),
                        Text(
                          ', ${dateTime.day} ${months[dateTime.month]}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w300,
                            color: Colors.grey
                          ),
                        )
                      ],
                    )
                  ],
                ),
                IconButton(
                  icon: Icon(
                    Icons.account_circle,
                  ),
                  iconSize: 50,
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
                  },
                  splashColor: Color(0x8F97DECE),
                  splashRadius: 35,
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.fromLTRB(7, 0, 7, 10),
              child: Obx(() {
                List<int> list = indexes();
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    String category = categories[list[index]];
                    return (category != 'All' && taskController.taskCount(category) == 0)?null : Obx(() {
                      return TaskTypeCard(
                        count: taskController.taskCount(category),
                        icon: icons[list[index]],
                        color: colors[list[index]],
                        category: categories[list[index]],
                      );
                    });
                  },
                  itemCount: list.length,
                );
              }),
            ),
          )
        ],
      ),
    );
  }
}