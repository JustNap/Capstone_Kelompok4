import 'package:flutter/material.dart';
import 'package:apk_pembukuan/services/database/database_service.dart';

class DataPenjualanPage extends StatefulWidget {
  final int transaksiId;

  const DataPenjualanPage({super.key, required this.transaksiId});

  @override
  State<DataPenjualanPage> createState() => _DataPenjualanPageState();
}

class _DataPenjualanPageState extends State<DataPenjualanPage> {
  List<Map<String, dynamic>> items = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  Future<void> fetchItems() async {
    try {
      final stockItems = await DatabaseService().getStockItems().first;
      setState(() {
        items = stockItems.map((item) {
          return {
            'id': item.id,
            'nama': item.nama,
            'harga': item.harga,
            'jumlah': 0,
            'stock': item.jumlah,
          };
        }).toList();
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Gagal memuat data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _tambahJumlah(int index) {
    setState(() {
      if (items[index]['jumlah'] < items[index]['stock']) {
        items[index]['jumlah']++;
      }
    });
  }

  void _kurangJumlah(int index) {
    setState(() {
      if (items[index]['jumlah'] > 0) {
        items[index]['jumlah']--;
      }
    });
  }

  Future<void> _prosesSemuaTransaksi() async {
    final selectedItems = items.where((item) => item['jumlah'] > 0).toList();

    if (selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pilih minimal 1 produk untuk dijual.")),
      );
      return;
    }

    double totalKeseluruhan = 0;

    try {
      for (var item in selectedItems) {
        await DatabaseService().kurangiStokBarang(item['id'], item['jumlah']);
        totalKeseluruhan += (item['jumlah'] * item['harga']).toDouble();
      }

      Navigator.pop(context, {
        'id': widget.transaksiId,
        'items': selectedItems,
        'total': totalKeseluruhan,
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memproses transaksi: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Barang',
          style: TextStyle(
          color: Colors.black,
              ),
        ),
        backgroundColor: Colors.greenAccent,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : items.isEmpty
              ? const Center(child: Text("Tidak ada data barang."))
              : Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        itemCount: items.length,
                        separatorBuilder: (_, __) => const Divider(height: 0),
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () => _kurangJumlah(index),
                                ),
                                Text('${item['jumlah']} / ${item['stock']}'),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () => _tambahJumlah(index),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(item['nama']),
                                  ),
                                ),
                                Text('Rp ${item['harga']}'),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            color: Colors.orange,
                            child: TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Clear',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.lightBlue,
                            child: TextButton(
                              onPressed: _prosesSemuaTransaksi,
                              child: const Text('Sell',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
    );
  }
}
