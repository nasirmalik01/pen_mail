import 'package:flutter/material.dart';

Widget InputWidget(
    {String hintText, String labelText, TextEditingController controller}) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        labelStyle: TextStyle(
          fontFamily: 'Nunito',
        ),
        hintStyle: TextStyle(fontFamily: 'Raleway')),
    validator: (value) {
      if (value.isEmpty) {
        return '$labelText can\'t be empty';
      }
      return null;
    },
  );
}

Widget addGuideBookInputField({
  TextEditingController controller,
  String hintText,
  String inputField,
}) {
  return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
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
          return '$inputField can\'t be empty';
        }
        return null;
      });
}

ComposeMessageError({BuildContext context, String errorMessage}){
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            errorMessage,
            style: TextStyle(fontFamily: 'Raleway'),
          ),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Okay',
                style: TextStyle(
                    fontFamily: 'Raleway',
                    color: Colors.red),
              ),
            )
          ],
        );
      });
}

ComposeMessageSendMessage({BuildContext context, String errorMessage, Function onPress}){
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            errorMessage,
            style: TextStyle(fontFamily: 'Raleway', fontWeight: FontWeight.bold),
          ),
          actions: [
            FlatButton(
              onPressed: onPress,
              child: Text(
                'Okay',
                style: TextStyle(
                    fontFamily: 'Raleway',
                    color: Colors.red),
              ),
            )
          ],
        );
      });
}

ComposeMessageButton(
    {MediaQueryData mediaQueryData, String title, Function onPress}) {
  return Container(
    margin: EdgeInsets.only(top: mediaQueryData.size.height * 0.04),
    width: mediaQueryData.size.width * 0.45,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5), color: Colors.lightBlue),
    child: FlatButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            title,
            style:
                TextStyle(fontFamily: 'Nunito', fontSize: 18, color: Colors.white),
          ),
          Icon(Icons.arrow_forward, color: Colors.white,)
        ],
      ),
      onPressed: onPress,
    ),
  );
}


AttachmentBackButton(
    {MediaQueryData mediaQueryData, String title, Function onPress}) {
  return Container(
    margin: EdgeInsets.only(top: mediaQueryData.size.height * 0.04),
    width: mediaQueryData.size.width * 0.45,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5), color: Colors.lightBlue),
    child: FlatButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(Icons.arrow_back, color: Colors.white,),
          Text(
            title,
            style:
            TextStyle(fontFamily: 'Nunito', fontSize: 18, color: Colors.white),
          ),
        ],
      ),
      onPressed: onPress,
    ),
  );
}


AddAttachment(
    {MediaQueryData mediaQueryData, String title, Function onPress}) {
  return Container(
    margin: EdgeInsets.only(top: mediaQueryData.size.height * 0.04),
    width: mediaQueryData.size.width * 0.7,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5), color: Colors.red),
    child: FlatButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            title,
            style:
            TextStyle(fontFamily: 'Nunito', fontSize: 18, color: Colors.white),
          ),
          Icon(Icons.add_circle, color: Colors.white,)
        ],
      ),
      onPressed: onPress,
    ),
  );
}
Widget ComposeMessageContentField({
  TextEditingController controller,
  String hintText,
  String inputField,
}) {
  return TextFormField(
      controller: controller,
      maxLines: 10,
      decoration: InputDecoration(
        hintText: hintText,
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
          return '$inputField can\'t be empty';
        }
        return null;
      });
}

Widget TextDataTitle({String title}) {
  return Text(
    title,
    style: TextStyle(
        fontFamily: 'Raleway', fontWeight: FontWeight.bold, fontSize: 15),
  );
}

Widget ComposeMessageTextDta({String title}) {
  return Text(
    title,
    style: TextStyle(
        fontFamily: 'Raleway', fontWeight: FontWeight.bold, fontSize: 17),
  );
}

Widget ComposeMessageHeading({String heading}) {
  return ComposeMessageTextDta(title: heading);
}

Widget ComposeMessageController(
    {TextEditingController controller, String hintText, String inputField}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: addGuideBookInputField(
        controller: controller, hintText: hintText, inputField: inputField),
  );
}

Widget ComposeMessageContentController(
    {TextEditingController controller, String hintText, String inputField}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: ComposeMessageContentField(
        controller: controller, hintText: hintText, inputField: inputField),
  );
}

Widget TextGuidebooksData(
    {String firstTitle, String secondTitle, String thirdTitle}) {
  return Row(
    children: [
      Text(
        firstTitle,
        style: TextStyle(
            fontFamily: 'Raleway', fontWeight: FontWeight.normal, fontSize: 18),
      ),
      Text(
        secondTitle,
        style: TextStyle(
            fontFamily: 'Raleway', fontWeight: FontWeight.bold, fontSize: 18),
      ),
      Text(
        thirdTitle,
        style: TextStyle(
            fontFamily: 'Raleway', fontWeight: FontWeight.normal, fontSize: 18),
      ),
    ],
  );
}

Widget TextDataContent({String title}) {
  return Text(
    title,
    style: TextStyle(fontFamily: 'Nunito', fontSize: 15),
  );
}

Widget TextDataContentGroup({String title}) {
  return Text(
    title,
    style: TextStyle(fontFamily: 'Nunito', fontSize: 17),
  );
}
