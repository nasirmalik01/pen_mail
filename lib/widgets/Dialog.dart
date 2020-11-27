import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pen_mail_project/widgets/Widgets.dart';

Widget showAddDialog(
    {TextEditingController surnameController,
    TextEditingController emailController,
    TextEditingController gsmController,
    MediaQueryData mediaQueryData,
    Function onPress,
    bool isLoading = false,
    String title}) {
  return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)), //this right here
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            height: 400,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: mediaQueryData.size.height * 0.05,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: addGuideBookInputField(
                      controller: surnameController,
                      hintText: 'Surname',
                      inputField: 'Surname'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: addGuideBookInputField(
                      controller: emailController,
                      hintText: 'Email',
                      inputField: 'Email Address'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: addGuideBookInputField(
                      controller: gsmController,
                      hintText: 'GSM',
                      inputField: 'GSM Number'),
                ),
                Container(
                  margin:
                      EdgeInsets.only(top: mediaQueryData.size.height * 0.04),
                  width: mediaQueryData.size.width * 0.5,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.lightBlue),
                  child: FlatButton(
                    child: isLoading == true
                        ? SpinKitFadingCircle(
                            color: Colors.white,
                          )
                        : Text(
                            title,
                            style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 18,
                                color: Colors.white),
                          ),
                    onPressed: onPress,
                  ),
                )
              ],
            ),
          ),
        ),
      ));
}

Widget showUpdateDialog(
    {TextEditingController surnameController,
    TextEditingController emailController,
    TextEditingController gsmController,
    MediaQueryData mediaQueryData,
    Function onPress,
    bool isLoading = false,
    String title}) {
  return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)), //this right here
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            height: 400,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: mediaQueryData.size.height * 0.05,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: addGuideBookInputField(
                      controller: surnameController,
                      hintText: 'Surname',
                      inputField: 'Surname'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: addGuideBookInputField(
                      controller: emailController,
                      hintText: 'Email',
                      inputField: 'Email Address'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: addGuideBookInputField(
                      controller: gsmController,
                      hintText: 'GSM',
                      inputField: 'GSM Number'),
                ),
                Container(
                  margin:
                      EdgeInsets.only(top: mediaQueryData.size.height * 0.04),
                  width: mediaQueryData.size.width * 0.5,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.lightBlue),
                  child: FlatButton(
                    child: isLoading == true
                        ? SpinKitFadingCircle(
                            color: Colors.white,
                          )
                        : Text(
                            title,
                            style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 18,
                                color: Colors.white),
                          ),
                    onPressed: onPress,
                  ),
                )
              ],
            ),
          ),
        ),
      ));
}

Widget showAddGroupDialog(
    {TextEditingController addGroupController,
    MediaQueryData mediaQueryData,
    Function onPress,
    bool isLoading = false,
    String title}) {
  return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)), //this right here
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: mediaQueryData.size.height * 0.04,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: addGuideBookInputField(
                        controller: addGroupController,
                        hintText: 'Group Name',
                        inputField: 'Group Name'),
                  ),
                  Container(
                    margin:
                        EdgeInsets.only(top: mediaQueryData.size.height * 0.04),
                    width: mediaQueryData.size.width * 0.5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.lightBlue),
                    child: FlatButton(
                      child: isLoading == true
                          ? SpinKitFadingCircle(
                              color: Colors.white,
                            )
                          : Text(
                              title,
                              style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: 18,
                                  color: Colors.white),
                            ),
                      onPressed: onPress,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ));
}

Widget showDialogChoosing({BuildContext context, Function onPressGuidebooks, Function onPressGroups, bool isMail = false}) {
  return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)), //this right here
      child: Container(
        height: MediaQuery.of(context).size.height * 0.4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isMail ? 'Send Mail to' :  'Send Message to:',
              style: TextStyle(
                  color: Colors.black, fontFamily: 'Raleway', fontSize: 18),
            ),
            SizedBox(
              height: 45,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.lightBlue),
              child: FlatButton(
                child: Text(
                  'Guidebooks',
                  style: TextStyle(
                      color: Colors.white, fontFamily: 'Raleway', fontSize: 18),
                ),
                onPressed: onPressGuidebooks,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.lightBlue),
              child: FlatButton(
                child: Text(
                  'Groups',
                  style: TextStyle(
                      color: Colors.white, fontFamily: 'Raleway', fontSize: 18),
                ),
                onPressed: onPressGroups,
              ),
            ),
          ],
        ),
      ));
}



Widget showAddSignatureDialog(
    {TextEditingController nameController,
    TextEditingController contentController,
      MediaQueryData mediaQueryData,
      Function onPress,
      bool isLoading = false,
      String title}) {
  return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)), //this right here
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: mediaQueryData.size.height * 0.04,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: addGuideBookInputField(
                        controller: nameController,
                        hintText: 'Signaure Name',
                        inputField: 'Signature Name'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      maxLines: 5,
                        controller: contentController,
                        decoration: InputDecoration(
                          hintText: 'Signature Content',
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey, width: 1),
                          ),
                        ),
                        style: TextStyle(fontFamily: 'Raleway'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Signature Content can\'t be empty';
                          }
                          return null;
                        })
                  ),
                  Container(
                    margin:
                    EdgeInsets.only(top: mediaQueryData.size.height * 0.04),
                    width: mediaQueryData.size.width * 0.5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.lightBlue),
                    child: FlatButton(
                      child: isLoading == true
                          ? SpinKitFadingCircle(
                        color: Colors.white,
                      )
                          : Text(
                        'Add Signature',
                        style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 18,
                            color: Colors.white),
                      ),
                      onPressed: onPress,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ));
}