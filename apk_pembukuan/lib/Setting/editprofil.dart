import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:apk_pembukuan/services/database/database_service.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _auth = FirebaseAuth.instance;
  final DatabaseService _dbService = DatabaseService();

  String name = '';
  String email = '';
  String username = '';
  String noHp = '';

  final TextEditingController nameController = TextEditingController();
  final TextEditingController noHpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final uid = _auth.currentUser?.uid;
    if (uid != null) {
      final user = await _dbService.getUserFromFirebase(uid);
      if (user != null) {
        setState(() {
          name = user.name;
          email = user.email;
          username = user.username;
          noHp = user.no_hp;
        });
      }
    }
  }

  void _showEditDialog() {
    nameController.text = name;
    noHpController.text = noHp;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Profil'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Nama"),
              ),
              TextField(
                controller: noHpController,
                decoration: const InputDecoration(labelText: "No. HP"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              final uid = _auth.currentUser?.uid;
              if (uid != null) {
                await FirebaseFirestore.instance.collection("Users").doc(uid).update({
                  'name': nameController.text,
                  'no_hp': noHpController.text,
                });

                setState(() {
                  name = nameController.text;
                  noHp = noHpController.text;
                });

                Navigator.pop(context);
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: Colors.greenAccent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            color: Colors.grey.shade200,
            child: const Text("INFORMASI PROFIL", style: TextStyle(color: Colors.grey)),
          ),
          ListTile(
            title: const Text("Nama"),
            subtitle: Text(name),
          ),
          ListTile(
            title: const Text("Email"),
            subtitle: Text(email),
          ),
          ListTile(
            title: const Text("Username"),
            subtitle: Text(username),
          ),
          ListTile(
            title: const Text("No. HP"),
            subtitle: Text(noHp),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _showEditDialog,
            icon: const Icon(Icons.edit),
            label: const Text("Edit Profil"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ],
      ),
    );
  }
}
