import 'package:flutter/material.dart';
import 'package:tasks/controller/AuthenticationController.dart';
import 'package:tasks/screens/LoginPage.dart';
import 'package:tasks/widgets/CustomTextField.dart';

class SignupPage extends StatelessWidget {

  final AuthenticationController authenticationController = AuthenticationController();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/image5.jpg'),
            colorFilter: ColorFilter.mode(Colors.orangeAccent.withOpacity(0.5), BlendMode.srcOver),
            fit: BoxFit.fill
          )
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Create \nAccount',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic,
                          fontSize: 40
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      CustomTextField(textEditingController: firstnameController, hintText: "First Name", isPassword: false,),
                      SizedBox(
                        height: 10,
                      ),
                      CustomTextField(textEditingController: lastnameController, hintText: "Last Name", isPassword: false,),
                      SizedBox(
                        height: 10,
                      ),
                      CustomTextField(textEditingController: usernameController, hintText: "Username", isPassword: false,),
                      SizedBox(
                        height: 10,
                      ),
                      CustomTextField(textEditingController: emailController, hintText: 'Email', isPassword: false,),
                      SizedBox(
                        height: 10,
                      ),
                      CustomTextField(textEditingController: passwordController, hintText: "Password", isPassword: true,),
                      SizedBox(
                        height: 25,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if(_formKey.currentState!.validate()) {
                            var response = await authenticationController.newUser(
                                firstnameController.text, lastnameController.text,
                                usernameController.text,
                                emailController.text, passwordController.text);
                            if (response.statusCode == 200) {
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
                            }
                          }
                        },
                        child: Text(
                          'Sign up',
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account?',
                          ),
                          TextButton(
                            onPressed: (){
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => LoginPage())
                              );
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(
                                color: Color(0xFF0A65FF)
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
          ),
        ),
      ),
    );
  }
}