import 'package:flutter/material.dart';

class AddPiutangPage extends StatefulWidget {
  final Function(Map<String, dynamic>) onAdd;

  AddPiutangPage({required this.onAdd});

  @override
  _TambahPiutangPageState createState() => _TambahPiutangPageState();
}

class _TambahPiutangPageState extends State<AddPiutangPage> {
  final namaController = TextEditingController();
  final jumlahController = TextEditingController();
  final deskripsiController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tambah Piutang")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: namaController, decoration: InputDecoration(labelText: 'Nama')),
            TextField(controller: deskripsiController, decoration: InputDecoration(labelText: 'Deskripsi')),
            TextField(
              controller: jumlahController,
              decoration: InputDecoration(labelText: 'Jumlah'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                widget.onAdd({
                  'nama': namaController.text,
                  'deskripsi': deskripsiController.text,
                  'jumlah': int.parse(jumlahController.text),
                  'sisa': int.parse(jumlahController.text),
                  'status': 'Belum Lunas',
                  'tanggal': DateTime.now().toString().split(' ')[0],
                });
                Navigator.pop(context);
              },
              child: Text("Simpan"),
            )
          ],
        ),
      ),
    );
  }
}
