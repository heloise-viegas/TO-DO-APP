import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../firebase connections/authenticator.dart';
import '../ui components/constants.dart';
import '../ui components/inputDate.dart';
import '../ui components/inputText.dart';

class Task extends StatefulWidget {
  static String id = 'TaskScreen';

  @override
  _TaskState createState() => _TaskState();
}

class _TaskState extends State<Task> {
  Authenticator auth = Authenticator();
  TextEditingController taskTextController;
  TextEditingController taskDateController;

  DateTime currentDate = DateTime.now();
  final DateFormat formatter = DateFormat('dd-MMM-yyyy');
  //final DateFormat formatSave = DateFormat('dd-MM-yyyy');

  String formattedDate = "";

  @override
  void initState() {
    super.initState();
    taskTextController = TextEditingController();
    //taskDateController = TextEditingController();
    //print('add date');
    formattedDate = formatter.format(currentDate);
    taskDateController = TextEditingController(text: formattedDate);
    //print(formatterSave.fo);
    // String _savedDate = taskDateController.text.replaceAll('-', '.');
    //  print(_savedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
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
                height: MediaQuery.of(context).size.height / 20,
              ),
              InputDate(
                dateController: taskDateController,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 20,
              ),
              GestureDetector(
                onTap: () async {
                  //print(taskDateController.text);
                  DateTime setDate =
                      DateFormat("dd-MMM-yy").parse(taskDateController.text);
                  Timestamp timestamp =
                      Timestamp.fromDate(DateTime.parse(setDate.toString()));
                  //print(setDate);
                  Map<String, dynamic> task = Map();
                  task['TaskName'] = taskTextController.text;
                  task['TaskDate'] = timestamp; //timestamp
                  FocusManager.instance.primaryFocus
                      .unfocus(); //to hide keyboard on save
                  try {
                    bool isSaved = await auth.create(task);
                    //      print(isSaved);
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
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  // Navigator.pop(
                                  //     context, ModalRoute.withName("Home"));
                                },
                                child: Text("OK"),
                              )
                            ],
                          );
                        });
                  } catch (e) {
                    //   print(e.toString());
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
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
