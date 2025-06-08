import 'package:flutter/material.dart';

class DetailPiutangPage extends StatefulWidget {
  final Map<String, dynamic> data;

  const DetailPiutangPage({super.key, required this.data});

  @override
  State<DetailPiutangPage> createState() => _DetailPiutangPageState();
}

class _DetailPiutangPageState extends State<DetailPiutangPage> {
  final TextEditingController catatanController = TextEditingController();
  final TextEditingController jumlahController = TextEditingController();

  late int currentSisaPinjaman;
  late String currentStatus;

  @override
  void initState() {
    super.initState();
    currentSisaPinjaman = widget.data['sisa'];
    currentStatus = widget.data['status'];
  }

  void simpanPembayaran() {
    int jumlahBayar = int.tryParse(jumlahController.text) ?? 0;

    if (jumlahBayar <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Jumlah harus lebih dari 0')));
      return;
    }

    if (jumlahBayar > currentSisaPinjaman) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Jumlah melebihi sisa pinjaman')));
      return;
    }

    setState(() {
      currentSisaPinjaman -= jumlahBayar;
      if (currentSisaPinjaman <= 0) {
        currentStatus = 'Lunas';
        currentSisaPinjaman = 0;
      }
    });

    final updatedData = Map<String, dynamic>.from(widget.data);
    updatedData['sisa'] = currentSisaPinjaman;
    updatedData['status'] = currentStatus;

    Navigator.pop(context, updatedData);
  }

  void hapusPiutang() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Hapus Piutang'),
        content: Text('Apakah kamu yakin ingin menghapus piutang ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); 
              Navigator.pop(context, 'deleted'); 
            },
            child: Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Piutang',
          style: TextStyle(
          color: Colors.black,
              ),
        ),
        backgroundColor: Colors.greenAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: hapusPiutang,
            tooltip: 'Hapus Piutang',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(widget.data['namaPelanggan'], style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text(widget.data['deskripsi'], style: TextStyle(fontSize: 16, color: Colors.grey)),
          SizedBox(height: 8),
          Text('Status: $currentStatus', style: TextStyle(color: currentStatus == 'Lunas' ? Colors.green : Colors.red)),
          Text('Tanggal jatuh tempo: ${widget.data['tanggal']}'),
          SizedBox(height: 20),
          Text('Jumlah Pinjaman: Rp ${widget.data['jumlah']}', style: TextStyle(fontSize: 16)),
          Text('Sisa Pinjaman: Rp $currentSisaPinjaman', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          TextField(
            controller: jumlahController,
            decoration: InputDecoration(labelText: 'Masukkan jumlah yang dibayar', border: OutlineInputBorder()),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 12),
          TextField(
            controller: catatanController,
            decoration: InputDecoration(labelText: 'Catatan', border: OutlineInputBorder()),
            maxLines: 3,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: simpanPembayaran,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: Text('SIMPAN'),
          )
        ]),
      ),
    );
  }
}
