import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FinancialReportPage extends StatefulWidget {
  const FinancialReportPage({super.key});

  @override
  State<FinancialReportPage> createState() => _FinancialReportPageState();
}

class _FinancialReportPageState extends State<FinancialReportPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = 'Juni 2025';

  final List<String> _availablePeriods = [
    'Januari 2025', 'Februari 2025', 'Maret 2025',
    'April 2025', 'Mei 2025', 'Juni 2025',
    'Juli 2025', 'Agustus 2025', 'September 2025',
    'Oktober 2025', 'November 2025', 'Desember 2025',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> _getMutasiKas(String bulanTahun) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final snapshot = await FirebaseFirestore.instance
        .collection("Users")
        .doc(uid)
        .collection("MutasiKas")
        .orderBy("tanggal", descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).where((data) {
      final tanggal = (data['tanggal'] as Timestamp).toDate();
      final bulan = _monthName(tanggal.month);
      final tahun = tanggal.year.toString();
      return "$bulan $tahun" == bulanTahun;
    }).toList();
  }

  String _monthName(int month) {
    const months = [
      "", "Januari", "Februari", "Maret", "April", "Mei",
      "Juni", "Juli", "Agustus", "September", "Oktober", "November", "Desember"
    ];
    return months[month];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Keuangan',
          style: TextStyle(
          color: Colors.black,
              ),
        ),
        backgroundColor: Colors.greenAccent,
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.black54,
          indicatorColor: Colors.blue,
          tabs: const [
            Tab(text: 'Ringkasan'),
            Tab(text: 'Rincian'),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Text('Periode:', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _selectedPeriod,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedPeriod = value;
                      });
                    }
                  },
                  items: _availablePeriods
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _getMutasiKas(_selectedPeriod),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final data = snapshot.data ?? [];

                return TabBarView(
                  controller: _tabController,
                  children: [
                    _buildSummaryTab(data),
                    _buildDetailTab(data),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryTab(List<Map<String, dynamic>> data) {
    final pemasukan = data
        .where((item) => item['jenis'] == 'masuk')
        .fold(0.0, (sum, item) => sum + (item['jumlah'] as num).toDouble());
    final pengeluaran = data
        .where((item) => item['jenis'] == 'keluar')
        .fold(0.0, (sum, item) => sum + (item['jumlah'] as num).toDouble());
    final labaKotor = pemasukan - pengeluaran;
    final pajak = labaKotor * 0.10;
    final labaBersih = labaKotor - pajak;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildSummaryRow('Total Pendapatan', 'Rp ${pemasukan.toStringAsFixed(0)}'),
              _buildSummaryRow('Total Pengeluaran', 'Rp ${pengeluaran.toStringAsFixed(0)}'),
              const Divider(),
              _buildSummaryRow('Laba Kotor', 'Rp ${labaKotor.toStringAsFixed(0)}', color: Colors.green),
              _buildSummaryRow('Pajak (10%)', 'Rp ${pajak.toStringAsFixed(0)}'),
              const Divider(),
              _buildSummaryRow('Laba Bersih', 'Rp ${labaBersih.toStringAsFixed(0)}', color: Colors.blue, isBold: true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String title, String value,
      {Color? color, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: color,
              )),
        ],
      ),
    );
  }

  Widget _buildDetailTab(List<Map<String, dynamic>> data) {
    final pemasukan = data.where((item) => item['jenis'] == 'masuk').toList();
    final pengeluaran = data.where((item) => item['jenis'] == 'keluar').toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildTransactionSection(
            title: 'Pendapatan',
            isIncome: true,
            transactions: pemasukan,
          ),
          const SizedBox(height: 24),
          _buildTransactionSection(
            title: 'Pengeluaran',
            isIncome: false,
            transactions: pengeluaran,
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionSection({
    required String title,
    required bool isIncome,
    required List<Map<String, dynamic>> transactions,
  }) {
    double total = transactions.fold(0.0,
        (sum, item) => sum + (item['jumlah'] as num).toDouble());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              for (var i = 0; i < transactions.length; i++)
                Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        isIncome ? Icons.arrow_upward : Icons.arrow_downward,
                        color: isIncome ? Colors.green : Colors.red,
                      ),
                      title: Text(transactions[i]['deskripsi']),
                      subtitle: Text(
                        (transactions[i]['tanggal'] as Timestamp)
                            .toDate()
                            .toLocal()
                            .toString()
                            .split(' ')[0],
                      ),
                      trailing: Text(
                        'Rp ${transactions[i]['jumlah'].toStringAsFixed(0)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isIncome ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                    if (i != transactions.length - 1) const Divider(height: 1),
                  ],
                ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Text(
                  'Total: Rp ${total.toStringAsFixed(0)}',
                  textAlign: TextAlign.end,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
