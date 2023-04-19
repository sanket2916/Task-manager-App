import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tasks/controller/TaskController.dart';
import 'package:tasks/model/Task.dart';
import 'package:get/get.dart';

class AuthenticationController {
  static String? accessToken;
  static String? refreshToken;
  final TaskController taskController = Get.put(TaskController());
  static const urlStart = 'http://(ip address):8080/api';

  Future loginUser(String username, String password) async {
    const url = '$urlStart/login';

    var response = await http.post(Uri.parse(url), body: {
      "username": username,
      "password": password
    });

    if(response.statusCode == 200) {
      var loginArr = json.decode(response.body);
      accessToken = loginArr['accessToken'];
      refreshToken = loginArr['refreshToken'];
      print('Access Token -------- $accessToken');
      print('Refresh Token -------------- $refreshToken');
      await taskController.getTask(username);
    } else {
      print(response.statusCode);
      print(json.decode(response.body));
      print('Login error');
      Get.snackbar(
        "Error!",
        jsonDecode(response.body)['message'],
        backgroundColor: Colors.blueGrey,
        snackPosition: SnackPosition.BOTTOM,
        borderRadius: 5,
      );
    }
    return response;
  }

  Future newUser(String firstName, String lastName, String username, String email, String password) async {
    const url = '$urlStart/saveUser';

    Map<String, String> data = {
      "firstName": firstName,
      "lastName": lastName,
      "username": username,
      "email": email,
      "password": password
    };

    var response = await http.post(Uri.parse(url), body: json.encode(data), headers: {"Content-Type": "application/json"});

    if(response.statusCode == 200) {
      var result = json.decode(response.body);
      print(result);
      Get.snackbar(
        'Success!',
        'The user has been added',
        backgroundColor: Colors.green[400],
        snackPosition: SnackPosition.BOTTOM
      );
    } else {
      print('Failed to add new user');
      print(response.statusCode);
      print(json.decode(response.body));
      Get.snackbar(
        "Error!",
        jsonDecode(response.body)['message'],
        backgroundColor: Colors.blueGrey,
        snackPosition: SnackPosition.BOTTOM
      );
    }
    return response;
  }

  static Future tokenRefresh() async {
    print('Called token refresh');
    String url = '$urlStart/token/refresh';
    var response = await http.get(Uri.parse(url), headers: {
      'Authorization' : 'Bearer $refreshToken'
    });
    if(response.statusCode == 200) {
      var result = json.decode(response.body);
      accessToken = result['accessToken'];
    } else {
      print(response.body);
    }
    return response;
  }

}