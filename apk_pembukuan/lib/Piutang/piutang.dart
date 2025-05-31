import 'package:flutter/material.dart';
import './detailpiutang.dart';
import './addpiutang.dart';
import 'package:apk_pembukuan/services/database/database_service.dart';

class PiutangPage extends StatefulWidget {
  @override
  _PiutangPageState createState() => _PiutangPageState();
}

class _PiutangPageState extends State<PiutangPage> {
  List<Map<String, dynamic>> daftarPiutang = [];

  int get totalPiutang => daftarPiutang.fold(0, (sum, item) => sum + (item['sisa'] as int));

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    final data = await DatabaseService().getDaftarPiutang();
    setState(() {
      daftarPiutang = data;
    });
  }

  void tambahPiutangBaru(Map<String, dynamic> data) async {
    await DatabaseService().tambahPiutang(data);
    loadData();
  }

  void updatePiutang(int index, Map<String, dynamic> updatedData) async {
  String id = daftarPiutang[index]['id'];
  await DatabaseService().updatePiutang(
    id,
    updatedData,
    namaPelanggan: updatedData['namaPelanggan'], // atau daftarPiutang[index]['nama']
    jumlahBayar: updatedData['jumlahBayar']?.toDouble() ?? 0,
  );
  loadData();
}

  void hapusPiutang(int index) async {
    String id = daftarPiutang[index]['id'];
    await DatabaseService().hapusPiutang(id);
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Piutang'),
        actions: [
          TextButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddPiutangPage(onAdd: tambahPiutangBaru),
                ),
              );
              if (result != null) {
                tambahPiutangBaru(result);
              }
            },
            child: Icon (Icons.add, color: Colors.black),
          ),
        ],
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Rp$totalPiutang', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            Text('Total yang belum diterima'),
            SizedBox(height: 20),
            Text('BELUM DITERIMA', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            daftarPiutang.isEmpty
                ? Expanded(child: Center(child: Text("Belum ada piutang")))
                : Expanded(
                    child: ListView.builder(
                      itemCount: daftarPiutang.length,
                      itemBuilder: (context, index) {
                        final piutang = daftarPiutang[index];
                        final sisaPersen = (piutang['sisa'] / piutang['jumlah'] * 100).toStringAsFixed(0);
                        return Card(
                          child: ListTile(
                            title: Text(piutang['namaPelanggan'] ?? 'Tanpa Nama'),
                            subtitle: Text("Rp${piutang['sisa']} - sisa $sisaPersen% \nJatuh tempo: ${piutang['tanggal']}"),
                            trailing: Text(piutang['status'], style: TextStyle(
                              color: piutang['status'] == 'Lunas' ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                            )),
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetailPiutangPage(data: piutang),
                                ),
                              );
                              if (result == 'deleted') {
                                hapusPiutang(index);
                              } else if (result is Map<String, dynamic>) {
                                updatePiutang(index, result);
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
