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

    // print("User:" + user.photoUrl);
    // List<String> fullName = user.displayName.split(" ");
    //user.photoUrl;
    return user;
  }

  //Sign out
  void signOut() {
    _googleSignIn.signOut();
    // print('sign out');
    // print(_googleSignIn.currentUser);
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
      // print('Error saving task:' + e.toString());
    }
  }

  //READ
  Future<dynamic> read() async {
    //  print('read');
    List<Map<String, dynamic>> taskItems = [];
    try {
      CollectionReference _collectionRef = _firestore.collection('tasks');

      // Get docs from collection reference
      //gets all the docs in the collection
      // QuerySnapshot querySnapshot = await _collectionRef.getDocuments();
      //gets all the docs with status=true in the collection
      QuerySnapshot querySnapshot = await _collectionRef
          .where('TaskStatus', isEqualTo: true)
          .where(
            'TaskDate',
            isGreaterThanOrEqualTo: Timestamp.fromDate(
              DateTime.parse(
                DateTime.now().toString().split(" ")[0].toString(),
              ),
            ),
          )
          //.orderBy('TaskDate', descending: true) //TODO:// RESOLVE
          .getDocuments();
      // Get dataId from docs and convert map to List<String>
      final allDataId = querySnapshot.documents.map((doc) {
        return doc.documentID;
      }).toList();
      for (int i = 0; i < allDataId.length; i++) {
        taskItems.add({'TaskId': allDataId[i]});
      }

      // Get data from docs and convert map to List<Map>
      final allData = querySnapshot.documents.map((doc) {
        return doc.data;
      }).toList();
      for (int j = 0; j < allData.length; j++) {
        taskItems[j]['TaskName'] = allData[j]['TaskName'];
        taskItems[j]['TaskComplete'] = allData[j]['TaskComplete'];
        taskItems[j]['TaskDate'] =
            allData[j]['TaskDate'].toDate().toString().substring(0, 10);
      }
    } catch (e) {
      print('Error reading task:' + e.toString());
    }
    return taskItems;
  }

  //UPDATE
  void updateTask(String id, bool isComplete) async {
    try {
      await _firestore.collection('tasks').document(id).updateData(
          {'TaskComplete': isComplete, 'UpdateDate': DateTime.now()});
    } catch (e) {
      print(e);
    }
  }

  //DELETE
  void deleteTask(String id) async {
    try {
      // await _firestore.collection('tasks').document(id).delete(); //hard delete
      await _firestore
          .collection('tasks')
          .document(id)
          .updateData({'TaskStatus': false, 'UpdateDate': DateTime.now()});
    } catch (e) {
      print(e);
    }
  }

  //GET COUNT FOR DAY
  Future<void> getCount() async {
    //TODO: CHECK DAY OF THE WEEK,AND THEN PULL DATA ACCORDINGLY
    print('l');
    int dayOfWeek = DateTime.now().weekday;
    List<Map<String, dynamic>> taskItems = [];

    try {
      CollectionReference _collectionRef = _firestore.collection('tasks');
      //gets all the docs which are not deleted  in the collection
      QuerySnapshot querySnapshot = await _collectionRef
          //   .where('TaskStatus', isEqualTo: true)
          .where(
            'TaskDate',
            isLessThan: Timestamp.fromDate(
              DateTime.parse(
                DateTime.now().toString().split(" ")[0].toString(),
              ),
            ),
          )
          .where(
            'TaskDate',
            isGreaterThanOrEqualTo: Timestamp.fromDate(
              DateTime.parse(
                DateTime.now()
                    .subtract(Duration(days: 2))
                    .toString()
                    .split(" ")[0]
                    .toString(),
              ),
            ),
          )
          .getDocuments();
      //today - nth day of the week
      print(
        DateTime.now()
            .subtract(Duration(days: 2))
            .toString()
            .split(" ")[0]
            .toString(),
      );
      //
      //   // Get dataId from docs and convert map to List<String>
      //   final allDataId = querySnapshot.documents.map((doc) {
      //     return doc.documentID;
      //   }).toList();
      //   for (int i = 0; i < allDataId.length; i++) {
      //     taskItems.add({'TaskId': allDataId[i]});
      //   }
      //
      //   // Get data from docs and convert map to List<Map>
      final allData = querySnapshot.documents.map((doc) {
        return doc.data;
      }).toList();
      for (int j = 0; j < allData.length; j++) {
        taskItems[j]['TaskName'] = allData[j]['TaskName'];
        taskItems[j]['TaskComplete'] = allData[j]['TaskComplete'];
        taskItems[j]['TaskDate'] =
            allData[j]['TaskDate'].toDate().toString().substring(0, 10);
      }
      for (int i = 0; i < taskItems.length; i++) {
        print(DateTime.parse(taskItems[i]['TaskDate']).weekday);
        //.toString().split(" ")[0].toString()
        switch (DateTime.parse(taskItems[i]['TaskDate']).weekday) {
          case 1:
        }
      }

      print(allData);
    } catch (e) {
      //  print('Error saving task:' + e.toString());
    }
    return '';
  }
}
