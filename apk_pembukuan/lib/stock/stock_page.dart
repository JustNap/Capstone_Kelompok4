import 'package:flutter/material.dart';
import 'addstock.dart';

class StockPage extends StatefulWidget {
  const StockPage({Key? key}) : super(key: key);

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  List<StockItem> stockItems = [];

  void _navigateToAddPage({StockItem? existingItem}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TambahStockPage(existingItem: existingItem),
      ),
    );

    if (result != null && result is StockItem) {
      setState(() {
        if (existingItem != null) {
          final index =
              stockItems.indexWhere((item) => item.id == existingItem.id);
          if (index != -1) stockItems[index] = result;
        } else {
          stockItems.add(result);
        }
      });
    }
  }

  void _deleteItem(String id) {
    setState(() {
      stockItems.removeWhere((item) => item.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
          title: const Text('Barang/Jasa'), backgroundColor: Colors.blue),
      body: stockItems.isEmpty
          ? const Center(child: Text('Belum ada barang/jasa.'))
          : ListView.builder(
              itemCount: stockItems.length,
              itemBuilder: (context, index) {
                final item = stockItems[index];
                return Card(
                  child: ListTile(
                    title: Text('Nama: ${item.nama}'),
                    subtitle: Text(
                        'Kode: ${item.kode}\nJumlah: ${item.jumlah}\nHarga: Rp${item.harga.toStringAsFixed(0)}\nTotal: Rp${item.totalHarga.toStringAsFixed(0)}'),
                    isThreeLine: true,
                    trailing: Wrap(
                      spacing: 8,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.orange),
                          onPressed: () =>
                              _navigateToAddPage(existingItem: item),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteItem(item.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () => _navigateToAddPage(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
