import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:z_to_do/addTask.dart';
import 'package:z_to_do/home.dart';

import 'authenticator.dart';
import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  Authenticator auth = Authenticator();

  List<String> fullName;
  String photoUrl;
  FirebaseUser user = await auth.isLoggedIn();
  //print(user.displayName);
  if (user != null) {
    print('not null');
    fullName = user.displayName.split(" ");
    photoUrl = user.photoUrl;
  }

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
      },
    ),
  );
}

//to-do-app-fbc06
