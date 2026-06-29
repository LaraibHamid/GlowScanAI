import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String get uid {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }
    return user.uid;
  }

  Future<DocumentSnapshot> getUserProfile() async {
    return await _firestore.collection('users').doc(uid).get();
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(uid).set({
      ...data,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> saveScan(String imageUrl) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('scans')
        .add({
      'imageUrl': imageUrl,
      'status': 'pending',
      'acneScore': 0,
      'oilLevel': 0,
      'textureScore': 0,
      'skinHealthScore': 0,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getUserScans() {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('scans')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> saveReminder(String title, String time) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('reminders')
        .add({
      'title': title,
      'time': time,
      'isActive': true,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> saveChatMessage(String userMessage, String aiResponse) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('chatbot_history')
        .add({
      'userMessage': userMessage,
      'aiResponse': aiResponse,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
