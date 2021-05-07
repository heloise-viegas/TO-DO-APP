import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'authenticator.dart';
import 'constants.dart';
import 'inputDate.dart';
import 'inputText.dart';

class Task extends StatefulWidget {
  static String id = 'TaskScreen';

  @override
  _TaskState createState() => _TaskState();
}

class _TaskState extends State<Task> {
  Authenticator auth = Authenticator();
  TextEditingController taskTextController;
  TextEditingController taskDateController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    taskTextController = TextEditingController();
    taskDateController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('dd.MM.yyyy');
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 50,
            right: 50,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 200, bottom: 100),
                child: Container(
                  //margin: EdgeInsets.all(10),
                  //   padding: EdgeInsets.only(left:10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      width: 2,
                      color: Constants.kIconColour,
                    ),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Constants.kReusableCardColour,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
              InputText(
                hintText: Constants.kInputHintText,
                textController: taskTextController,
              ),
              SizedBox(
                height: 40,
              ),
              InputDate(
                dateController: taskDateController,
              ),
              SizedBox(
                height: 40,
              ),
              GestureDetector(
                onTap: () async {
                  print(
                      taskTextController.text + ':' + taskDateController.text);
                  Map<String, dynamic> task = Map();
                  task['TaskName'] = taskTextController.text;
                  task['TaskDate'] = DateTime.now();
                  //formatter.parse(taskDateController.text);
                  // TODO: RESOLVE INVALID DATE FORMAT  ERROR FOR PARSE
                  //DateTime.parse(taskDateController.text);
                  //formatter.format(taskDateController.text);
                  // task['TaskStatus'] = 'a';
                  // task['TaskComplete'] = 'a';
                  // task['CreateDate'] = 'a';
                  // task['UpdateDate'] = 'a';
                  try {
                    bool isSaved = await auth.create(task);
                    print(isSaved);
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Status'),
                            content: isSaved
                                ? Text('Saved Successfully.')
                                : Text('Saved Failed.'),
                            actions: [
                              FlatButton(
                                onPressed: () {
                                  // Navigator.of(context).pop(HomeScreen.id);
                                  Navigator.popUntil(
                                      context, ModalRoute.withName("Home"));
                                },
                                child: Text("OK"),
                              )
                            ],
                          );
                        });
                  } catch (e) {
                    print(e.toString());
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Text(
                    Constants.kBtnText,
                    style: Constants.kInputHintStyle,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Constants.kReusableCardColour,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // set up the button
  // Widget okButton = FlatButton(
  //   child: Text("OK"),
  //   onPressed: () {
  //     Navigator.pop(context);
  //   },
  // );
}
