// piutang.dart
import 'package:flutter/material.dart';
import './detailpiutang.dart';
import './addpiutang.dart';

class PiutangPage extends StatefulWidget {
  @override
  _PiutangPageState createState() => _PiutangPageState();
}

class _PiutangPageState extends State<PiutangPage> {
  List<Map<String, dynamic>> piutangList = [];

  int get totalPiutang => piutangList.fold(0, (sum, item) => sum + (item['sisa'] as int));

  void tambahPiutangBaru(Map<String, dynamic> data) {
    setState(() {
      piutangList.add(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Piutang'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddPiutangPage(onAdd: tambahPiutangBaru),
                ),
              );
            },
            child: Text('Tambah', style: TextStyle(color: Colors.white)),
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
            piutangList.isEmpty
                ? Expanded(child: Center(child: Text("Belum ada piutang")))
                : Expanded(
                    child: ListView.builder(
                      itemCount: piutangList.length,
                      itemBuilder: (context, index) {
                        final piutang = piutangList[index];
                        return ListTile(
                          title: Text(piutang['nama']),
                          subtitle: Text("Rp${piutang['sisa']}"),
                          trailing: Icon(Icons.chevron_right),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailPiutangPage(
                                  nama: piutang['nama'],
                                  deskripsi: piutang['deskripsi'],
                                  tanggal: piutang['tanggal'],
                                  jumlahPinjaman: piutang['jumlah'],
                                  sisaPinjaman: piutang['sisa'],
                                  status: piutang['status'],
                                ),
                              ),
                            );
                          },
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
