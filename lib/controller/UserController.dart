import 'package:flutter/material.dart';
import 'package:tasks/controller/AuthenticationController.dart';
import 'package:tasks/controller/TaskController.dart';
import 'package:tasks/model/Task.dart';
import 'package:tasks/model/User.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'dart:convert';

class UserController extends GetxController {

   late User user;
   TaskController taskController = Get.put(TaskController());

  Future getUser(String username) async {
    String url = '${AuthenticationController.urlStart}/user/$username';
    var response = await http.get(Uri.parse(url), headers: {
      'Authorization' : 'Bearer ${AuthenticationController.accessToken}'
    });
    if(response.statusCode == 200) {
      var responseBody = json.decode(response.body);
      user = User(id: responseBody['id'], firstName: responseBody['firstName'], lastName: responseBody['lastName'],
        email: responseBody['email'], username: responseBody['username']);
    } else {
      print('Could not fetch user details');
    }
    return response;
  }

  void logout() {
    AuthenticationController.accessToken = null;
    AuthenticationController.refreshToken = null;
    taskController.tasks = RxList<Task>();
    taskController.taskMap = RxMap<String, RxList<Task>>();
  }

  Future deleteUser() async {
    String username = user.username;
    String url = '${AuthenticationController.urlStart}/user/delete/$username';
    var response = await http.delete(Uri.parse(url), headers: {
      'Authorization' : 'Bearer ${AuthenticationController.accessToken}'
    });
    if(response.statusCode == 200) {
      logout();
      print('The user has been deleted');
      Get.snackbar(
        'Success!',
        'The user has been successfully deleted',
        backgroundColor: Colors.green[400],
        snackPosition: SnackPosition.BOTTOM,
        borderRadius: 5
      );
    } else {
      if(response.statusCode == 403) {
        String errorMessage = json.decode(response.body)['errorMessage'];
        if(errorMessage.startsWith('The Token has expired')) {
          var tempResponse = await AuthenticationController.tokenRefresh();
          if(tempResponse.statusCode == 200) {
            return deleteUser();
          } else {
            print(tempResponse.body);
            Get.snackbar(
              'Error!',
              'Required re-login',
              backgroundColor: Colors.redAccent,
              snackPosition: SnackPosition.BOTTOM,
              borderRadius: 5,
            );
          }
        } else {
          print(json.decode(response.body));
          Get.snackbar(
            'Error!',
            errorMessage,
            backgroundColor: Colors.redAccent,
            snackPosition: SnackPosition.BOTTOM,
            borderRadius: 5,
          );
        }
      }
    }
    return response;
  }
}