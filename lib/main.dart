import 'package:flutter/material.dart';
import 'package:pen_mail_project/screens/LoginScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
      title: 'Pen Survey',
    );
  }
}
