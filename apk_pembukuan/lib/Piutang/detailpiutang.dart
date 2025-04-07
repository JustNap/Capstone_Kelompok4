import 'package:flutter/material.dart';

class DetailPiutangPage extends StatefulWidget {
  final String nama;
  final String deskripsi;
  final String tanggal;
  final int jumlahPinjaman;
  final int sisaPinjaman;
  final String status;

  const DetailPiutangPage({
    Key? key,
    required this.nama,
    required this.deskripsi,
    required this.tanggal,
    required this.jumlahPinjaman,
    required this.sisaPinjaman,
    required this.status,
  }) : super(key: key);

  @override
  _DetailPiutangPageState createState() => _DetailPiutangPageState();
}

class _DetailPiutangPageState extends State<DetailPiutangPage> {
  String paymentType = 'cicilan';
  final TextEditingController catatanController = TextEditingController();
  final TextEditingController jumlahController = TextEditingController();

  late int currentSisaPinjaman;
  late String currentStatus;

  @override
  void initState() {
    super.initState();
    currentSisaPinjaman = widget.sisaPinjaman;
    currentStatus = widget.status;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Utang'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.nama,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.deskripsi,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              SizedBox(height: 8),
              Text(
                'Status: $currentStatus',
                style: TextStyle(
                  color: currentStatus == 'Lunas' ? Colors.green : Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.tanggal,
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 20),

              Text('JUMLAH PINJAMAN', style: TextStyle(fontSize: 16)),
              Text(
                'Rp ${widget.jumlahPinjaman}',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 20),
              Text('SISA PINJAMAN', style: TextStyle(fontSize: 16)),
              Text(
                'Rp $currentSisaPinjaman',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 20),
              Text('JENIS PEMBAYARAN', style: TextStyle(fontSize: 16)),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile(
                      title: Text('Cicilan'),
                      value: 'cicilan',
                      groupValue: paymentType,
                      onChanged: (value) {
                        setState(() {
                          paymentType = value.toString();
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile(
                      title: Text('Lunas'),
                      value: 'lunas',
                      groupValue: paymentType,
                      onChanged: (value) {
                        setState(() {
                          paymentType = value.toString();
                        });
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),
              Text('CATATAN', style: TextStyle(fontSize: 16)),
              TextField(
                controller: catatanController,
                decoration: InputDecoration(
                  hintText: 'Pinjaman ini dibayar dengan cara cicilan',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),

              SizedBox(height: 20),
              Text('Masukkan jumlah', style: TextStyle(fontSize: 16)),
              TextField(
                controller: jumlahController,
                decoration: InputDecoration(
                  hintText: 'Jumlah',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  int jumlahBayar = int.tryParse(jumlahController.text) ?? 0;

                  if (jumlahBayar <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Jumlah harus lebih dari 0')),
                    );
                    return;
                  }

                  if (jumlahBayar > currentSisaPinjaman) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Jumlah melebihi sisa pinjaman')),
                    );
                    return;
                  }

                  setState(() {
                    currentSisaPinjaman -= jumlahBayar;

                    if (currentSisaPinjaman <= 0) {
                      currentStatus = 'Lunas';
                      currentSisaPinjaman = 0;
                    }
                  });
                  
                  
                  print('Jumlah dibayar: $jumlahBayar');
                  print('Jenis pembayaran: $paymentType');
                  print('Catatan: ${catatanController.text}');
                },
                child: Text('SIMPAN'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
