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
  }

  Future<List<Map<String, dynamic>>> getDaftarPiutang() async {
    final uid = _auth.currentUser!.uid;
    final snapshot = await _db
        .collection("Users")
        .doc(uid)
        .collection("Piutang")
        .get();
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
  }

  Future<List<Map<String, dynamic>>> getPenjualan(String uid) async {
    final snapshot = await _db.collection('Users').doc(uid).collection('penjualan').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['docId'] = doc.id;
      return data;
    }).toList();
  }


  Future<void> updatePiutang(String id, Map<String, dynamic> updatedData) async {
    final uid = _auth.currentUser!.uid;
    await _db
        .collection("Users")
        .doc(uid)
        .collection("Piutang")
        .doc(id)
        .update(updatedData);
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
    await _db.collection('Users').doc(uid).collection('penjualan').doc(docId).delete();
  }

}  
