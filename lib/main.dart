import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'file:///D:/FlutterProjects/z_to_do/lib/screens/addTask.dart';
import 'file:///D:/FlutterProjects/z_to_do/lib/screens/allTasks.dart';
import 'file:///D:/FlutterProjects/z_to_do/lib/screens/home.dart';

import 'firebase connections/authenticator.dart';
import 'screens/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  Authenticator auth = Authenticator();
  List<String> fullName;
  String photoUrl;
  FirebaseUser user = await auth.isLoggedIn();
  print('isLogged');
  //print(user.displayName);
  if (user != null) {
    //  print('not null');
    fullName = user.displayName.split(" ");
    photoUrl = user.photoUrl;
  }
  // print('auth');
  //print(auth.isLoggedIn.toString());
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData().copyWith(
          // primaryColorDark: Constants.kBgColour,
          ),

      initialRoute: auth.isLoggedIn != null ? HomeScreen.id : Login.id,

      //Login.id, // HomeScreen.id,
      routes: {
        HomeScreen.id: (context) => HomeScreen(
              userName: fullName.first,
              photoUrl: photoUrl,
            ),
        Task.id: (context) => Task(),
        Login.id: (context) => Login(),
        AllTasks.id: (context) => AllTasks(),
      },
    ),
  );
}

//to-do-app-fbc06
