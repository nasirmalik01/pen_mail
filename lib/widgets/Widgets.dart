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

Widget TextDataTitle({String title}){
  return Text(title , style: TextStyle(
      fontFamily: 'Raleway',
    fontWeight: FontWeight.bold,
    fontSize: 15
  ),);
}

Widget TextGuidebooksData({String firstTitle, String secondTitle, String thirdTitle}){
  return Row(
    children: [
      Text(firstTitle , style: TextStyle(
          fontFamily: 'Raleway',
          fontWeight: FontWeight.normal,
          fontSize: 18
      ),),
      Text(secondTitle , style: TextStyle(
          fontFamily: 'Raleway',
          fontWeight: FontWeight.bold,
          fontSize: 18
      ),),
      Text(thirdTitle , style: TextStyle(
          fontFamily: 'Raleway',
          fontWeight: FontWeight.normal,
          fontSize: 18
      ),),
    ],

  );
}


Widget TextDataContent({String title}){
  return Text(title , style: TextStyle(
      fontFamily: 'Nunito',
    fontSize: 15
  ),);
}

Widget TextDataContentGroup({String title}){
  return Text(title , style: TextStyle(
      fontFamily: 'Nunito',
    fontSize: 17
  ),);
}