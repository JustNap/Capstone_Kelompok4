import 'package:flutter/material.dart';

class DataPenjualanPage extends StatefulWidget {
  final int transaksiId;

  const DataPenjualanPage({super.key, required this.transaksiId});

  @override
  State<DataPenjualanPage> createState() => _DataPenjualanPageState();
}

class _DataPenjualanPageState extends State<DataPenjualanPage> {
  final TextEditingController _namaBarangController = TextEditingController();
  final TextEditingController _jumlahController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();

  int get totalHarga {
    final jumlah = int.tryParse(_jumlahController.text) ?? 0;
    final harga = int.tryParse(_hargaController.text) ?? 0;
    return jumlah * harga;
  }

  void _simpanTransaksi() {
    String namaBarang = _namaBarangController.text;
    int jumlah = int.tryParse(_jumlahController.text) ?? 0;
    int harga = int.tryParse(_hargaController.text) ?? 0;

    if (namaBarang.isEmpty || jumlah <= 0 || harga <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon isi semua data dengan benar')),
      );
      return;
    }

    print('ID Transaksi: ${widget.transaksiId}');
    print('Nama Barang: $namaBarang');
    print('Jumlah: $jumlah');
    print('Harga: $harga');
    print('Total: ${totalHarga}');

    Navigator.pop(context);
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

            TextField(
              controller: _namaBarangController,
              decoration: const InputDecoration(
                labelText: 'Nama Barang',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _jumlahController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Jumlah Barang',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _hargaController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Harga Satuan',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
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
