import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'file:///D:/FlutterProjects/z_to_do/lib/firebase%20connections/authenticator.dart';

import 'constants.dart';

class ReusableTaskItem extends StatefulWidget {
  bool isComplete;
  final String taskId;
  final String taskName;
  final String taskDate;
  ReusableTaskItem(this.taskId, this.taskName, this.isComplete, this.taskDate);
  @override
  _ReusableTaskItemState createState() => _ReusableTaskItemState();
}

class _ReusableTaskItemState extends State<ReusableTaskItem> {
  Authenticator auth = Authenticator();
  final DateFormat formatter = DateFormat('dd-MMM-yyyy');
  // formatter.format(taskDate);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: GestureDetector(
        onTap: //onTapped,
            () {
          setState(() {
            widget.isComplete = !widget.isComplete;
            auth.updateTask(widget.taskId, widget.isComplete);
            //   print(widget.taskId);
          });

          // print('tapped');
        },
        child: Container(
          height: 80,
          //MediaQuery.of(context).size.height / 12, //80,
          // width: MediaQuery.of(context).size.width,
          //width: 210,
          decoration: BoxDecoration(
            color: Constants.kReusableCardColour,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
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
                      Expanded(
                        child: Text(
                          //Constants.kTaskItemName,
                          widget.taskName,
                          style: widget.isComplete
                              ? Constants.kTaskItemStrikeStyle
                              : Constants.kTaskItemStyle,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 3.0, left: 45.0),
                    child: Text(
//Constants.kTaskItemName,
                      widget.taskDate,
                      style: Constants.kLblCategoryStyle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// SizedBox(
// width: 1,
// ),
