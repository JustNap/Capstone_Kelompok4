import 'package:apk_pembukuan/Setting/setting.dart';
import 'package:apk_pembukuan/services/auth/auth_service.dart';
import 'package:apk_pembukuan/services/database/database_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:math';

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

  Map<DateTime, int> monthlySales = {};
  String selectedYear = DateTime.now().year.toString();
  String selectedChart = 'Line';

  List<String> availableYears = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final stokList = await _db.getStockItemsOnce();
    final penjualan = await _db.getPenjualan(_auth.getCurrentUid());
    final piutang = await _db.getDaftarPiutang();

    Map<DateTime, int> salesPerMonth = {};
    Set<String> yearsSet = {};

    for (var item in penjualan) {
      final date = (item['tanggal'] as Timestamp?)?.toDate();
      if (date != null) {
        yearsSet.add(date.year.toString());
        if (date.year.toString() == selectedYear) {
          final monthKey = DateTime.utc(date.year, date.month);
          salesPerMonth[monthKey] = (salesPerMonth[monthKey] ?? 0) +
              ((item['total'] ?? 0) as num).toInt();
        }
      }
    }

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
      availableYears = yearsSet.toList()..sort();
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

  Future<void> _saveChartAsPDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("Laporan Penjualan Bulanan",
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Table.fromTextArray(
                headers: ['Bulan', 'Total Penjualan'],
                data: monthlySales.entries
                    .map((e) =>
                        [DateFormat('MMM yyyy').format(e.key), 'Rp ${e.value}'])
                    .toList(),
                border: null,
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }

  String formatRibuan(double value) {
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(value % 1000 == 0 ? 0 : 1)}k';
    } else {
      return value.toInt().toString();
    }
  }

  SideTitles customLeftTitles(List<int> values) {
    double maxY = values.isNotEmpty ? values.reduce(max).toDouble() : 0;
    double interval = (maxY / 5).ceilToDouble();
    if (interval < 1000) interval = 1000;

    return SideTitles(
      showTitles: true,
      reservedSize: 40,
      interval: interval,
      getTitlesWidget: (value, meta) {
        return Text(formatRibuan(value), style: const TextStyle(fontSize: 12));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final sortedKeys = monthlySales.keys.toList()
      ..sort((a, b) => a.compareTo(b));
    final values = sortedKeys.map((e) => monthlySales[e] ?? 0).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Analisis Keuangan"),
        actions: [
          IconButton(
              onPressed: _exportData,
              tooltip: 'Share',
              icon: const Icon(Icons.share_outlined)),
          IconButton(
              onPressed: _saveChartAsPDF,
              tooltip: 'Save PDF',
              icon: const Icon(Icons.picture_as_pdf)),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingPage()),
              );
            },
            tooltip: 'Pengaturan',
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  const SizedBox(height: 12),
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Expanded(
                        child: Text(
                          "Tren Penjualan Bulanan",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      DropdownButton<String>(
                        value: selectedYear,
                        onChanged: (value) {
                          setState(() {
                            selectedYear = value!;
                            isLoading = true;
                          });
                          _loadData();
                        },
                        items: availableYears
                            .map((e) =>
                                DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                      ),
                      DropdownButton<String>(
                        value: selectedChart,
                        onChanged: (value) {
                          setState(() {
                            selectedChart = value!;
                          });
                        },
                        items: ['Line', 'Bar']
                            .map((e) =>
                                DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  AspectRatio(
                    aspectRatio: 1.2,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: (monthlySales.length * 80)
                            .toDouble()
                            .clamp(300, 600),
                        child: selectedChart == 'Line'
                            ? LineChart(LineChartData(
                                titlesData: FlTitlesData(
                                  leftTitles: AxisTitles(
                                      sideTitles: customLeftTitles(values)),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        final index = value.toInt();
                                        if (index >= sortedKeys.length)
                                          return const Text("");
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Text(
                                            DateFormat('MMM')
                                                .format(sortedKeys[index]),
                                            style:
                                                const TextStyle(fontSize: 10),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  topTitles: AxisTitles(
                                      sideTitles:
                                          SideTitles(showTitles: false)),
                                  rightTitles: AxisTitles(
                                      sideTitles:
                                          SideTitles(showTitles: false)),
                                ),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: List.generate(
                                      values.length,
                                      (i) => FlSpot(
                                          i.toDouble(), values[i].toDouble()),
                                    ),
                                    isCurved: true,
                                    dotData: FlDotData(show: true),
                                    color: Colors.blue,
                                    barWidth: 3,
                                  ),
                                ],
                                borderData: FlBorderData(show: false),
                              ))
                            : BarChart(BarChartData(
                                barGroups: List.generate(
                                  values.length,
                                  (i) => BarChartGroupData(x: i, barRods: [
                                    BarChartRodData(
                                      toY: values[i].toDouble(),
                                      color: Colors.blue,
                                      width: 16,
                                    ),
                                  ]),
                                ),
                                titlesData: FlTitlesData(
                                  leftTitles: AxisTitles(
                                      sideTitles: customLeftTitles(values)),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        final index = value.toInt();
                                        if (index >= sortedKeys.length)
                                          return const Text("");
                                        return Text(
                                          DateFormat('MMM')
                                              .format(sortedKeys[index]),
                                          style: const TextStyle(fontSize: 10),
                                        );
                                      },
                                    ),
                                  ),
                                  topTitles: AxisTitles(
                                      sideTitles:
                                          SideTitles(showTitles: false)),
                                  rightTitles: AxisTitles(
                                      sideTitles:
                                          SideTitles(showTitles: false)),
                                ),
                                borderData: FlBorderData(show: false),
                              )),
                      ),
                    ),
                  ),
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
            ),
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
