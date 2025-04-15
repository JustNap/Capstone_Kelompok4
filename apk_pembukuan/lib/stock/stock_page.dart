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

  String? editingId;

  void saveItem() {
    if (namaController.text.isEmpty ||
        kategoriController.text.isEmpty ||
        jenisController.text.isEmpty ||
        kodeController.text.isEmpty ||
        satuanController.text.isEmpty ||
        jumlahController.text.isEmpty ||
        hargaController.text.isEmpty) return;

    setState(() {
      if (editingId == null) {
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
      } else {
        final index = stockItems.indexWhere((item) => item.id == editingId);
        if (index != -1) {
          stockItems[index] = StockItem(
            id: editingId!,
            nama: namaController.text,
            kategori: kategoriController.text,
            jenis: jenisController.text,
            kode: kodeController.text,
            satuan: satuanController.text,
            jumlah: int.parse(jumlahController.text),
            harga: double.parse(hargaController.text),
          );
        }
        editingId = null;
      }

      namaController.clear();
      kategoriController.clear();
      jenisController.clear();
      kodeController.clear();
      satuanController.clear();
      jumlahController.clear();
      hargaController.clear();
    });
  }

  void startEdit(StockItem item) {
    setState(() {
      editingId = item.id;
      namaController.text = item.nama;
      kategoriController.text = item.kategori;
      jenisController.text = item.jenis;
      kodeController.text = item.kode;
      satuanController.text = item.satuan;
      jumlahController.text = item.jumlah.toString();
      hargaController.text = item.harga.toString();
    });
  }

  void deleteItem(String id) {
    setState(() {
      stockItems.removeWhere((item) => item.id == id);
      if (editingId == id) {
        editingId = null;
        namaController.clear();
        kategoriController.clear();
        jenisController.clear();
        kodeController.clear();
        satuanController.clear();
        jumlahController.clear();
        hargaController.clear();
      }
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
                onPressed: saveItem,
                child: Text(
                    editingId == null ? 'Tambah Stok' : 'Simpan Perubahan'),
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
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => startEdit(item),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => deleteItem(item.id),
                          ),
                        ],
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
