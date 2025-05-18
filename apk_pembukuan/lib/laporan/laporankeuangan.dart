import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: FinancialReportPage(),
    debugShowCheckedModeBanner: false,
  ));
}

class FinancialReportPage extends StatefulWidget {
  const FinancialReportPage({super.key});

  @override
  State<FinancialReportPage> createState() => _FinancialReportPageState();
}

class _FinancialReportPageState extends State<FinancialReportPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = 'Mei 2025';
  final List<String> _availablePeriods = [
    'Mei 2025',
    'April 2025',
    'Maret 2025',
    'Februari 2025',
    'Januari 2025',
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Keuangan'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
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
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSummaryTab(),
                _buildDetailTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
 
  Widget _buildSummaryTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildSummaryRow('Total Pendapatan', 'Rp 75.000.000'),
                  _buildSummaryRow('Total Pengeluaran', 'Rp 45.000.000'),
                  const Divider(),
                  _buildSummaryRow('Laba Kotor', 'Rp 30.000.000', color: Colors.green),
                  _buildSummaryRow('Pajak', 'Rp 3.000.000'),
                  const Divider(),
                  _buildSummaryRow('Laba Bersih', 'Rp 27.000.000',
                      color: Colors.blue, isBold: true),
                ],
              ),
            ),
          ),
        ],
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
              style: TextStyle(fontSize: 16, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
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
 
  Widget _buildDetailTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildTransactionSection(
            title: 'Pendapatan',
            isIncome: true,
            transactions: const [
              {'tanggal': '10 Mei 2025', 'deskripsi': 'Penjualan A', 'jumlah': 'Rp 15.000.000'},
              {'tanggal': '08 Mei 2025', 'deskripsi': 'Jasa Konsultasi', 'jumlah': 'Rp 25.000.000'},
              {'tanggal': '05 Mei 2025', 'deskripsi': 'Pembayaran Piutang', 'jumlah': 'Rp 35.000.000'},
            ],
            total: 'Rp 75.000.000',
          ),
          const SizedBox(height: 24),
          _buildTransactionSection(
            title: 'Pengeluaran',
            isIncome: false,
            transactions: const [
              {'tanggal': '09 Mei 2025', 'deskripsi': 'Operasional', 'jumlah': 'Rp 10.000.000'},
              {'tanggal': '07 Mei 2025', 'deskripsi': 'Gaji Karyawan', 'jumlah': 'Rp 25.000.000'},
              {'tanggal': '03 Mei 2025', 'deskripsi': 'Peralatan', 'jumlah': 'Rp 10.000.000'},
            ],
            total: 'Rp 45.000.000',
          ),
        ],
      ),
    );
  }
 
  Widget _buildTransactionSection({
    required String title,
    required bool isIncome,
    required List<Map<String, String>> transactions,
    required String total,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              for (var tx in transactions)
                Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        isIncome ? Icons.arrow_upward : Icons.arrow_downward,
                        color: isIncome ? Colors.green : Colors.red,
                      ),
                      title: Text(tx['deskripsi']!),
                      subtitle: Text(tx['tanggal']!),
                      trailing: Text(
                        tx['jumlah']!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isIncome ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                    if (tx != transactions.last) const Divider(height: 1),
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
                  'Total: $total',
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