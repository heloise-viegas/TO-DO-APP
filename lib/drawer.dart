import 'package:flutter/material.dart';

import 'constants.dart';

class AppDrawer extends StatelessWidget {
  final Animation progressBarColour =
      new AlwaysStoppedAnimation<Color>(Constants.kTaskItemColour);

  final String userName;
  final String photoUrl;
  AppDrawer({this.userName, this.photoUrl});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.black12.withOpacity(0.5),
        child: Container(
          decoration: BoxDecoration(
            color: Constants.kReusableCardColour,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 80,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 140.0),
                  child: Container(
                    //margin: EdgeInsets.all(10),
                    // padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        width: 1,
                        color: Constants.kIconColour,
                      ),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_rounded,
                        color: Constants.kDrawerBackIcon,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      width: 2,
                      color: Constants.kFabColour,
                    ),
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey,
                    radius: 55,
                    backgroundImage: NetworkImage(photoUrl),
                    //AssetImage('asset/meghan.PNG'),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Text(
                  Constants.kWelcomeText + userName + '!',
                  style: Constants.kWelcomeTextStyle,
                ),
                SizedBox(
                  height: 50,
                ),
                ListTile(
                  title: Text(
                    Constants.kTempTile,
                    style: Constants.kTaskItemStyle,
                  ),
                  leading: Icon(
                    Icons.bookmark_border_outlined,
                    color: Constants.kIconColour,
                    size: 30,
                  ),
                ),
                ListTile(
                  onTap: () {},
                  title: Text(
                    Constants.kCategoryTile,
                    style: Constants.kTaskItemStyle,
                  ),
                  leading: Icon(
                    Icons.category_outlined,
                    color: Constants.kIconColour,
                    size: 30,
                  ),
                ),
                ListTile(
                  title: Text(
                    Constants.kAnalyticsTile,
                    style: Constants.kTaskItemStyle,
                  ),
                  leading: Icon(
                    Icons.pie_chart_outline_outlined,
                    color: Constants.kIconColour,
                    size: 30,
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
                LinearProgressIndicator(
                  backgroundColor: Constants.kProgBarColour,
                  valueColor: progressBarColour,
                  value: 0.7,
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  Constants.kConsistency,
                  style: Constants.kTaskItemStyle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
