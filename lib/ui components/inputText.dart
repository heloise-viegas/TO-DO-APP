import 'package:flutter/material.dart';

import 'constants.dart';

class InputText extends StatelessWidget {
  final TextEditingController textController;
  final String hintText;
  InputText({this.hintText, this.textController});

  @override
  Widget build(BuildContext context) {
    return TextField(
      // validator: (value) {
      //   if (value == null || value.isEmpty) {
      //     return 'Please enter some text';
      //   }
      //   return null;
      // },
      controller: textController,
      cursorColor: Constants.kFabColour,
      // decoration: InputDecoration.collapsed(
      //   hintText: Constants.kInputText,
      //   hintStyle: Constants.kInputHintStyle,
      // ),
      // style: Constants.kInputTextStyle,
      decoration: InputDecoration(
        hintText: hintText, //Constants.kInputText,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(width: 2, color: Constants.kDrawerBackIcon),
        ),
        border: InputBorder.none,
        // enabledBorder: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(50),
        //   borderSide:
        //       BorderSide(width: 2, color: Constants.kDrawerBackIcon),
        // ),
      ),
      style: Constants.kInputTextStyle,
    );
  }
}
