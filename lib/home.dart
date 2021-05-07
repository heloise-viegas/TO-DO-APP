import 'package:flutter/material.dart';
import 'package:z_to_do/addTask.dart';
import 'package:z_to_do/authenticator.dart';

import 'ReusableCard.dart';
import 'ReusableTaskItem.dart';
import 'constants.dart';
import 'drawer.dart';

class HomeScreen extends StatefulWidget {
  static String id = 'HomeScreen';
  String userName;
  String photoUrl;
  HomeScreen({this.userName, this.photoUrl});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

// async {
// print('begin');
// await auth.read();
// print('end');

class _HomeScreenState extends State<HomeScreen> {
  Authenticator auth = Authenticator();
  List<String> items;
  //List<String>.generate(20, (index) => "Daily Meeting ${index + 1}");

  Future<List<String>> getList() async {
    items = await auth.read();
    return items;
  }

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
                  IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Constants.kIconColour,
                      size: Constants.kIconSize,
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close_outlined,
                      color: Constants.kIconColour,
                      size: Constants.kIconSize,
                    ),
                    onPressed: () {
                      auth.signOut();
                      //    Navigator.pushNamed(context, Login.id);
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ),
          ],
        ),
        body: Container(
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
                  height: 150,
                  child: ListView.builder(
                    itemBuilder: (context, int i) {
                      return ReusableCard();
                    },
                    scrollDirection: Axis.horizontal,
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
                        if (!snapshot.hasData) {
                          print('no data');
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } //else {
                        return Container(
                          height: 360,
                          child: ListView.builder(
                            itemCount: items.length,
                            itemBuilder: (context, int i) {
                              final item = items[i];
                              return Dismissible(
                                key: Key(item),
                                //UniqueKey(),
                                onDismissed: (direction) {
                                  setState(() {
                                    items.removeAt(i);
                                  });
                                },
                                child: ReusableTaskItem(
                                  items[i],
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
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, Task.id);
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

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    print('deactivate');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print('dispose');
  }
}
