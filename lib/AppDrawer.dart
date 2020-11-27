import 'package:flutter/material.dart';
import 'package:pen_mail_project/screens/AddingGuideInGroups.dart';
import 'package:pen_mail_project/screens/ComposeMessage/ComposeMessageScreen.dart';
import 'package:pen_mail_project/screens/DummyScreen.dart';
import 'package:pen_mail_project/screens/GroupPageScreen.dart';
import 'package:pen_mail_project/screens/GuidebookScreen.dart';
import 'package:pen_mail_project/screens/HomePageScreen.dart';
import 'package:pen_mail_project/screens/GetMessagesListScreen.dart';
import 'package:pen_mail_project/screens/SignatureScreen.dart';

class AppDrawer extends StatefulWidget {
  final token;

  AppDrawer({this.token});

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text(
              'Whats your choice?',
              style: TextStyle(fontFamily: 'Raleway'),
            ),
            automaticallyImplyLeading: false,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[Color(0xFF54A9FF), Color(0xFFC078FF)])),
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('HomePage',
                style: TextStyle(fontFamily: 'Nunito', fontSize: 16)),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (ctx) => HomePageScreen(
                            token: widget.token,
                          )));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.library_books),
            title: Text('GuideBook',
                style: TextStyle(fontFamily: 'Nunito', fontSize: 16)),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (ctx) => GuideBook(token: widget.token)));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.group),
            title: Text('Groups',
                style: TextStyle(fontFamily: 'Nunito', fontSize: 16)),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (ctx) => GroupPageScreen(token: widget.token)));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.add_circle),
            title: Text('Compose',
                style: TextStyle(fontFamily: 'Nunito', fontSize: 16)),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (ctx) => ComposeMessageScreen(token: widget.token)));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.message),
            title: Text('Messages',
                style: TextStyle(fontFamily: 'Nunito', fontSize: 16)),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (ctx) =>
                          GetMessageListScreen(token: widget.token)));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Signature',
                style: TextStyle(fontFamily: 'Nunito', fontSize: 16)),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (ctx) => SignatureScreen(token: widget.token)));
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}
