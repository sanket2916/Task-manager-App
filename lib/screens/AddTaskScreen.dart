import 'package:flutter/material.dart';
import 'package:tasks/controller/TaskController.dart';
import 'package:tasks/model/Task.dart';
import 'ListTypeScreen.dart';
import 'package:get/get.dart';

const List<String> categories = ['Work', 'Music', 'Travel', 'Study', 'Shopping', 'Home', 'Medicine'];

class AddTaskScreen extends StatefulWidget {
  final Color color;
  final String category;
  final Task? task;
  AddTaskScreen({required this.color, required this.category, this.task});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {

  TaskController taskController = Get.put(TaskController());
  var taskNameController = TextEditingController();
  // var taskNameController;
  String? type;
  DateTime dateTime = DateTime.now();
  // var dateTime;

  @override
  void initState() {
    super.initState();
    type = widget.task == null? null : widget.task!.category;
    dateTime = widget.task == null? DateTime.now() : widget.task!.dateTime;
    taskNameController = TextEditingController(text: widget.task == null? null : widget.task!.name);
  }

  DropdownButton dropdownButton() {
    List<DropdownMenuItem<String>> items = [];
    for(String category in categories) {
      items.add(
        DropdownMenuItem(
          child: Text(category),
          value: category,
        )
      );
    }
    return DropdownButton(
      items: items,
      value: type == null? widget.category : type,
      onChanged: (value) {
        setState(() {
          type = value;
        });
      },
      iconEnabledColor: widget.color,
      menuMaxHeight: 200,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          '${widget.task == null? 'New' : 'Update'} task',
                          style: TextStyle(
                            fontSize: 25,
                            fontStyle: FontStyle.italic
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: Icon(
                            Icons.close,
                            size: 30,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 35),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'What are you planning?',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey
                      ),
                    ),
                    TextField(

                      autofocus: true,
                      cursorColor: widget.color,
                      controller: taskNameController,
                      style: TextStyle(
                        fontSize: 18
                      ),
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: widget.color),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.date_range,
                          size: 25,
                          color: widget.color,
                        ),
                        SizedBox(width: 5,),
                        Text(
                          '${ListScreen.days[dateTime.weekday]}, ${dateTime.day} ${ListScreen.months[dateTime.month]}',
                          style: TextStyle(
                            fontSize: 18
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Icon(
                          Icons.category_outlined,
                          size: 25,
                          color: widget.color,
                        ),
                        SizedBox(width: 5,),
                        dropdownButton(),
                      ],
                    ),
                    SizedBox(height: 75,),
                  ],
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(widget.color)
                ),
                child: Text(
                    '${widget.task == null? 'Create' : 'Update'}'
                ),
                onPressed: (){
                  if(taskNameController.text.length > 0) {
                    Task task = Task(
                      id: widget.task == null? null : widget.task!.id,
                      name: taskNameController.text,
                      dateTime: dateTime,
                      category: type == null? widget.category : type!,
                      isDone: false.obs
                    );
                    widget.task == null? taskController.addTask(task) : taskController.updateTaskName(task);
                  }
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}