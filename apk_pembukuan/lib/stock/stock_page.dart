import 'package:flutter/material.dart';
import 'class_stock.dart';

class StockPage extends StatefulWidget {
  const StockPage({Key? key}) : super(key: key);

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  List<StockItem> stockItems = [];

  final namaController = TextEditingController();
  final kategoriController = TextEditingController();
  final jenisController = TextEditingController();
  final kodeController = TextEditingController();
  final satuanController = TextEditingController();
  final jumlahController = TextEditingController();
  final hargaController = TextEditingController();

  void addItem() {
    if (namaController.text.isEmpty ||
        kategoriController.text.isEmpty ||
        jenisController.text.isEmpty ||
        kodeController.text.isEmpty ||
        satuanController.text.isEmpty ||
        jumlahController.text.isEmpty ||
        hargaController.text.isEmpty) return;

    setState(() {
      stockItems.add(
        StockItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          nama: namaController.text,
          kategori: kategoriController.text,
          jenis: jenisController.text,
          kode: kodeController.text,
          satuan: satuanController.text,
          jumlah: int.parse(jumlahController.text),
          harga: double.parse(hargaController.text),
        ),
      );

      namaController.clear();
      kategoriController.clear();
      jenisController.clear();
      kodeController.clear();
      satuanController.clear();
      jumlahController.clear();
      hargaController.clear();
    });
  }

  void deleteItem(String id) {
    setState(() {
      stockItems.removeWhere((item) => item.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Informasi Barang & Jasa')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              TextField(
                controller: namaController,
                decoration: const InputDecoration(labelText: 'Nama Barang'),
              ),
              TextField(
                controller: kategoriController,
                decoration: const InputDecoration(labelText: 'Kategori Barang'),
              ),
              TextField(
                controller: jenisController,
                decoration: const InputDecoration(labelText: 'Jenis Barang'),
              ),
              TextField(
                controller: kodeController,
                decoration: const InputDecoration(labelText: 'Kode Barang'),
              ),
              TextField(
                controller: satuanController,
                decoration: const InputDecoration(labelText: 'Satuan'),
              ),
              TextField(
                controller: jumlahController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Jumlah'),
              ),
              TextField(
                controller: hargaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Harga (Rp)'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: addItem,
                child: const Text('Tambah Stok'),
              ),
              const Divider(),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: stockItems.length,
                itemBuilder: (context, index) {
                  final item = stockItems[index];
                  return Card(
                    child: ListTile(
                      title: Text('${item.nama} (${item.kode})'),
                      subtitle: Text(
                        'Kategori: ${item.kategori}, Jenis: ${item.jenis}\n'
                        'Jumlah: ${item.jumlah} ${item.satuan} | Harga: Rp${item.harga.toStringAsFixed(0)}',
                      ),
                      isThreeLine: true,
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => deleteItem(item.id),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
