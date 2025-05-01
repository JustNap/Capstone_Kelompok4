import 'package:apk_pembukuan/penjualan/data_penjualan.dart';
import 'package:flutter/material.dart';

class PenjualanPage extends StatefulWidget {
  const PenjualanPage({super.key});

  @override
  State<PenjualanPage> createState() => _PenjualanPageState();
}

class _PenjualanPageState extends State<PenjualanPage> {
  List<Map<String, dynamic>> transaksiList = [];

  void _tambahTransaksi(Map<String, dynamic> data) {
    setState(() {
      transaksiList.add(data);
    });
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
      _tambahTransaksi(result);
    }
  }

  void _hapusTransaksi(int index) {
    setState(() {
      transaksiList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Penjualan'),
        backgroundColor: Colors.blue,
      ),
      body: transaksiList.isEmpty
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
              title: Text('Transaksi: ${transaksi['id']}'),
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
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
