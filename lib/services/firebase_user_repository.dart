import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseUserRepository {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String get uid => _auth.currentUser!.uid;

  Future saveUserData(Map<String, dynamic> data) async {
    await _db.collection("users").doc(uid).set(
      data,
      SetOptions(merge: true),
    );
  }

  Future<Map<String, dynamic>?> fetchUserData() async {
    final doc = await _db.collection("users").doc(uid).get();
    return doc.data();
  }
  Future<void> incrementStats({int xp = 0, int drops = 0}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final ref = _db.collection('users').doc(user.uid);

    await ref.update({
      'xp': FieldValue.increment(xp),
      'drops': FieldValue.increment(drops),
    });
  }

}

