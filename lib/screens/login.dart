import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'file:///D:/FlutterProjects/z_to_do/lib/screens/home.dart';

import '../firebase connections/authenticator.dart';
import '../ui components/constants.dart';

class Login extends StatelessWidget {
  static String id = 'LoginScreen';
  final Authenticator auth = Authenticator();
  FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    //  print('login init');
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: GestureDetector(
            onTap: () async {
              try {
                user = await auth.signInWitGoogle();
                List<String> fullName = user.displayName.split(" ");
                String photoUrl = user.photoUrl;
                // Navigator.pushReplacement(
                //     context,
                //     MaterialPageRoute(
                //       settings: RouteSettings(
                //           name: "Home"), //used for pop until in Add task screen
                //       builder: (context) {
                //         return HomeScreen(
                //           userName: fullName.first,
                //           photoUrl: photoUrl,
                //         );
                //       },
                //     ));
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return HomeScreen(
                    userName: fullName.first,
                    photoUrl: photoUrl,
                  );
                }));
              } catch (e) {
                //     print(e.toString());
              }
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Constants.kReusableCardColour,
              ),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image(
                    image: AssetImage("asset/google_logo.png"),
                    height: 35.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      Constants.kSignInBtn,
                      style: Constants.kSignInBtnStyle,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
