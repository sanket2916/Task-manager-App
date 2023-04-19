import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasks/controller/UserController.dart';
import 'package:tasks/screens/LoginPage.dart';
import 'package:tasks/screens/SignupPage.dart';
import 'package:tasks/widgets/InfoTile.dart';

class ProfileScreen extends StatelessWidget {
  final UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF111328),
                ),
                width: double.infinity,
                padding: EdgeInsets.only(bottom: 5, top: 5, left: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF1D1E33),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      '${userController.user.firstName}',
                      style: TextStyle(
                        fontSize: 40,
                        fontStyle: FontStyle.italic,
                        color: Colors.white
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InfoTile(
                      text: '${userController.user.firstName} ${userController.user.lastName}',
                      icon: Icons.account_circle_outlined,
                    ),
                    InfoTile(
                      text: '${userController.user.username}',
                      icon: Icons.person
                    ),
                    InfoTile(
                      text: '${userController.user.email}',
                      icon: Icons.mail_outline,
                    ),
                    ElevatedButton.icon(
                      icon: Icon(
                        Icons.logout_outlined
                      ),
                      label: Text(
                        'Logout'
                      ),
                      onPressed: (){
                        userController.logout();
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink[600]
                      ),
                    ),
                    ElevatedButton.icon(
                      icon: Icon(
                        Icons.delete_outline_rounded
                      ),
                      label: Text(
                        'Delete Account'
                      ),
                      onPressed: () async {
                        var response = await userController.deleteUser();
                        if(response.statusCode == 200) {
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SignupPage()), (route) => false);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink[600]
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}