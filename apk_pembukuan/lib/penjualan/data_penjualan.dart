import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataPenjualanPage extends StatefulWidget {
  final int transaksiId;

  const DataPenjualanPage({super.key, required this.transaksiId});

  @override
  State<DataPenjualanPage> createState() => _DataPenjualanPageState();
}

class _DataPenjualanPageState extends State<DataPenjualanPage> {
  List<Map<String, dynamic>> daftarBarang = [];
  Map<String, dynamic>? barangTerpilih;

  final TextEditingController _jumlahController = TextEditingController();

  int get totalHarga {
  final jumlah = int.tryParse(_jumlahController.text) ?? 0;

  // Ambil harga dari barangTerpilih dan konversi ke int
  final hargaNum = barangTerpilih?['harga'] ?? 0;

  // Konversi ke int secara aman
  final harga = hargaNum is int ? hargaNum : (hargaNum as num).toInt();

  return jumlah * harga;
}

  @override
  void initState() {
    super.initState();
    _loadBarang();
  }

  void _loadBarang() async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return;

  final snapshot = await FirebaseFirestore.instance
      .collection('Users')
      .doc(uid)
      .collection('BarangJasa')
      .get();

  final data = snapshot.docs
      .map((doc) => {'id': doc.id, ...doc.data()})
      .toList();

  setState(() {
    daftarBarang = data;
  });
}

  void _simpanTransaksi() {
    if (barangTerpilih == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih barang terlebih dahulu')),
      );
      return;
    }

    int jumlah = int.tryParse(_jumlahController.text) ?? 0;
    int stok = barangTerpilih?['jumlah'] ?? 0;

    if (jumlah <= 0 || jumlah > stok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Jumlah tidak valid. Stok tersedia: $stok')),
      );
      return;
    }

    Navigator.pop(context, {
      'id': widget.transaksiId,
      'nama': barangTerpilih!['nama'],
      'barangId': barangTerpilih!['id'], // penting untuk update stok
      'jumlah': jumlah,
      'harga': barangTerpilih!['harga'],
      'total': totalHarga,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Penjualan'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID Transaksi: ${widget.transaksiId}'),
            const SizedBox(height: 12),

            // Dropdown barang
            DropdownButtonFormField<Map<String, dynamic>>(
              items: daftarBarang
                  .map((barang) => DropdownMenuItem(
                        value: barang,
                        child: Text('${barang['nama']} (Stok: ${barang['jumlah']})'),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  barangTerpilih = value;
                  _jumlahController.clear();
                });
              },
              decoration: const InputDecoration(
                labelText: 'Pilih Barang',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _jumlahController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Jumlah Dijual',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),

            Text('Harga Satuan: Rp ${barangTerpilih?['harga'] ?? 0}'),
            const SizedBox(height: 12),

            Text('Total Harga: Rp $totalHarga'),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _simpanTransaksi,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text('Simpan Transaksi'),
            ),
          ],
        ),
      ),
    );
  }
}
