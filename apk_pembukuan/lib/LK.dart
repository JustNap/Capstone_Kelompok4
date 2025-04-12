import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LaporanKeuanganPage extends StatefulWidget {
  const LaporanKeuanganPage({Key? key}) : super(key: key);

  @override
  State<LaporanKeuanganPage> createState() => _LaporanKeuanganPageState();
}

class _LaporanKeuanganPageState extends State<LaporanKeuanganPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTimeRange _dateRange = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 30)),
    end: DateTime.now(),
  );
  
  final formatCurrency = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  // Data hardcode untuk laporan keuangan (sementara)
  final List<Map<String, dynamic>> _transaksiList = [
    {
      'tanggal': '10 Apr 2025',
      'keterangan': 'Penjualan Produk A', 
      'debit': 0,
      'kredit': 2500000,
      'kategori': 'Penjualan',
    },
    {
      'tanggal': '09 Apr 2025',
      'keterangan': 'Pembayaran Supplier', 
      'debit': 1500000,
      'kredit': 0,
      'kategori': 'Beban Operasional',
    },
    {
      'tanggal': '08 Apr 2025',
      'keterangan': 'Penjualan Produk B', 
      'debit': 0,
      'kredit': 1850000,
      'kategori': 'Penjualan',
    },
    {
      'tanggal': '07 Apr 2025',
      'keterangan': 'Pembayaran Listrik', 
      'debit': 450000,
      'kredit': 0,
      'kategori': 'Beban Utilitas',
    },
    {
      'tanggal': '05 Apr 2025',
      'keterangan': 'Pembayaran Sewa', 
      'debit': 2000000,
      'kredit': 0,
      'kategori': 'Beban Operasional',
    },
  ];

  final Map<String, double> _ringkasanKeuangan = {
    'totalPendapatan': 4350000,
    'totalPengeluaran': 3950000,
    'saldoAkhir': 400000,
    'piutang': 1250000,
    'hutang': 750000
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: _dateRange,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blue,
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != _dateRange) {
      setState(() {
        _dateRange = picked;
      });
    }
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
            Tab(text: 'Transaksi'),
            Tab(text: 'Grafik'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: _selectDateRange,
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRingkasanTab(),
          _buildTransaksiTab(),
          _buildGrafikTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigasi ke halaman tambah transaksi
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tambah transaksi baru')),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildRingkasanTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDateRangeDisplay(),
          const SizedBox(height: 16),
          _buildInfoCard(
            title: 'Ringkasan Keuangan',
            color: Colors.blue.shade50,
            children: [
              _buildInfoRow('Total Pendapatan', _ringkasanKeuangan['totalPendapatan']!, Colors.green),
              _buildInfoRow('Total Pengeluaran', _ringkasanKeuangan['totalPengeluaran']!, Colors.red),
              const Divider(),
              _buildInfoRow('Laba/Rugi', _ringkasanKeuangan['saldoAkhir']!, 
                _ringkasanKeuangan['saldoAkhir']! >= 0 ? Colors.green : Colors.red),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            title: 'Hutang & Piutang',
            color: Colors.orange.shade50,
            children: [
              _buildInfoRow('Total Piutang', _ringkasanKeuangan['piutang']!, Colors.blue),
              _buildInfoRow('Total Hutang', _ringkasanKeuangan['hutang']!, Colors.orange),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            title: 'Aksi Cepat',
            color: Colors.purple.shade50,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Cetak laporan
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cetak laporan')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Cetak Laporan'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  // Ekspor ke Excel
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ekspor ke Excel')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Ekspor ke Excel'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransaksiTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildDateRangeDisplay(),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _transaksiList.length,
            itemBuilder: (context, index) {
              final transaksi = _transaksiList[index];
              final bool isDebit = transaksi['debit'] > 0;
              
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  title: Text(transaksi['keterangan']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(transaksi['tanggal']),
                      Text(
                        transaksi['kategori'],
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        isDebit
                            ? formatCurrency.format(transaksi['debit'])
                            : formatCurrency.format(transaksi['kredit']),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDebit ? Colors.red : Colors.green,
                        ),
                      ),
                      Text(
                        isDebit ? 'Pengeluaran' : 'Pemasukan',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDebit ? Colors.red : Colors.green,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    // Detail transaksi
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Detail transaksi ${transaksi['keterangan']}')),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGrafikTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDateRangeDisplay(),
          const SizedBox(height: 24),
          const Text(
            'Grafik Pendapatan dan Pengeluaran',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 300,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 3000000,
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const titles = ['Minggu 1', 'Minggu 2', 'Minggu 3', 'Minggu 4'];
                        if (value.toInt() >= 0 && value.toInt() < titles.length) {
                          return Text(
                            titles[value.toInt()],
                            style: const TextStyle(fontSize: 10),
                          );
                        }
                        return const Text('');
                      },
                      reservedSize: 28,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value == 0) return const Text('0');
                        if (value == 1000000) return const Text('1Jt');
                        if (value == 2000000) return const Text('2Jt');
                        if (value == 3000000) return const Text('3Jt');
                        return const Text('');
                      },
                      reservedSize: 30,
                    ),
                  ),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(
                  show: true,
                  horizontalInterval: 1000000,
                ),
                borderData: FlBorderData(show: false),
                barGroups: [
                  _buildBarGroup(0, 1800000, 1200000),
                  _buildBarGroup(1, 2100000, 1700000),
                  _buildBarGroup(2, 1400000, 900000),
                  _buildBarGroup(3, 2500000, 1500000),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Distribusi Pengeluaran',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 300,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                sections: [
                  PieChartSectionData(
                    value: 45,
                    title: 'Operasional\n45%',
                    color: Colors.blue,
                    radius: 100,
                    titleStyle: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  PieChartSectionData(
                    value: 30,
                    title: 'Bahan\n30%',
                    color: Colors.green,
                    radius: 100,
                    titleStyle: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  PieChartSectionData(
                    value: 15,
                    title: 'Utilitas\n15%',
                    color: Colors.orange,
                    radius: 100,
                    titleStyle: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  PieChartSectionData(
                    value: 10,
                    title: 'Lainnya\n10%',
                    color: Colors.purple,
                    radius: 100,
                    titleStyle: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _buildBarGroup(int x, double pendapatan, double pengeluaran) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: pendapatan,
          color: Colors.green,
          width: 15,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
        ),
        BarChartRodData(
          toY: pengeluaran,
          color: Colors.red,
          width: 15,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
        ),
      ],
    );
  }

  Widget _buildDateRangeDisplay() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Periode: ${DateFormat('dd MMM yyyy').format(_dateRange.start)} - ${DateFormat('dd MMM yyyy').format(_dateRange.end)}',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          InkWell(
            onTap: _selectDateRange,
            child: const Icon(Icons.calendar_today, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required Color color,
    required List<Widget> children,
  }) {
    return Card(
      color: color,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, double value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            formatCurrency.format(value),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}