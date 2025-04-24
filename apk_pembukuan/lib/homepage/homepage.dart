import 'package:apk_pembukuan/penjualan/penjualan.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  final String userName;

  const Homepage({super.key, this.userName = "Nama User"});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages.addAll([
      buildPage("Analisis Keuangan"),
      buildPage("Barang/Jasa"),
      PenjualanPage(),
      buildPage("Piutang"),
      buildPage("Laporan Keuangan"),
    ]);
  }

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
                widget.userName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // untuk halaman profile
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

  final List<BottomNavigationBarItem> _navItems = [
    BottomNavigationBarItem(icon: Icon(Icons.analytics), label: "Analisis"),
    BottomNavigationBarItem(icon: Icon(Icons.inventory), label: "Barang"),
    BottomNavigationBarItem(icon: Icon(Icons.point_of_sale), label: "Penjualan"),
    BottomNavigationBarItem(icon: Icon(Icons.attach_money), label: "Piutang"),
    BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: "Laporan"),
  ];

  @override
  Widget build(BuildContext context) {
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
