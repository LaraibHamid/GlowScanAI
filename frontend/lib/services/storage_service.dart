import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  // Upload Profile Image
  Future<String> uploadProfileImage(File file) async {
    Reference ref = _storage
        .ref()
        .child('user_profiles')
        .child(uid)
        .child('profile.jpg');

    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  // Upload Scan Image
  Future<String> uploadScanImage(File file) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference ref = _storage
        .ref()
        .child('user_scans')
        .child(uid)
        .child('$fileName.jpg');

    await ref.putFile(file);
    return await ref.getDownloadURL();
  }
}
