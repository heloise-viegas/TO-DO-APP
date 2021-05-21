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
            isEqualTo: Timestamp.fromDate(
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
  Future<List<Map<String, int>>> getCount() async {
    //TODO: CHECK DAY OF THE WEEK,AND THEN PULL DATA ACCORDINGLY
    print('l');
    int dayOfWeek = DateTime.now().weekday;
    List<Map<String, dynamic>> taskItems = [];
    List<Map<String, int>> count = [];
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
            isLessThan: Timestamp.fromDate(
              DateTime.parse(
                DateTime.now().toString().split(" ")[0].toString(),
              ),
            ),
          )
          // .where(
          //   'TaskDate',
          //   isGreaterThanOrEqualTo: Timestamp.fromDate(
          //     DateTime.parse(
          //       DateTime.now()
          //           .subtract(Duration(days: dayOfWeek))
          //           .toString()
          //           .split(" ")[0]
          //           .toString(),
          //     ),
          //   ),
          // )

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
        // print(DateFormat('EEEE').format(allData[j]['TaskDate'].toDate()));
      }
      DateTime dateToCompare = DateTime.parse(
        DateTime.now()
            .subtract(Duration(days: dayOfWeek))
            .toString()
            .substring(0, 10),
      );
      for (int k = 0; k < taskItems.length; k++) {
        if (taskItems[k]['TaskDate']
                .compareTo(dateToCompare.toString().substring(0, 10)) >=
            0) {
          // print("fg");
          //print(DateTime.parse(taskItems[k]['TaskDate']).weekday);
          taskItems[k]['TaskDate'] =
              //taskItems[k]['TaskDate'] +  ':' +
              DateTime.parse(taskItems[k]['TaskDate']).weekday;
        } else {
          print(dateToCompare);
          // taskItems[k]['TaskDate'] =
          //     //taskItems[k]['TaskDate'] +
          //     //     ':' +
          //  DateTime.parse(taskItems[k]['TaskDate']).weekday;
        }
      }

      for (int k = 1; k < 8; k++) {
        count.add({'Day': k});
      }
      for (int q = 0; q < count.length; q++) {
        count[q]['TaskCount'] = 0;
      }
      for (int k = 0; k < taskItems.length; k++) {
        if (taskItems[k]['TaskDate'] == 1) {
          count[0]['TaskCount'] =
              count[0]['TaskCount'] != null ? count[0]['TaskCount'] + 1 : 1;
        } else if (taskItems[k]['TaskDate'] == 2) {
          count[1]['TaskCount'] =
              count[1]['TaskCount'] != null ? count[1]['TaskCount'] + 1 : 1;
        } else if (taskItems[k]['TaskDate'] == 3) {
          count[2]['TaskCount'] =
              count[2]['TaskCount'] != null ? count[2]['TaskCount'] + 1 : 1;
        } else if (taskItems[k]['TaskDate'] == 4) {
          count[3]['TaskCount'] =
              count[3]['TaskCount'] != null ? count[3]['TaskCount'] + 1 : 1;
        } else if (taskItems[k]['TaskDate'] == 5) {
          count[4]['TaskCount'] =
              count[4]['TaskCount'] != null ? count[4]['TaskCount'] + 1 : 1;
        } else if (taskItems[k]['TaskDate'] == 6) {
          count[5]['TaskCount'] =
              count[5]['TaskCount'] != null ? count[5]['TaskCount'] + 1 : 1;
        } else if (taskItems[k]['TaskDate'] == 7) {
          count[6]['TaskCount'] =
              count[6]['TaskCount'] != null ? count[6]['TaskCount'] + 1 : 1;
        }

        //int switchVar = DateTime.parse(taskItems[k]['TaskDate']).weekday;
        // print(switchVar);
        // switch (switchVar) {
        //   case 1:
        //     count[1]['Tasks'] =
        //         count[1]['Tasks'] != null ? count[1]['Tasks'] + taskNo : taskNo;
        //     break;
        //   case 2:
        //     count[1]['Tasks'] =
        //         count[1]['Tasks'] != null ? count[2]['Tasks'] + taskNo : taskNo;
        //     break;
        //   case 3:
        //     count[3]['Tasks'] =
        //         count[3]['Tasks'] != null ? count[3]['Tasks'] + taskNo : taskNo;
        //     break;
        //   case 4:
        //     count[4]['Tasks'] =
        //         count[4]['Tasks'] != null ? count[4]['Tasks'] + taskNo : taskNo;
        //     break;
        //   case 5:
        //     count[5]['Tasks'] =
        //         count[5]['Tasks'] != null ? count[5]['Tasks'] + taskNo : taskNo;
        //     break;
        //   case 6:
        //     count[6]['Tasks'] =
        //         count[6]['Tasks'] != null ? count[6]['Tasks'] + taskNo : taskNo;
        //     break;
        //   case 7:
        //     count[7]['Tasks'] =
        //         count[7]['Tasks'] != null ? count[7]['Tasks'] + taskNo : taskNo;
        //     break;
        //   default:
        //     print('Invalid case');
        //     print(taskItems[k]['TaskDate']);
        //     break;
        // }
      }
      print(taskItems);
      print(count);
    } catch (e) {
      //  print('Error saving task:' + e.toString());
    }
    return count;
  }

  //READ ALL
  Future<dynamic> readAll() async {
    //  print('read');
    List<Map<String, dynamic>> taskItems = [];
    try {
      CollectionReference _collectionRef = _firestore.collection('tasks');

      QuerySnapshot querySnapshot = await _collectionRef
          .where('TaskStatus', isEqualTo: true)
          //     .where(
          //   'TaskDate',
          //   isEqualTo: Timestamp.fromDate(
          //     DateTime.parse(
          //       DateTime.now().toString().split(" ")[0].toString(),
          //     ),
          //   ),
          // )
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
}
