import 'package:tasks/controller/AuthenticationController.dart';
import 'dart:convert';
import '../model/Task.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class TaskController extends GetxController {
  RxList<Task> _tasks = <Task>[].obs;

  set tasks(RxList<Task> value) {
    _tasks = value;
  }

  RxMap<String, RxList<Task>> _taskMap = Map<String, RxList<Task>>().obs;
  int get count => _tasks.length;
  late String _username;

  Future getTask(String username) async {
    String url = '${AuthenticationController.urlStart}/user/task/$username';
    var response = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${AuthenticationController.accessToken}'
    });
    if(response.statusCode == 200) {
      _username = username;
      var responseBody = json.decode(response.body);
      for(var tempTask in responseBody) {
        Task task = Task(id: tempTask['id'],name: tempTask['task_name'], category: tempTask['category'],
            dateTime: DateTime.parse(tempTask['date']), isDone: RxBool(tempTask['done']));
        _tasks.add(task);
        if(!_taskMap.containsKey(task.category)) {
          _taskMap[task.category] = <Task>[].obs;
        }
        _taskMap[task.category]!.add(task);
      }
    } else {
      print('Error getting task details');
    }
  }

  void addTask(Task task) async {
    String url = '${AuthenticationController.urlStart}/user/task/$_username';
    String date = task.dateTime.toString().split(" ")[0];
    Map<String, String> data = {
      "task_name": task.name,
      "done": task.isDone.toString(),
      "category": task.category,
      "date": date
    };
    var response = await http.post(Uri.parse(url), body: json.encode(data), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${AuthenticationController.accessToken}'
    });
    if(response.statusCode == 200){
      task.id = json.decode(response.body)['id'];
      _tasks.add(task);
      if(!_taskMap.containsKey(task.category)) {
        _taskMap[task.category] = <Task>[].obs;
      }
      _taskMap[task.category]!.add(task);
    } else {
      if(response.statusCode == 403) {
        String errorMessage = json.decode(response.body)['errorMessage'];
        if(errorMessage.startsWith('The Token has expired')) {
          var tempResponse = await AuthenticationController.tokenRefresh();
          if(tempResponse.statusCode == 200) {
            addTask(task);
          }
        }
      } else {
        print(json.decode(response.body));
      }
    }
  }

  void updateTaskName(Task task) async {
    String url = '${AuthenticationController.urlStart}/user/task/update/$_username';
    String date = task.dateTime.toString().split(" ")[0];
    Map<String, String> data = {
      "id": task.id.toString(),
      "task_name": task.name,
      "done": task.isDone.toString(),
      "category": task.category,
      "date": date
    };
    var response = await http.put(Uri.parse(url), body: json.encode(data), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${AuthenticationController.accessToken}'
    });
    if(response.statusCode == 200) {
      String initialCategory = task.category;
      for(int i = 0; i < _tasks.length; i++) {
        if(_tasks[i].id == task.id) {
          // _tasks.remove(temp);
          // _tasks.add(task);
          initialCategory = _tasks[i].category;
          _tasks[i] = task;
        }
      }
      if(initialCategory != task.category) {
        if(!_taskMap.containsKey(task.category)) {
          _taskMap[task.category] = <Task>[].obs;
        }
        _taskMap[task.category]!.add(task);
        for(Task temp in _taskMap[initialCategory]!) {
          if(temp.id == task.id) {
            _taskMap[initialCategory]!.remove(temp);
          }
        }
      } else {
        for(int i = 0; i < _taskMap[task.category]!.length; i++) {
          if(_taskMap[task.category]![i].id == task.id) {
            // _taskMap[task.category]!.remove(temp);
            // _taskMap[task.category]!.add(task);
            _taskMap[task.category]![i] = task;
          }
        }
      }
    } else {
      if(response.statusCode == 403) {
        String errorMessage = json.decode(response.body)['errorMessage'];
        if(errorMessage.startsWith('The Token has expired')) {
          var tempResponse = await AuthenticationController.tokenRefresh();
          if(tempResponse.statusCode == 200) {
            updateTaskName(task);
          }
        }
      } else {
        print(json.decode(response.body));
      }
    }
  }

  void deleteTask(Task task) async {
    int taskId = task.id!;
    String url = '${AuthenticationController.urlStart}/user/task/delete/$_username/$taskId';
    var response = await http.delete(Uri.parse(url), headers: {
      "Authorization" : "Bearer ${AuthenticationController.accessToken}"
    });
    if(response.statusCode == 200) {
      _tasks.remove(task);
      _taskMap[task.category]!.remove(task);
      print('Task successfully deleted');
    } else {
      if(response.statusCode == 403) {
        String errorMessage = json.decode(response.body)['errorMessage'];
        if(errorMessage.startsWith('The Token has expired')) {
          var tempResponse = await AuthenticationController.tokenRefresh();
          if(tempResponse.statusCode == 200) {
            deleteTask(task);
          }
        }
      } else {
        print(json.decode(response.body));
      }
    }
  }

  void updateTask(Task task) async {
    int taskId = task.id!;
    String url = '${AuthenticationController.urlStart}/user/task/update/$_username/$taskId';
    var response = await http.put(Uri.parse(url), headers: {
      "Authorization": "Bearer ${AuthenticationController.accessToken}"
    });
    if(response.statusCode == 200) {
      task.toggleDone();
    } else {
      if(response.statusCode == 403) {
        String errorMessage = json.decode(response.body)['errorMessage'];
        if(errorMessage.startsWith('The Token has expired')) {
          var tempResponse = await AuthenticationController.tokenRefresh();
          if(tempResponse.statusCode == 200) {
            updateTask(task);
          }
        }
      } else {
        print(json.decode(response.body));
      }
    }
  }

  RxMap<String, RxList<Task>> get taskMap => _taskMap;
  RxList<Task> get tasks => _tasks;

  int taskCount(String category) {
    if(category == 'All') {
      return count;
    }
    return taskMap[category] == null? 0 : taskMap[category]!.length;
  }

  set taskMap(RxMap<String, RxList<Task>> value) {
    _taskMap = value;
  }
}