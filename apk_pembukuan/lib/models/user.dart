/*

USER PROFILE

- uid
- name
- email
- username
- no_hp
- profile photo

*/

import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final String name;
  final String email;
  final String username;
  final String no_hp;

  UserProfile({
    required this.uid,
    required this.name,
    required this.email,
    required this.username,
    required this.no_hp,
  });

  // firebase -> app
  // convert firestore document to a user profile (agar bisa dipakai di-app)
  factory UserProfile.fromDocument(DocumentSnapshot doc) {
    return UserProfile(
      uid: doc['uid'],
      name: doc['name'],
      email: doc['email'],
      username: doc['username'],
      no_hp: doc['no_hp'],
    );
  }

  // app -> firebase
  // convert a user profile to a map (agar bisa disimpan di firebase)
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'username': username,
      'no_hp': no_hp,
    };
  }
}
