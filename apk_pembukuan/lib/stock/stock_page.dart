import 'package:flutter/material.dart';
import 'addstock.dart';
import 'package:apk_pembukuan/services/database/database_service.dart';

class StockPage extends StatefulWidget {
  const StockPage({Key? key}) : super(key: key);

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  final dbService = DatabaseService();

  void _navigateToAddPage({StockItem? existingItem}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TambahStockPage(existingItem: existingItem),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
          title: const Text('Barang/Jasa'), backgroundColor: Colors.blue),
      body: StreamBuilder<List<StockItem>>(
        stream: dbService.getStockItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada barang/jasa.'));
          }

          final stockItems = snapshot.data!;

          return ListView.builder(
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
                        onPressed: () => _navigateToAddPage(existingItem: item),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await dbService.deleteStockItem(item.id);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
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
