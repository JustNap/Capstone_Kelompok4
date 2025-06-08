import 'package:apk_pembukuan/penjualan/data_penjualan.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:apk_pembukuan/services/database/database_service.dart';

class PenjualanPage extends StatefulWidget {
  const PenjualanPage({super.key});

  @override
  State<PenjualanPage> createState() => _PenjualanPageState();
}

class _PenjualanPageState extends State<PenjualanPage> {
  List<Map<String, dynamic>> transaksiList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTransaksi();
  }

  void _loadTransaksi() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      setState(() => isLoading = true);
      final data = await DatabaseService().getPenjualan(uid);
      setState(() {
        transaksiList = data;
        isLoading = false;
      });
    }
  }

  void _hapusTransaksi(int index) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final docId = transaksiList[index]['docId'];

    if (uid != null && docId != null) {
      await DatabaseService().hapusPenjualan(uid, docId);
      setState(() {
        transaksiList.removeAt(index);
      });
    }
  }

  void _bukaFormTambah() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            DataPenjualanPage(transaksiId: transaksiList.length + 1),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        final List<dynamic> items = result['items'] ?? [];
        // final total = result['total'] ?? 0;

        for (var item in items) {
          final transaksi = {
            'id': result['id'],
            'nama': item['nama'],
            'jumlah': item['jumlah'],
            'harga': item['harga'],
            'total': item['jumlah'] * item['harga'],
          };
          await DatabaseService().tambahPenjualan(uid, transaksi);
        }

        _loadTransaksi();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Penjualan',
          style: TextStyle(
          color: Colors.black,
              ),
        ),
        backgroundColor: Colors.greenAccent,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : transaksiList.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.receipt_long, size: 100, color: Colors.grey),
                      SizedBox(height: 20),
                      Text(
                        'Belum ada transaksi penjualan.',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: transaksiList.length,
                  itemBuilder: (context, index) {
                    final transaksi = transaksiList[index];
                    return Card(
                      margin: const EdgeInsets.all(10),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title:
                            Text('Transaksi: ${transaksi['id'] ?? index + 1}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Barang: ${transaksi['nama']}'),
                            Text('Jumlah: ${transaksi['jumlah']}'),
                            Text('Harga: Rp ${transaksi['harga']}'),
                            Text('Total: Rp ${transaksi['total']}'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _hapusTransaksi(index),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _bukaFormTambah,
        backgroundColor: Colors.greenAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
