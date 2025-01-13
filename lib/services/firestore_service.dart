import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createRecipe(Map<String, dynamic> data) async {
    await _firestore.collection('recipes').add(data);
  }

  Stream<List<Map<String, dynamic>>> getRecipes(String userId) {
    return _firestore
        .collection('recipes')
        .where('userId', isEqualTo: userId)
        .snapshots() //Bu, veri değişikliklerini dinler,yeni verileri alır listeye dönüştürür
        .map((snapshot) => snapshot.docs
            .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}) //tüm özellikleri birleştirip döndürür
            .toList());
  }

  Future<void> updateRecipe(String recipeId, Map<String, dynamic> data) async {
    await _firestore.collection('recipes').doc(recipeId).update(data);
  }

  Future<void> deleteRecipe(String recipeId) async {
    await _firestore.collection('recipes').doc(recipeId).delete();
  }
}
