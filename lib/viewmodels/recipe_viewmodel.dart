import 'dart:io';

import 'package:flutter/foundation.dart';
import '../models/recipe_model.dart';
import '../services/firestore_service.dart';
import '../services/storage_service.dart';

class RecipeViewModel extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final StorageService _storageService = StorageService();

  List<RecipeModel> recipes = [];

  Future<void> fetchRecipes(String userId) async {
    _firestoreService.getRecipes(userId).listen((data) {
      recipes = data
          .map((e) => RecipeModel.fromMap(e['id'], e))
          .toList();
      notifyListeners();
    });
  }

  Future<void> addRecipe(String userId, String title, String description, File image) async {
    String imageUrl = await _storageService.uploadImage(image, userId);
    await _firestoreService.createRecipe({
      'userId': userId,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
    });
  }

  Future<void> updateRecipe(
  String recipeId, 
  String title, 
  String description, 
  String? imageUrl,
) async {
  // Yeni verilerle güncelleme işlemi
  Map<String, dynamic> data = {
    'title': title,
    'description': description,
    if (imageUrl != null) 'imageUrl': imageUrl,  // Eğer yeni bir resim varsa, imageUrl de eklenir.
  };
  
  // Firestore'da güncelleme işlemi
  await _firestoreService.updateRecipe(recipeId, data);
}


 Future<void> deleteRecipe(String recipeId) async {
  try {
    // Firestore'dan tarif silme işlemi
    await _firestoreService.deleteRecipe(recipeId);

    // Silinen tarifi yerel listeden kaldır
    recipes.removeWhere((recipe) => recipe.id == recipeId);

    // UI'yı güncelle
    notifyListeners();

    print("Tarif başarıyla silindi: $recipeId");
  } catch (e) {
    print("Silme işlemi başarısız: $e");
    throw Exception("Silme işlemi başarısız oldu.");
  }
}




}
