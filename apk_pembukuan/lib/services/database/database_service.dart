import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:apk_pembukuan/stock/addstock.dart';
import 'package:apk_pembukuan/models/user.dart';

class DatabaseService {
  // get instance of firestore db & auth
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  /*
    USER PROFILE
  */
  Future<void> saveUserInfoInFirebase({
    required String name,
    required String email,
  }) async {
    String uid = _auth.currentUser!.uid;
    String username = email.split('@')[0];

    UserProfile user = UserProfile(
      uid: uid,
      name: name,
      email: email,
      username: username,
      no_hp: '',
    );

    final userMap = user.toMap();

    await _db.collection("Users").doc(uid).set(userMap);
  }

  Future<UserProfile?> getUserFromFirebase(String uid) async {
    try {
      DocumentSnapshot userDoc = await _db.collection("Users").doc(uid).get();
      return UserProfile.fromDocument(userDoc);
    } catch (e) {
      print(e);
      return null;
    }
  }

  /*
    BARANG/JASA
  */

  Future<void> saveStockItem(StockItem item) async {
    String uid = _auth.currentUser!.uid;
    await _db
        .collection("Users")
        .doc(uid)
        .collection("BarangJasa")
        .doc(item.id)
        .set({
      'id': item.id,
      'nama': item.nama,
      'kategori': item.kategori,
      'jenis': item.jenis,
      'kode': item.kode,
      'satuan': item.satuan,
      'jumlah': item.jumlah,
      'harga': item.harga,
      'totalHarga': item.totalHarga,
    });

    await catatMutasi(
      deskripsi: "Pembelian Stok: ${item.nama}",
      jumlah: item.totalHarga,
      jenis: 'keluar',
    );
  }

  Future<void> kurangiStokBarang(String id, int jumlahTerjual) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final docRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('BarangJasa')
        .doc(id);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);

      if (!snapshot.exists) {
        throw Exception("Data barang dengan ID $id tidak ditemukan");
      }

      final currentStock = snapshot['jumlah'] as int;
      final hargaSatuan = (snapshot['harga'] as num).toDouble();

      if (currentStock < jumlahTerjual) {
        throw Exception("Stok tidak mencukupi");
      }

      final updatedJumlah = currentStock - jumlahTerjual;
      final updatedTotal = updatedJumlah * hargaSatuan;

      transaction.update(docRef, {
        'jumlah': updatedJumlah,
        'totalHarga': updatedTotal,
      });
    });
  }

  Future<void> deleteStockItem(String id) async {
    String uid = _auth.currentUser!.uid;
    await _db
        .collection("Users")
        .doc(uid)
        .collection("BarangJasa")
        .doc(id)
        .delete();
  }

  Stream<List<StockItem>> getStockItems() {
    String uid = _auth.currentUser!.uid;
    return _db
        .collection("Users")
        .doc(uid)
        .collection("BarangJasa")
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return StockItem(
          id: data['id'],
          nama: data['nama'],
          kategori: data['kategori'],
          jenis: data['jenis'],
          kode: data['kode'],
          satuan: data['satuan'],
          jumlah: data['jumlah'],
          harga: (data['harga'] as num).toDouble(),
          totalHarga: (data['totalHarga'] as num).toDouble(),
        );
      }).toList();
    });
  }

  Future<void> tambahPiutang(Map<String, dynamic> data) async {
    final uid = _auth.currentUser!.uid;
    await _db.collection("Users").doc(uid).collection("Piutang").add(data);

    await catatMutasi(
      deskripsi: "Piutang baru: ${data['namaPelanggan'] ?? 'Tidak diketahui'}",
      jumlah: (data['jumlah'] ?? 0).toDouble(),
      jenis: 'keluar',
    );
  }

  Future<List<Map<String, dynamic>>> getDaftarPiutang() async {
    final uid = _auth.currentUser!.uid;
    final snapshot =
        await _db.collection("Users").doc(uid).collection("Piutang").get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  Future<void> tambahPenjualan(String uid, Map<String, dynamic> data) async {
    await _db.collection('Users').doc(uid).collection('penjualan').add({
      ...data,
      'tanggal': DateTime.now(),
    });

    await catatMutasi(
      deskripsi: "Penjualan: ${data['deskripsi'] ?? 'Barang'}",
      jumlah: (data['total'] ?? 0).toDouble(),
      jenis: 'masuk',
    );
  }

  Future<List<Map<String, dynamic>>> getPenjualan(String uid) async {
    final snapshot =
        await _db.collection('Users').doc(uid).collection('penjualan').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['docId'] = doc.id;
      return data;
    }).toList();
  }

  Future<void> updatePiutang(
    String id,
    Map<String, dynamic> updatedData, {
    required String namaPelanggan,
    required double jumlahBayar,
  }) async {
    final uid = _auth.currentUser!.uid;

    final doc = await _db
        .collection("Users")
        .doc(uid)
        .collection("Piutang")
        .doc(id)
        .get();

    final oldData = doc.data();
    final oldSisa = (oldData?['sisa'] ?? 0).toDouble();
    final newSisa = (updatedData['sisa'] ?? oldSisa).toDouble();

    final pelunasan = oldSisa - newSisa;
    print("Pelunasan: $pelunasan");

    await _db
        .collection("Users")
        .doc(uid)
        .collection("Piutang")
        .doc(id)
        .update(updatedData);

    if (pelunasan > 0) {
      try {
        await catatMutasi(
          deskripsi: "Pembayaran Piutang: $namaPelanggan",
          jumlah: pelunasan,
          jenis: 'masuk',
        );
        print("catatMutasi berhasil dicatat.");
      } catch (e) {
        print("Gagal mencatat mutasi: $e");
      }
    } else {
      print("Tidak ada pelunasan, mutasi tidak dicatat.");
    }
  }

  Future<void> hapusPiutang(String id) async {
    final uid = _auth.currentUser!.uid;
    await _db
        .collection("Users")
        .doc(uid)
        .collection("Piutang")
        .doc(id)
        .delete();
  }

  Future<void> hapusPenjualan(String uid, String docId) async {
    await _db
        .collection('Users')
        .doc(uid)
        .collection('penjualan')
        .doc(docId)
        .delete();
  }

  // Mendapatkan UID user yang sedang login
  String get uid => _auth.currentUser!.uid;

  // Referensi ke koleksi MutasiKas user
  CollectionReference get mutasiKasRef => FirebaseFirestore.instance
      .collection('Users')
      .doc(uid)
      .collection('MutasiKas');

  /// Fungsi mencatat transaksi ke MutasiKas
  Future<void> catatMutasi({
    required String deskripsi,
    required double jumlah,
    required String jenis, // 'masuk' atau 'keluar'
    DateTime? tanggal,
  }) async {
    try {
      await mutasiKasRef.add({
        'deskripsi': deskripsi,
        'jumlah': jumlah,
        'jenis': jenis, // hanya "masuk" atau "keluar"
        'tanggal': tanggal ?? DateTime.now(),
      });
    } catch (e) {
      print('Gagal mencatat mutasi: $e');
      rethrow;
    }
  }

  /// Ambil seluruh data MutasiKas (opsional)
  Future<List<Map<String, dynamic>>> getAllMutasi() async {
    final snapshot =
        await mutasiKasRef.orderBy("tanggal", descending: true).get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  /// Hapus mutasi (opsional)
  Future<void> deleteMutasi(String docId) async {
    await mutasiKasRef.doc(docId).delete();
  }

  /// Update mutasi (opsional)
  Future<void> updateMutasi(String docId, Map<String, dynamic> newData) async {
    await mutasiKasRef.doc(docId).update(newData);
  }

  Future<List<StockItem>> getStockItemsOnce() async {
    final uid = _auth.currentUser!.uid;
    final snapshot =
        await _db.collection("Users").doc(uid).collection("BarangJasa").get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return StockItem(
        id: data['id'],
        nama: data['nama'],
        kategori: data['kategori'],
        jenis: data['jenis'],
        kode: data['kode'],
        satuan: data['satuan'],
        jumlah: data['jumlah'],
        harga: (data['harga'] as num).toDouble(),
        totalHarga: (data['totalHarga'] as num).toDouble(),
      );
    }).toList();
  }
}
