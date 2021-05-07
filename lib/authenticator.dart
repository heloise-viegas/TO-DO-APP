import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authenticator {
  //for sign in sign out
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

//for CRUD
  final Firestore _firestore = Firestore.instance;

  //Sign In with Google
  Future<FirebaseUser> signInWitGoogle() async {
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    AuthCredential authCredential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    AuthResult authResult =
        await _firebaseAuth.signInWithCredential(authCredential);
    FirebaseUser user = authResult.user;

    print("User:" + user.photoUrl);
    // List<String> fullName = user.displayName.split(" ");
    //user.photoUrl;
    return user;
  }

  //Sign out
  void signOut() {
    _googleSignIn.signOut();
    print('sign out');
    print(_googleSignIn.currentUser);
  }

  //IF LOGGED IN
  Future<dynamic> isLoggedIn() async {
    FirebaseUser loggedInUser = await _firebaseAuth.currentUser();

    if (loggedInUser != null) {
      return loggedInUser;
    } else {
      return null;
    }
  }

//CREATE
  Future<bool> create(Map<String, dynamic> values) async {
    try {
      // await _firestore.collection('tasks').document('tasks').setData(  // over writes data
      await _firestore.collection('tasks').add(
        {
          'TaskName': values['TaskName'],
          'TaskDate': values['TaskDate'],
          'TaskStatus': true,
          'TaskComplete': false,
          'CreateDate': DateTime.now(),
          'UpdateDate': DateTime.now(),
          // 'TaskStatus': values['TaskStatus'],
          // 'TaskComplete': values['TaskComplete'],
          // 'CreateDate': values['CreateDate'],
          // 'UpdateDate': values['UpdateDate'],
        },
      );
      return true;
    } catch (e) {
      print('Error saving task:' + e.toString());
    }
  }

  //READ
  Future<dynamic> read() async {
    print('read');
    // print(_googleSignIn.isSignedIn());
    List<String> taskList = [];

    try {
      CollectionReference _collectionRef = _firestore.collection('tasks');

      // Get docs from collection reference
      QuerySnapshot querySnapshot = await _collectionRef.getDocuments();
      // DocumentReference documentReference= await _collectionRef.document('doc_id').;

      // Get data from docs and convert map to List
      final allData = querySnapshot.documents.map((doc) {
        return doc.data;
      }).toList(); //(doc)=> doc.data

      allData.forEach((task) {
        //print(task['TaskName']);
        taskList.add(task['TaskName']);
      });
      final allDataId = querySnapshot.documents.map((doc) {
        return doc.documentID;
      }).toList();
      allDataId.forEach((taskId) {
        print('taskId');
        print(taskId);
        //taskList.add(task['TaskName']);
      });

      //print(allData);
/////////////////////////////////////
      // StreamBuilder(
      //   stream: Firestore.instance.collection('tasks').snapshots(),
      //   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      //     print('builder');
      //     if (!snapshot.hasData) {
      //       print('1');
      //       return Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     } else {
      //       print('2');
      //       return ListView(
      //         children: snapshot.data.documents.map((document) {
      //           print(document['TaskName']);
      //         }).toList(),
      //       );
      //     }
      //   },
      // );
      //////////////////////////////////////////////
    } catch (e) {
      print('Error saving task:' + e.toString());
    }
    return taskList;
  }

  //UPDATE
  void updateTask() async {
    try {
      //   await _firestore.collection('tasks').document()

    } catch (e) {
      print(e);
    }
  }
}
