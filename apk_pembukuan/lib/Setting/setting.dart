import 'package:flutter/material.dart';
import 'package:apk_pembukuan/pages/reset_password_page.dart';
import 'package:apk_pembukuan/services/auth/auth_gate.dart';
import 'package:apk_pembukuan/services/auth/auth_service.dart';
import '../main.dart';
import './editprofil.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final _auth = AuthService();

  bool isDarkMode = themeNotifier.value == ThemeMode.dark;
  bool receiveNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.greenAccent,
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
            title: const Text("Change Password"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ResetPasswordPage()),
              );
            },
          ),
          const SizedBox(height: 20),
          const Text(
            "PREFERENCES",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 8),

          // Kebijakan Privasi
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text("Privacy Policy"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: _showPrivacyPolicyDialog,
          ),

          // Dark Mode
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

          // Notifications
          SwitchListTile(
            secondary: const Icon(Icons.notifications_none),
            title: const Text("Receive Notifications"),
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

          // Logout
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.greenAccent,
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

  // Pop-up Kebijakan Privasi
  void _showPrivacyPolicyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Kebijakan Privasi",
          style: TextStyle(
            color:Colors.black
          ),
        ),
        content: const SingleChildScrollView(
          child: Text(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
            "Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. "
            "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi "
            "ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit "
            "in voluptate velit esse cillum dolore eu fugiat nulla pariatur.",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Tutup",
              style: TextStyle(
                color:Colors.black
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Logout
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
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Batal", style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            onPressed: () {
              Navigator.of(context).pop();
              _logout(context);
            },
            child: const Text("Logout", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}
