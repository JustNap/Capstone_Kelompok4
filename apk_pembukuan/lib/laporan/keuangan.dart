import 'package:flutter/material.dart';

class LaporanKeuanganPage extends StatelessWidget {
  const LaporanKeuanganPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Keuangan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ringkasan Keuangan',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Card(
              elevation: 4,
              child: ListTile(
                leading: Icon(Icons.account_balance_wallet),
                title: Text('Saldo Akhir'),
                subtitle: Text('Rp 10.000.000'),
              ),
            ),
            const SizedBox(height: 16),
            const Card(
              elevation: 4,
              child: ListTile(
                leading: Icon(Icons.arrow_downward, color: Colors.red),
                title: Text('Total Pengeluaran'),
                subtitle: Text('Rp 4.000.000'),
              ),
            ),
            const SizedBox(height: 16),
            const Card(
              elevation: 4,
              child: ListTile(
                leading: Icon(Icons.arrow_upward, color: Colors.green),
                title: Text('Total Pemasukan'),
                subtitle: Text('Rp 6.000.000'),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Grafik dan Analisis',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.blue[50],
              child: const Center(
                child: Text('Grafik Placeholder'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
