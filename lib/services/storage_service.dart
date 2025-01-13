import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImage(File image, String userId) async {
    final ref = _storage.ref().child('images/$userId/${DateTime.now().toIso8601String()}'); 
    //Resimler, images/ adlı bir ana klasöre ve ardından kullanıcıya ait userId klasörüne kaydedilir.
    await ref.putFile(image);
    return await ref.getDownloadURL();
  }
}
