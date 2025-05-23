import 'package:flutter/material.dart';

class StockItem {
  String id;
  String nama;
  String kategori;
  String jenis;
  String kode;
  String satuan;
  int jumlah;
  double harga;
  double totalHarga;

  StockItem({
    required this.id,
    required this.nama,
    required this.kategori,
    required this.jenis,
    required this.kode,
    required this.satuan,
    required this.jumlah,
    required this.harga,
    required this.totalHarga,
  });
}

class TambahStockPage extends StatefulWidget {
  final StockItem? existingItem;

  const TambahStockPage({Key? key, this.existingItem}) : super(key: key);

  @override
  State<TambahStockPage> createState() => _TambahStockPageState();
}

class _TambahStockPageState extends State<TambahStockPage> {
  final namaController = TextEditingController();
  final kodeController = TextEditingController();
  final satuanController = TextEditingController();
  final jumlahController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.existingItem != null) {
      namaController.text = widget.existingItem!.nama;
      kodeController.text = widget.existingItem!.kode;
      satuanController.text = widget.existingItem!.satuan;
      jumlahController.text = widget.existingItem!.jumlah.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final jumlah = int.tryParse(jumlahController.text) ?? 0;
    final hargaSatuan = double.tryParse(satuanController.text) ?? 0;
    final totalHarga = jumlah * hargaSatuan;

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: const Text('Tambah Stok'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: namaController,
              decoration: const InputDecoration(labelText: 'Nama Barang/Jasa'),
            ),
            TextField(
              controller: kodeController,
              decoration: const InputDecoration(labelText: 'Kode'),
            ),
            TextField(
              controller: jumlahController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Jumlah Barang'),
              onChanged: (_) => setState(() {}),
            ),
            TextField(
              controller: satuanController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Harga Satuan'),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            Text('Total Harga: Rp ${totalHarga.toStringAsFixed(0)}'),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () {
                final jumlah = int.tryParse(jumlahController.text) ?? 0;
                final hargaSatuan = double.tryParse(satuanController.text) ?? 0;
                final totalHarga = jumlah * hargaSatuan;

                final item = StockItem(
                  id: widget.existingItem?.id ??
                      DateTime.now().millisecondsSinceEpoch.toString(),
                  nama: namaController.text,
                  kategori: '',
                  jenis: '',
                  kode: kodeController.text,
                  satuan: satuanController.text,
                  jumlah: jumlah,
                  harga: hargaSatuan,
                  totalHarga: totalHarga,
                );
                Navigator.pop(context, item);
              },
              child: const Text('Tambah Stok'),
            ),
          ],
        ),
      ),
    );
  }
}
