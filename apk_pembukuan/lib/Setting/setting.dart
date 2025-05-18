import 'package:apk_pembukuan/services/auth/auth_gate.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import './editprofil.dart';
import 'package:apk_pembukuan/services/auth/auth_service.dart';


class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final _auth = AuthService();

  bool isDarkMode = themeNotifier.value == ThemeMode.dark;
  bool receiveNotifications = true;
  bool playInBackground = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "ACCOUNTS",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text("Edit Profile"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditProfilePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text("Change password"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          const SizedBox(height: 20),
          const Text(
            "PREFERENCES",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text("Language"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          SwitchListTile(
            secondary: const Icon(Icons.brightness_6_outlined),
            title: const Text("Dark Mode"),
            value: isDarkMode,
            onChanged: (val) {
              setState(() {
                isDarkMode = val;
                themeNotifier.value = val ? ThemeMode.dark : ThemeMode.light;
              });
            },
          ),
          SwitchListTile(
            secondary: const Icon(Icons.notifications_none),
            title: const Text("Received Notifications"),
            value: receiveNotifications,
            onChanged: (val) {
              setState(() {
                receiveNotifications = val;
              });
            },
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: () => _confirmLogout(context),
            icon: const Icon(Icons.logout, color: Colors.black),
            label: const Text(
              "Logout",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _logout(BuildContext context) async {
    try {
      await _auth.logout();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => AuthGate()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal logout: $e")),
      );
    }
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi"),
        content: const Text("Apakah Anda yakin ingin logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Tutup dialog
            child: const Text(
              "Batal",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
            onPressed: () {
              Navigator.of(context).pop(); // Tutup dialog
              _logout(context); // Lanjut logout
            },
            child: const Text(
              "Logout",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
