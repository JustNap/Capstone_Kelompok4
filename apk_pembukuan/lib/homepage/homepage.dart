import 'package:apk_pembukuan/Piutang/piutang.dart';
import 'package:apk_pembukuan/Setting/setting.dart';
import 'package:apk_pembukuan/models/user.dart';
import 'package:apk_pembukuan/pages/login_page.dart';
import 'package:apk_pembukuan/penjualan/penjualan.dart';
import 'package:apk_pembukuan/services/auth/auth_service.dart';
import 'package:apk_pembukuan/services/database/database_service.dart';
import 'package:apk_pembukuan/stock/stock_page.dart';
import 'package:apk_pembukuan/laporan/laporankeuangan.dart';
import 'package:flutter/material.dart';


class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final _auth = AuthService();
  final _db = DatabaseService();
  UserProfile? user;

  @override
  void initState() {
    super.initState();
    _loadUserData(); // ini akan memanggil setState saat user selesai dimuat
  }

  void _loadUserData() async {
    String uid = _auth.getCurrentUid();
    UserProfile? fetchedUser = await _db.getUserFromFirebase(uid);
    if (mounted) {
      setState(() {
        user = fetchedUser;
        _pages.addAll([
          buildPage("Analisis Keuangan"),
          StockPage(),
          PenjualanPage(),
          PiutangPage(),
          buildPage("Laporan Keuangan"),
        ]);
      });
    }
  }

  void logout(BuildContext context) async {
    try {
      await _auth.logout();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage(onTap: () {})),
      );
    } catch (e) {
      print("Error saat logout: $e");
    }
  }

  int _currentIndex = 0;

  final List<Widget> _pages = [];

  Widget buildPage(String title) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                user!.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SettingPage()),
                  );
                },
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
          const SizedBox(height: 20),
          // Konten utama halaman
          Expanded(
            child: Center(
              child: Text(
                "Halaman $title",
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showProfileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Profil'),
                onTap: () {
                  print("Profil dipilih");
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () {
                  logout(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  final List<BottomNavigationBarItem> _navItems = [
    BottomNavigationBarItem(icon: Icon(Icons.analytics), label: "Analisis"),
    BottomNavigationBarItem(icon: Icon(Icons.inventory), label: "Barang"),
    BottomNavigationBarItem(
        icon: Icon(Icons.point_of_sale), label: "Penjualan"),
    BottomNavigationBarItem(icon: Icon(Icons.attach_money), label: "Piutang"),
    BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: "Laporan"),
  ];

  @override
  Widget build(BuildContext context) {
    if (user == null || _pages.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: _pages[_currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: _navItems,
      ),
    );
  }
}
