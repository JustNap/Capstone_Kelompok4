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
  
  DateTime? selectedDate;

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tambah Piutang",
        style: TextStyle(
          color: Colors.black,
              ),
      ),
      backgroundColor: Colors.greenAccent,),
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
            SizedBox(height: 16),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedDate == null
                      ? 'Pilih Tanggal Jatuh Tempo'
                      : 'Jatuh tempo: ${selectedDate!.toLocal().toString().split(' ')[0]}',
                  style: TextStyle(fontSize: 16),
                ),
                TextButton(
                  onPressed: () => _pickDate(context),
                  child: Text('Pilih Tanggal'),
                ),
              ],
            ),

            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (selectedDate == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Harap pilih tanggal jatuh tempo')),
                  );
                  return;
                }

                widget.onAdd({
                  'namaPelanggan': namaController.text,
                  'deskripsi': deskripsiController.text,
                  'jumlah': int.parse(jumlahController.text),
                  'sisa': int.parse(jumlahController.text),
                  'status': 'Belum Lunas',
                  'tanggal': selectedDate!.toString().split(' ')[0], 
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
