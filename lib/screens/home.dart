import 'package:flutter/material.dart';

import 'file:///D:/FlutterProjects/z_to_do/lib/firebase%20connections/authenticator.dart';
import 'file:///D:/FlutterProjects/z_to_do/lib/screens/addTask.dart';
import 'file:///D:/FlutterProjects/z_to_do/lib/screens/login.dart';

import '../ui components/ReusableCard.dart';
import '../ui components/ReusableTaskItem.dart';
import '../ui components/constants.dart';
import '../ui components/drawer.dart';

const List<String> days = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday'
];

Authenticator auth = Authenticator();
// List<String> items;
List<Map<String, dynamic>> items;
List<Map<String, dynamic>> tasksPerDay;
//List<String>.generate(20, (index) => "Daily Meeting ${index + 1}");

Future<List<Map<String, dynamic>>> getList() async {
  items = await auth.read();
  return items;
}

Future<List<Map<String, dynamic>>> getTaskCount() async {
  tasksPerDay = await auth.getCount();
  return tasksPerDay;
}

class HomeScreen extends StatelessWidget {
  static String id = 'HomeScreen';
  final String userName;
  final String photoUrl;
  HomeScreen({this.userName, this.photoUrl});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              return HomePortrait(
                userName: userName,
                photoUrl: photoUrl,
              );
            } else {
              return HomeLandscape(
                userName: userName,
                photoUrl: photoUrl,
              );
            }
          },
        ),
      ),
    );
  }
}

class HomePortrait extends StatefulWidget {
  //static String id = 'HomeScreen';
  final String userName;
  final String photoUrl;
  HomePortrait({this.userName, this.photoUrl});

  @override
  _HomePortraitState createState() => _HomePortraitState();
}

class _HomePortraitState extends State<HomePortrait> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Constants.kBgColour,
        //   extendBodyBehindAppBar: true, //to make appbar same as body
        drawer: AppDrawer(
          userName: widget.userName,
          photoUrl: widget.photoUrl,
        ),
        appBar: AppBar(
          backgroundColor: Constants.kBgColour, //to make appbar same as body
          elevation: 0, //to make appbar same as body
          // leading: Padding(
          //   padding: const EdgeInsets.only(left: 25),
          //   child: IconButton(
          //     icon: Icon(
          //       Icons.format_list_bulleted,
          //       color: Constants.kIconColour,
          //       size: Constants.kIconSize,
          //     ),
          //     onPressed: () {},
          //   ),
          // ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 25),
              child: Row(
                children: [
                  // IconButton(
                  //   icon: Icon(
                  //     Icons.search,
                  //     color: Constants.kIconColour,
                  //     size: Constants.kIconSize,
                  //   ),
                  //   onPressed: () {},
                  // ),
                  IconButton(
                    icon: Icon(
                      Icons.close_outlined,
                      color: Constants.kIconColour,
                      size: Constants.kIconSize,
                    ),
                    onPressed: () {
                      auth.signOut();
                      // Navigator.pop(context);
                      //    Navigator.pushNamed(context, Login.id);

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => Login(),
                        ),
                        (route) => false,
                      );
                    },
                  )
                ],
              ),
            ),
          ],
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Constants.kBgColour,
          child: Padding(
            padding: const EdgeInsets.only(left: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 20),
                  child: Text(
                    Constants.kWelcomeText + widget.userName + '!',
                    style: Constants.kWelcomeTextStyle,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 40.0,
                    left: 10,
                    bottom: 20,
                  ),
                  child: Text(
                    Constants.kLblCategory,
                    style: Constants.kLblCategoryStyle,
                  ),
                ),
                Container(
                  height: 150, //MediaQuery.of(context).size.height / 6,
                  child: FutureBuilder(
                    future: getTaskCount(),
                    builder: (context, AsyncSnapshot snapshot) {
                      return ListView.builder(
                        itemCount: days.length,
                        itemBuilder: (context, int i) {
                          if (!snapshot.hasData) {
                            //  print('no data');
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return ReusableCard(
                            cardDay: days[i],
                            count: tasksPerDay[i][
                                'TaskCount'], //error on i==0 since in map there is no 0
                          );
                        },
                        scrollDirection: Axis.horizontal,
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 40.0,
                    left: 10,
                    bottom: 20,
                  ),
                  child: Text(
                    Constants.kLblToday,
                    style: Constants.kLblCategoryStyle,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 25),
                  child: FutureBuilder(
                      future: getList(),
                      builder: (context, AsyncSnapshot snapshot) {
                        // if (snapshot.connectionState != ConnectionState.done) {
                        //   //   print('Connection State');
                        //   // return Center(
                        //   //   child: CircularProgressIndicator(),
                        //   // );
                        // }
                        //!snapshot.hasData is not reset only connection state is reset when there are changes hence reload works with connection state
                        if (!snapshot.hasData) {
                          //  print('no data');
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } //else {
                        return Container(
                          height:
                              MediaQuery.of(context).size.height / 2.3, //360,
                          child: ListView.builder(
                            itemCount: items.length,
                            itemBuilder: (context, int i) {
                              final item = items[i]['TaskId'];

                              return Dismissible(
                                key: Key(item),
                                //UniqueKey(),
                                onDismissed: (direction) {
                                  setState(() {
                                    //delete from db
                                    auth.deleteTask(items[i]['TaskId']);
                                    items.removeAt(i);
                                  });
                                },
                                child: ReusableTaskItem(
                                  items[i]['TaskId'],
                                  items[i]['TaskName'],
                                  items[i]['TaskComplete'],
                                  items[i]['TaskDate'],
                                ),
                              );
                              // }
                            },
                            scrollDirection: Axis.vertical,
                          ),
                        );
                        // }
                      }),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          //then is used to update the list when we return from task screen
          onPressed: () {
            Navigator.pushNamed(context, Task.id).then(
              (value) => setState(() {
                getList();
              }),
            );
          },
          child: Icon(
            Icons.add,
            size: 35,
          ),
          backgroundColor: Constants.kFabColour,
        ),
      ),
    );
  }
}

class HomeLandscape extends StatefulWidget {
  //static String id = 'HomeScreen';
  final String userName;
  final String photoUrl;
  HomeLandscape({this.userName, this.photoUrl});

  @override
  _HomeLandscapeState createState() => _HomeLandscapeState();
}

class _HomeLandscapeState extends State<HomeLandscape> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.kBgColour,
      //   extendBodyBehindAppBar: true, //to make appbar same as body
      drawer: AppDrawer(
        userName: widget.userName,
        photoUrl: widget.photoUrl,
      ),
      appBar: AppBar(
        title: Text(
          Constants.kWelcomeText + widget.userName + '!',
          style: Constants.kWelcomeTextStyle,
        ),
        backgroundColor: Constants.kBgColour, //to make appbar same as body
        elevation: 0, //to make appbar same as body
        // leading: Padding(
        //   padding: const EdgeInsets.only(left: 25),
        //   child: IconButton(
        //     icon: Icon(
        //       Icons.format_list_bulleted,
        //       color: Constants.kIconColour,
        //       size: Constants.kIconSize,
        //     ),
        //     onPressed: () {},
        //   ),
        // ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 25),
            child: Row(
              children: [
                // IconButton(
                //   icon: Icon(
                //     Icons.search,
                //     color: Constants.kIconColour,
                //     size: Constants.kIconSize,
                //   ),
                //   onPressed: () {},
                // ),
                IconButton(
                  icon: Icon(
                    Icons.close_outlined,
                    color: Constants.kIconColour,
                    size: Constants.kIconSize,
                  ),
                  onPressed: () {
                    auth.signOut();
                    // Navigator.pop(context);
                    //    Navigator.pushNamed(context, Login.id);

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => Login(),
                      ),
                      (route) => false,
                    );
                  },
                )
              ],
            ),
          ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Constants.kBgColour,
        child: Padding(
          padding: const EdgeInsets.only(left: 25),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  child: Column(
                    children: [
                      // Padding(
                      //   padding: const EdgeInsets.only(
                      //     left: 10.0,
                      //   ),
                      //   child:
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 20.0,
                          left: 10,
                          bottom: 20,
                        ),
                        child: Text(
                          Constants.kLblCategory,
                          style: Constants.kLblCategoryStyle,
                        ),
                      ),
                      Container(
                        height: 225, //MediaQuery.of(context).size.height / 6,
                        child: FutureBuilder(
                            future: getTaskCount(),
                            builder: (context, AsyncSnapshot snapshot) {
                              if (!snapshot.hasData) {
                                //  print('no data');
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return ListView.builder(
                                itemCount: days.length,
                                itemBuilder: (context, int i) {
                                  return ReusableCard(
                                    cardDay: days[i],
                                    count: tasksPerDay[i][
                                        'TaskCount'], //error on i==0 since in map there is no 0
                                  );
                                },
                                scrollDirection: Axis.vertical,
                              );
                            }),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                    child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 20.0,
                        left: 10,
                        bottom: 20,
                      ),
                      child: Text(
                        Constants.kLblToday,
                        style: Constants.kLblCategoryStyle,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 25),
                      child: FutureBuilder(
                          future: getList(),
                          builder: (context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState !=
                                ConnectionState.done) {
                              //     print('Connection State');
                              // return Center(
                              //   child: CircularProgressIndicator(),
                              // );
                            }
                            //!snapshot.hasData is not reset only connection state is reset when there are changes hence reload works with connection state
                            if (!snapshot.hasData) {
                              //   print('no data');
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } //else {
                            return Container(
                              height: 225,
                              //MediaQuery.of(context).size.height / 2.2, //360,
                              child: ListView.builder(
                                itemCount: items.length,
                                itemBuilder: (context, int i) {
                                  final item = items[i]['TaskId'];
                                  return Dismissible(
                                    key: Key(item),
                                    //UniqueKey(),
                                    onDismissed: (direction) {
                                      setState(() {
                                        //delete from db
                                        auth.deleteTask(items[i]['TaskId']);
                                        items.removeAt(i);
                                      });
                                    },
                                    child: ReusableTaskItem(
                                      items[i]['TaskId'],
                                      items[i]['TaskName'],
                                      items[i]['TaskComplete'],
                                      items[i]['TaskDate'],
                                    ),
                                  );
                                },
                                scrollDirection: Axis.vertical,
                              ),
                            );
                            // }
                          }),
                    ),
                  ],
                )),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        //then is used to update the list when we return from task screen
        onPressed: () {
          Navigator.pushNamed(context, Task.id).then(
            (value) => setState(() {
              getList();
            }),
          );
        },
        child: Icon(
          Icons.add,
          size: 35,
        ),
        backgroundColor: Constants.kFabColour,
      ),
    );
  }
}
