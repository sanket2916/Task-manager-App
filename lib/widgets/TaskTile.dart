import 'package:flutter/material.dart';
import '../screens/ListTypeScreen.dart';

class TaskTile extends StatelessWidget {

  final Color? color;
  final bool? isChecked;
  final String? taskName;
  final Function(bool?)? checkBoxState;
  final DateTime? dateTime;
  final Function()? deleteTaskCallback;
  final Function()? editTaskCallback;

  TaskTile({this.color, this.taskName, this.isChecked, this.checkBoxState, this.dateTime, this.deleteTaskCallback, this.editTaskCallback});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 500),
        opacity: isChecked!? 0.4 : 1,
        child: Card(
            child: ListTile(
              leading: Checkbox(
                value: isChecked,
                onChanged: checkBoxState,
                activeColor: color,
              ),
              title: Text(
                taskName!,
                style: TextStyle(
                    decoration: isChecked!? TextDecoration.lineThrough: null,
                    color: isChecked!? color: Colors.black
                ),
              ),
              subtitle: Text(
                '${dateTime!.day} ${ListScreen.months[dateTime!.month]}',
                style: TextStyle(
                  color: Colors.blueGrey
                ),
              ),
              trailing: SizedBox(
                width: 96,
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: Colors.blueGrey,
                      ),
                      onPressed: editTaskCallback,
                      splashRadius: 22,
                      splashColor: color!.withOpacity(0.4),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete_rounded,
                        color: Colors.blueGrey,
                      ),
                      onPressed: deleteTaskCallback,
                      splashRadius: 22,
                      splashColor: color!.withOpacity(0.4),
                    ),
                  ],
                ),
              )
            )
        ),
      ),
    );
  }
}
