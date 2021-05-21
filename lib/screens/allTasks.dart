import 'package:flutter/material.dart';

import 'file:///D:/FlutterProjects/z_to_do/lib/ui%20components/ReusableTaskItem.dart';

import '../ui components/constants.dart';
import 'home.dart';
import 'login.dart';

List<Map<String, dynamic>> items;
Future<List<Map<String, dynamic>>> getList() async {
  items = await auth.readAll();
  return items;
}

class AllTasks extends StatelessWidget {
  static String id = 'AllTasksScreen';
  @override
  Widget build(BuildContext context) {
    print('qwerty');
    return SafeArea(
        child: Scaffold(
      backgroundColor: Constants.kBgColour,
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
        title: Text(
          Constants.kAppBarTitle,
          style: Constants.kLblCategoryStyle,
        ),
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
                height: MediaQuery.of(context).size.height, //360,
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, int i) {
                    return ReusableTaskItem(
                      items[i]['TaskId'],
                      items[i]['TaskName'],
                      items[i]['TaskComplete'],
                    );
                    // }
                  },
                  scrollDirection: Axis.vertical,
                ),
              );
              // }
            }),
        //color: Colors.white,
      ),
    ));
  }
}
