import 'package:flutter/material.dart';
import 'package:z_to_do/authenticator.dart';

import 'constants.dart';

class ReusableTaskItem extends StatefulWidget {
  Authenticator auth = Authenticator();
  bool isComplete = false;
  final String taskName;
  ReusableTaskItem(this.taskName);
  @override
  _ReusableTaskItemState createState() => _ReusableTaskItemState();
}

class _ReusableTaskItemState extends State<ReusableTaskItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: GestureDetector(
        onTap: //onTapped,
            () {
          setState(() {
            widget.isComplete = true;
          });

          // print('tapped');
        },
        child: Container(
          height: 80,
          //width: 210,
          decoration: BoxDecoration(
            color: Constants.kReusableCardColour,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  widget.isComplete
                      ? Icons.check_circle_rounded
                      : Icons.check_circle_outlined,
                  color: Colors.pink,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  //Constants.kTaskItemName,
                  widget.taskName,
                  style: widget.isComplete
                      ? Constants.kTaskItemStrikeStyle
                      : Constants.kTaskItemStyle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
