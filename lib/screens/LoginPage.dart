import 'package:flutter/material.dart';
import 'package:tasks/controller/AuthenticationController.dart';
import 'package:tasks/controller/UserController.dart';
import 'package:tasks/screens/ListTypeScreen.dart';
import 'package:tasks/screens/SignupPage.dart';
import 'package:tasks/widgets/CustomTextField.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthenticationController authenticationController = AuthenticationController();
  final UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/image4.jpg'),
                fit: BoxFit.fill,
                colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.3), BlendMode.srcOver),
                opacity: 0.8
            )
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome!',
                  style: TextStyle(
                    fontSize: 40,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                    color: Colors.black
                   ),
                ),
                SizedBox(
                  height: 20,
                ),
                CustomTextField(textEditingController: usernameController, hintText: 'Username', isPassword: false,),
                SizedBox(
                  height: 10,
                ),
                CustomTextField(textEditingController: passwordController, hintText: 'Password', isPassword: true,),
                SizedBox(
                  height: 25,
                ),
                ElevatedButton(
                  onPressed: () async {
                    var response = await authenticationController.loginUser(usernameController.text, passwordController.text);
                    if(response.statusCode == 200) {
                      var response2 = await userController.getUser(usernameController.text);
                      if(response2.statusCode == 200)
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ListScreen()));
                    }
                  },
                  child: Text(
                    'Login',
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account?',
                    ),
                    TextButton(
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignupPage())
                        );
                      },
                      child: Text(
                        'Sign up',
                        style: TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.underline
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
