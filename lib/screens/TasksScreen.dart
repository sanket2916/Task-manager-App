import 'package:flutter/material.dart';
import 'package:tasks/controller/TaskController.dart';
import 'package:tasks/model/Task.dart';
import 'package:tasks/widgets/TaskTile.dart';
import 'AddTaskScreen.dart';
import 'package:get/get.dart';

class TasksScreen extends StatelessWidget {
  final String category;
  final IconData icon;
  final Color color;
  final TaskController taskController = Get.put(TaskController());

  TasksScreen({required this.icon, required this.color, required this.category});

  RxList<Task>? taskList() {
    if(category == 'All') {
      return  taskController.tasks;
    }
    return taskController.taskMap[category];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTaskScreen(
                color: color,
                category: category == 'All' ? 'Work' : category,
              )
            )
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
        backgroundColor: color,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(10, 40, 10, 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(
                  height: 45,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 25,
                        child: Icon(
                          icon,
                          size: 30,
                          color: color,
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        category,
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                      Obx(() {
                        return Text(
                          '${taskController.taskCount(category)} Tasks',
                          style:
                              TextStyle(fontSize: 17, color: Color(0xFFFFFFFF)),
                        );
                      })
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                )
              ),
              child: Obx(() {
                RxList<Task>? tasks = category == 'All'? taskController.tasks : taskController.taskMap[category];
                return ListView.builder(
                  itemBuilder: (context, index){
                    return Obx(() {
                      return TaskTile(
                        color: color,
                        taskName: tasks![index].name,
                        checkBoxState: (checkBoxStatus) {
                          taskController.updateTask(tasks[index]);
                        },
                        isChecked : tasks[index].isDone.value,
                        dateTime: tasks[index].dateTime,
                        deleteTaskCallback: () {
                          taskController.deleteTask(tasks[index]);
                        },
                        editTaskCallback: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AddTaskScreen(
                                color: color, category: tasks[index].category, task: tasks[index],)
                              )
                          );
                        },
                      );
                    });
                  },
                  itemCount: tasks == null? 0 : tasks.length,
                );
              }),
            ),
          )
        ],
      ),
    );
  }
}
