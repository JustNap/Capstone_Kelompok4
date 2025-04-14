import 'package:flutter/material.dart';
import 'package:apk_pembukuan/services/auth/auth_service.dart';
import 'package:apk_pembukuan/pages/login_page.dart';

class Homepage extends StatelessWidget {
  final String userName;

  const Homepage({super.key, this.userName = "Nama User"});

  // Fungsi untuk logout
  void logout(BuildContext context) async {
    try {
      // Panggil logout dari AuthService
      await AuthService().logout();

      // Redirect ke halaman login setelah logout
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(onTap: () {}),
        ),
      );
    } catch (e) {
      print("Error saat logout: $e");
    }
  }

  // Fungsi untuk menampilkan bottom sheet dengan opsi
  void _showProfileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Pilihan menu (misalnya Profil)
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Profil'),
                onTap: () {
                  // Aksi saat pilih profil
                  print("Profil dipilih");
                },
              ),
              const Divider(),
              // Pilihan logout
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () {
                  // Panggil fungsi logout
                  logout(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Homepage"),
        actions: [
          GestureDetector(
            onTap: () => _showProfileMenu(
                context), // Tampilkan menu saat logo profil ditekan
            child: CircleAvatar(
              backgroundColor: Colors.blueAccent.withOpacity(0.15),
              radius: 24,
              child: const Icon(
                Icons.person,
                size: 28,
                color: Colors.blueAccent,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildMenuItem(Icons.receipt_long, 'Laporan Keuangan'),
                    _buildMenuItem(Icons.inventory, 'Barang/Jasa'),
                    _buildMenuItem(Icons.point_of_sale, 'Penjualan'),
                    _buildMenuItem(Icons.attach_money, 'Piutang'),
                    _buildMenuItem(Icons.analytics, 'Analisis Keuangan'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label) {
    return GestureDetector(
      onTap: () {},
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.blueAccent),
            const SizedBox(height: 12),
            Text(label, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
