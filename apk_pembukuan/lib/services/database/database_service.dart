/*
  DATABASE SERVICE
*/

import 'package:apk_pembukuan/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  // get instance of firestore db & auth
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  /*
    USER PROFILE
  */

  // save user info
  Future<void> saveUserInfoInFirebase(
      {required String name, required String email}) async {
    // get current uid
    String uid = _auth.currentUser!.uid;

    // extract username from email
    String username = email.split('@')[0];

    // create a user profile
    UserProfile user = UserProfile(
      uid: uid,
      name: name,
      email: email,
      username: username,
      no_hp: '',
    );

    // convert user into a map
    final userMap = user.toMap();

    // save user info in firebase
    await _db.collection("Users").doc(uid).set(userMap);
  }

  // get user info
  Future<UserProfile?> getUserFromFirebase(String uid) async {
    try {
      // retrieve user doc from firebase
      DocumentSnapshot userDoc = await _db.collection("Users").doc(uid).get();

      // convert doc to user profile
      return UserProfile.fromDocument(userDoc);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> tambahPenjualan(String uid, Map<String, dynamic> data) async {
    await _db.collection('Users').doc(uid).collection('penjualan').add({
      ...data,
      'tanggal': DateTime.now(),
    });
  }

  Future<List<Map<String, dynamic>>> getPenjualan(String uid) async {
    final snapshot = await _db.collection('Users').doc(uid).collection('penjualan').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['docId'] = doc.id;
      return data;
    }).toList();
  }

  Future<void> hapusPenjualan(String uid, String docId) async {
    await _db.collection('Users').doc(uid).collection('penjualan').doc(docId).delete();
  }

}  