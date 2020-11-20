import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pen_mail_project/Backend/Login.dart';
import 'package:pen_mail_project/screens/HomePageScreen.dart';
import 'package:pen_mail_project/widgets/Widgets.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> _formKey = GlobalKey();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    MediaQueryData _mediaQuery = MediaQuery.of(context);
    return Scaffold(
      key: _scaffoldKey,
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage('assets/images/mail.png'),
                  width: 125,
                  height: 125,
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 30),
                    child: InputWidget(
                        labelText: 'Username',
                        hintText: 'Enter your Username',
                        controller: _usernameController)),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 0.0, horizontal: 30),
                    child: InputWidget(
                        labelText: 'Password',
                        hintText: 'Enter your Password',
                        controller: _passwordController)),
                Container(
                  margin: EdgeInsets.only(top: _mediaQuery.size.height * 0.06),
                  width: _mediaQuery.size.width * 0.7,
                  height: _mediaQuery.size.height * 0.07,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Color(0xFF54A9FF),
                      Color(0xFFC078FF),
                    ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: FlatButton(
                    onPressed: () async {
                      String _username = _usernameController.text;
                      String _password = _passwordController.text;

                      if (!_formKey.currentState.validate()) {
                        return;
                      }
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }

                      setState(() {
                        isLoading = true;
                      });
                      var loginResponse = await loginUser(
                          username: _username, password: _password);
                      var _res = jsonDecode(loginResponse);
                      var status = _res['status'];
                      if (status == false) {
                        setState(() {
                          isLoading = false;
                        });
                        //print('null');
                        _scaffoldKey.currentState.hideCurrentSnackBar();
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text('User not registered'),
                        ));
                        return;
                      }

                      String _token = _res['data']['token'];
                      print(_token);
                      setState(() {
                        isLoading = false;
                      });
                      //var decodedReply = jsonDecode(response);
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return HomePageScreen(
                          token: _token,
                        );
                      }));
                    },
                    child: isLoading
                        ? SpinKitFadingCircle(
                            color: Colors.white,
                          )
                        : Text(
                            'Log In',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Nunito',
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
