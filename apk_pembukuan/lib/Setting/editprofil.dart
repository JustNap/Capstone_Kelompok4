import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String name = "Capstone Kelompok 4";
  String gender = "Male";
  String email = "capstone_kelompok4@gmail.com";
  String birthDate = "2025-01-01";

  final TextEditingController nameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();

  void _showEditDialog() {
    nameController.text = name;
    genderController.text = gender;
    emailController.text = email;
    birthDateController.text = birthDate;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Profil'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: genderController,
                decoration: const InputDecoration(labelText: "Gender"),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              TextField(
                controller: birthDateController,
                decoration: const InputDecoration(labelText: "Tanggal Lahir"),
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
            onPressed: () {
              setState(() {
                name = nameController.text;
                gender = genderController.text;
                email = emailController.text;
                birthDate = birthDateController.text;
              });
              Navigator.pop(context);
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
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            color: Colors.grey.shade200,
            child: const Text("BASIC INFORMATION", style: TextStyle(color: Colors.grey)),
          ),
          ListTile(
            title: const Text("Name"),
            subtitle: Text(name),
          ),
          ListTile(
            title: const Text("Gender"),
            subtitle: Text(gender),
          ),
          ListTile(
            title: const Text("Email"),
            subtitle: Text(email),
          ),
          ListTile(
            title: const Text("Tanggal Lahir"),
            subtitle: Text(birthDate),
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
