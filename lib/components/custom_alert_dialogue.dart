import 'package:flutter/material.dart';

class CustomAlertDialogue extends StatelessWidget {
  final IconData? icon;
  final String? text;
  final Color? color;
  const CustomAlertDialogue({super.key, this.icon, this.text, this.color});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(20),
      iconPadding: EdgeInsets.all(20),
      backgroundColor: Colors.white,
      alignment: Alignment.center,
      icon: Icon(icon),
      iconColor: color,
      content: Text(text.toString()),
    );
  }
}
