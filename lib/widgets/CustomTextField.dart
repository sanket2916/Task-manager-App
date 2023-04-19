import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {

  final TextEditingController textEditingController;
  final String hintText;
  final bool isPassword;

  CustomTextField({required this.textEditingController, required this.hintText, required this.isPassword});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextFormField(
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.black87
          ),
          enabledBorder: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(),
          fillColor: Colors.white,
          filled: true,
        ),
        obscureText: isPassword,
        cursorColor: Colors.black,
        controller: textEditingController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if(value == null || value.isEmpty) {
            return '$hintText cannot be empty';
          }
          return null;
        },
      ),
    );
  }
}
