import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class DatabaseService extends ChangeNotifier {
  String? name;
  String? phone;
  String? userName;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  setNull() {
    name = null;
    phone = null;
    notifyListeners();
  }

//get Profile details
  getProfileDetails() async {
    await FirebaseFirestore.instance
        .collection('patients')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        name = documentSnapshot.get("fullName");
        phone = documentSnapshot.get("phone");
        notifyListeners();
      }
    });
  }

  //get All categories
  static Stream<QuerySnapshot> getAllCategories(BuildContext context) async* {
    yield* FirebaseFirestore.instance.collection("doctors").snapshots();
  }

//get single user field
  Future<void> getUserField(
      String collectionName, String? uid, String fieldName) async {
    debugPrint(uid);
    try {
      userName = null;
      await FirebaseFirestore.instance
          .collection(collectionName)
          .where("uid", isEqualTo: uid)
          .limit(1)
          .get()
          .then((QuerySnapshot snapshot) {
        if (snapshot.docs.isNotEmpty) {
          userName = snapshot.docs.first.get(fieldName);
          notifyListeners();
        } else {
          debugPrint("Document doesnt exist");
        }
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //get  Notifications
  static Stream<QuerySnapshot> notificationCount(
      BuildContext context, bool isRead) async* {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    yield* FirebaseFirestore.instance
        .collection("Notifications")
        .where('toUID', isEqualTo: uid)
        .where('isRead', isEqualTo: isRead)
        .snapshots();
  }

  //get all Doctors
  static Stream<QuerySnapshot> getAllDoctors(
      BuildContext context, String? where, String? searchText) async* {
    yield* FirebaseFirestore.instance
        .collection("doctors")
        .where('specialization', isEqualTo: where)
        .where('fullName', isGreaterThanOrEqualTo: searchText)
        .snapshots();
  }

//check if patient
  static Future<bool?> isPatient() async {
    bool? isPatient = await _firestore
        .collection('patients')
        .get()
        .then((QuerySnapshot snapshot) {
      for (var a in snapshot.docs) {
        if (a.get('uid') == _auth.currentUser?.uid) {
          return true;
        } else {
          return false;
        }
      }
      return null;
    }).catchError((error, stackrace) {
      debugPrint(stackrace);
      return false;
    });

    return isPatient;
  }

  //Set all notifiations read
  static Future<void> setAllRead() async {
    //await _firestore.batch().update(_firestore.collection('Notifications').where('toUID' , isEqualTo: _auth.currentUser?.uid)., data)
    await _firestore
        .collection("Notifications")
        .where('toUID', isEqualTo: _auth.currentUser?.uid)
        .get()
        .then((value) {
      for (var doc in value.docs) {
        doc.reference.update({"isRead": true});
      }
    });
  }

//add Profile pic url to firestore
  static Future<void> addImageUrl(String url) async {
    await _auth.currentUser?.updatePhotoURL(url).then((value) async {
      await _firestore
          .collection('patients')
          .doc(_auth.currentUser?.uid)
          .update({"profilePic": url});
    }).catchError((error, stackrace) {
      debugPrint(stackrace);
    });
  }

//get profile pic url
  static Future<String> getImage() async {
    String url = await _firestore
        .collection('patients')
        .doc(_auth.currentUser?.uid)
        .get()
        .then((value) {
      return value.get("profilePic");
    });

    return url;
  }

  static Stream<QuerySnapshot> getMyCareTeam(BuildContext context) async* {
    FirebaseAuth _auth = FirebaseAuth.instance;
    yield* FirebaseFirestore.instance
        .collection("care_team")
        .where('uid', isEqualTo: _auth.currentUser?.uid)
        .snapshots();
  }
}
