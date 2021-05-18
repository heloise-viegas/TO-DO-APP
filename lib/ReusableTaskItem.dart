import 'package:flutter/material.dart';
import 'package:z_to_do/authenticator.dart';

import 'constants.dart';

class ReusableTaskItem extends StatefulWidget {
  bool isComplete;
  final String taskId;
  final String taskName;
  ReusableTaskItem(this.taskId, this.taskName, this.isComplete);
  @override
  _ReusableTaskItemState createState() => _ReusableTaskItemState();
}

class _ReusableTaskItemState extends State<ReusableTaskItem> {
  Authenticator auth = Authenticator();
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
        ),
      ),
    );
  }
}
