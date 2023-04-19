import 'package:flutter/material.dart';

class InfoTile extends StatelessWidget {
  final String text;
  final IconData icon;

  InfoTile({required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
          title: Text(
            text,
            style: TextStyle(
              fontSize: 17,
              fontStyle: FontStyle.italic
            ),
          ),
          leading: Icon(
            icon,
            size: 30,
            color: Color(0xFF111328),
          ),
        )
    );
  }
}