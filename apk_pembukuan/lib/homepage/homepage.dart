import 'package:flutter/material.dart';

class Homepage extends StatelessWidget {
  final String userName;

  const Homepage({super.key, this.userName = "Nama User"});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                  GestureDetector(
                    onTap: () {

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
      onTap: () {
      
      },
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
