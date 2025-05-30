import 'package:apk_pembukuan/services/auth/auth_service.dart';
import 'package:apk_pembukuan/services/database/database_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AnalisisPage extends StatefulWidget {
  const AnalisisPage({super.key});

  @override
  State<AnalisisPage> createState() => _AnalisisPageState();
}

class _AnalisisPageState extends State<AnalisisPage> {
  final _auth = AuthService();
  final _db = DatabaseService();

  double totalStockValue = 0;
  int totalPenjualan = 0;
  int piutangNominal = 0;
  int piutangLunas = 0;
  int piutangBelumLunas = 0;
  bool isLoading = true;

  Map<String, int> monthlySales = {};
  List<String> availableYears = [];
  String selectedYear = '';
  String chartType = 'Line';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final stokList = await _db.getStockItemsOnce();
    final penjualan = await _db.getPenjualan(_auth.getCurrentUid());
    final piutang = await _db.getDaftarPiutang();

    Map<String, int> salesPerMonth = {};
    Set<String> years = {};

    for (var item in penjualan) {
      final date = (item['tanggal'] as Timestamp?)?.toDate();
      if (date != null) {
        final year = date.year.toString();
        years.add(year);
        if (selectedYear == '' || selectedYear == year) {
          final month = DateFormat('MMM yyyy').format(date);
          salesPerMonth[month] = (salesPerMonth[month] ?? 0) +
              ((item['total'] ?? 0) as num).toInt();
        }
      }
    }

    final sortedYears = years.toList()..sort();
    selectedYear = selectedYear == '' && sortedYears.isNotEmpty
        ? sortedYears.last
        : selectedYear;

    setState(() {
      totalStockValue =
          stokList.fold(0.0, (sum, item) => sum + item.totalHarga);
      totalPenjualan = penjualan.fold(
          0, (sum, item) => sum + ((item['total'] ?? 0) as num).toInt());
      piutangLunas = piutang.where((e) => e['status'] == 'Lunas').length;
      piutangBelumLunas = piutang.where((e) => e['status'] != 'Lunas').length;
      piutangNominal = piutang.fold(
          0, (sum, item) => sum + ((item['sisa'] ?? 0) as num).toInt());
      monthlySales = salesPerMonth;
      availableYears = sortedYears;
      isLoading = false;
    });
  }

  void _exportData() {
    final buffer = StringBuffer();
    buffer.writeln("=== Ringkasan Keuangan ===");
    buffer
        .writeln("Total Nilai Stok: Rp ${totalStockValue.toStringAsFixed(0)}");
    buffer.writeln("Total Penjualan: Rp $totalPenjualan");
    buffer.writeln("Total Piutang: Rp $piutangNominal");
    buffer.writeln(
        "Piutang Lunas: $piutangLunas, Belum Lunas: $piutangBelumLunas");

    Share.share(buffer.toString(), subject: "Laporan Keuangan");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Analisis Keuangan"),
        actions: [
          IconButton(
              onPressed: _exportData, icon: const Icon(Icons.share_outlined))
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSummaryCard(
                    title: "Total Nilai Stok",
                    amount: totalStockValue,
                    icon: Icons.inventory,
                    color: Colors.indigo),
                const SizedBox(height: 12),
                _buildSummaryCard(
                    title: "Total Penjualan",
                    amount: totalPenjualan.toDouble(),
                    icon: Icons.attach_money,
                    color: Colors.green),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Tren Penjualan Bulanan",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        DropdownButton<String>(
                          value: selectedYear,
                          items: availableYears
                              .map((year) => DropdownMenuItem(
                                  value: year, child: Text(year)))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedYear = value!;
                              isLoading = true;
                            });
                            _loadData();
                          },
                        ),
                        const SizedBox(width: 10),
                        DropdownButton<String>(
                          value: chartType,
                          items: ['Line', 'Bar']
                              .map((type) => DropdownMenuItem(
                                  value: type, child: Text(type)))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              chartType = value!;
                            });
                          },
                        )
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildSalesChart(),
                const SizedBox(height: 20),
                const Text("Komposisi Piutang",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                SizedBox(
                  height: 160,
                  child: PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          value: piutangLunas.toDouble(),
                          color: Colors.green,
                          title: 'Lunas',
                          titleStyle: const TextStyle(
                              color: Colors.white, fontSize: 14),
                        ),
                        PieChartSectionData(
                          value: piutangBelumLunas.toDouble(),
                          color: Colors.red,
                          title: 'Belum',
                          titleStyle: const TextStyle(
                              color: Colors.white, fontSize: 14),
                        ),
                      ],
                      sectionsSpace: 2,
                      centerSpaceRadius: 30,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildSummaryCard(
                  title: "Total Piutang (Belum Lunas)",
                  amount: piutangNominal.toDouble(),
                  icon: Icons.credit_card,
                  color: Colors.orange,
                )
              ],
            ),
    );
  }

  Widget _buildSalesChart() {
    final sortedKeys = monthlySales.keys.toList()
      ..sort((a, b) => DateFormat('MMM yyyy')
          .parse(a)
          .compareTo(DateFormat('MMM yyyy').parse(b)));

    final spots = List.generate(
      sortedKeys.length,
      (i) => FlSpot(i.toDouble(), monthlySales[sortedKeys[i]]!.toDouble()),
    );

    final barGroups = List.generate(
      sortedKeys.length,
      (i) => BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: monthlySales[sortedKeys[i]]!.toDouble(),
            color: Colors.blue,
            width: 14,
          )
        ],
      ),
    );

    return SizedBox(
      height: 250,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: sortedKeys.length * 70,
          child: chartType == 'Line'
              ? LineChart(
                  LineChartData(
                    titlesData: _buildChartTitles(sortedKeys),
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        dotData: FlDotData(show: true),
                        color: Colors.blue,
                        barWidth: 3,
                      ),
                    ],
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(show: true),
                  ),
                )
              : BarChart(
                  BarChartData(
                    titlesData: _buildChartTitles(sortedKeys),
                    barGroups: barGroups,
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(show: true),
                  ),
                ),
        ),
      ),
    );
  }

  FlTitlesData _buildChartTitles(List<String> sortedKeys) {
    return FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: 1,
          getTitlesWidget: (value, meta) {
            final index = value.toInt();
            if (index >= sortedKeys.length) return const Text("");
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                sortedKeys[index],
                style: const TextStyle(fontSize: 10),
              ),
            );
          },
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 40,
          getTitlesWidget: (value, meta) {
            String formatted;
            if (value >= 1000000) {
              formatted = '${(value / 1000000).toStringAsFixed(1)}M';
            } else if (value >= 1000) {
              formatted = '${(value / 1000).toStringAsFixed(0)}K';
            } else {
              formatted = value.toStringAsFixed(0);
            }
            return Text(formatted, style: const TextStyle(fontSize: 10));
          },
        ),
      ),
      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required double amount,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black54)),
                  Text("Rp ${amount.toStringAsFixed(0)}",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
