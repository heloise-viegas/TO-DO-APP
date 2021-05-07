import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'constants.dart';

class InputDate extends StatefulWidget {
  TextEditingController dateController;
  InputDate({this.dateController});

  @override
  _InputDateState createState() => _InputDateState();
}

class _InputDateState extends State<InputDate> {
  DateTime selectedDate = DateTime.now();
  final DateFormat formatter = DateFormat('dd-MMM-yyyy');
  String formattedDate = "";

  @override
  void initState() {
    super.initState();
    formattedDate = formatter.format(selectedDate);
    widget.dateController = TextEditingController(text: formattedDate);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.dateController,
      cursorColor: Constants.kFabColour,
      decoration: InputDecoration(
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
      onTap: () async {
        // print(
        //   '1.' + selectedDate.toString(),
        // );
        await selectDate(context);

        formattedDate = formatter.format(selectedDate);
        widget.dateController.text = formattedDate;
      },
    );
  }

  Future selectDate(BuildContext context) async {
    //print('q');
    final DateTime pickedDt = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );
    if (pickedDt != null)
      setState(() {
        selectedDate = pickedDt;
        // print(
        //   '3.' + selectedDate.toString(),
        // );
      });
  }
}
