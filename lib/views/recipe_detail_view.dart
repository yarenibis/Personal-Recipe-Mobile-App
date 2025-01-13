import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../viewmodels/recipe_viewmodel.dart';
import 'package:yemek_tarifi/models/recipe_model.dart';

class RecipeDetailView extends StatefulWidget {
  final String recipeId;

  RecipeDetailView({required this.recipeId});

  @override
  _RecipeDetailViewState createState() => _RecipeDetailViewState();
}

class _RecipeDetailViewState extends State<RecipeDetailView> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  // Başlangıç verileri
  String _updatedTitle = '';
  String _updatedDescription = '';
  String _updatedImageUrl = '';

  // Firebase Storage'a resim yüklemek için
  Future<String?> _uploadImage(File image) async {
    try {
      String fileName = 'recipe_images/${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference ref = FirebaseStorage.instance.ref().child(fileName);
      await ref.putFile(image);
      String imageUrl = await ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Resim yükleme hatası: $e');
      return null;
    }
  }

  // Resim seçme işlemi
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final recipeViewModel = Provider.of<RecipeViewModel>(context, listen: false);
    RecipeModel recipe = recipeViewModel.recipes.firstWhere(
        (r) => r.id == widget.recipeId,
        orElse: () => RecipeModel(id: '', title: '', description: '', imageUrl: ''));

    // Başlangıç verilerini güncelliyoruz
    _updatedTitle = _updatedTitle.isEmpty ? recipe.title : _updatedTitle;
    _updatedDescription = _updatedDescription.isEmpty ? recipe.description : _updatedDescription;
    _updatedImageUrl = _updatedImageUrl.isEmpty ? recipe.imageUrl : _updatedImageUrl;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _updatedTitle,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
        ),
        backgroundColor: Color.fromRGBO(52, 73, 94, 1),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _updatedImageUrl.isNotEmpty || _imageFile != null
                ? ClipRRect(
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
                    child: _imageFile != null
                        ? Image.file(_imageFile!, fit: BoxFit.cover, height: MediaQuery.of(context).size.height / 2)
                        : Image.network(_updatedImageUrl, fit: BoxFit.cover, height: MediaQuery.of(context).size.height / 2),
                  )
                : Placeholder(fallbackHeight: MediaQuery.of(context).size.height / 2),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _updatedTitle,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color.fromRGBO(52,73,94,1)),
                  ),
                  SizedBox(height: 16),
                  Text(
                    _updatedDescription,
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    _showEditDialog(context, recipeViewModel, widget.recipeId, _updatedTitle, _updatedDescription, _updatedImageUrl);
                  },
                  icon: Icon(Icons.edit, color: Colors.white),
                  label: Text("Düzenle", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(52,73,94,1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    await recipeViewModel.deleteRecipe(widget.recipeId);
                    // Show Snackbar after deletion
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Tarif başarıyla silindi.")),
                    );
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.delete, color: Colors.white),
                  label: Text("Sil", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 176, 117, 117),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(
    BuildContext context,
    RecipeViewModel recipeViewModel,
    String recipeId,
    String currentTitle,
    String currentDescription,
    String currentImageUrl,
  ) {
    final titleController = TextEditingController(text: currentTitle);
    final descriptionController = TextEditingController(text: currentDescription);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Tarifi Düzenle",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: "Tarif Adı",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: "Açıklama",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 16),
                GestureDetector(
                  onTap: _pickImage,  // Resim seçme işlemi
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.photo, color:  Color.fromRGBO(52, 73, 94, 1), size: 24),  // Fotoğraf ikonunu ekliyoruz
                          SizedBox(width: 8),
                          Text(
                            "Fotoğraf Seç", 
                            style: TextStyle(color:  Color.fromRGBO(52, 73, 94, 1), fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Dialogu kapat
              },
              child: const Text(
                "İptal",
                style: TextStyle(color: Colors.black54),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final updatedTitle = titleController.text.trim();
                final updatedDescription = descriptionController.text.trim();
                String? updatedImageUrl = currentImageUrl;

                // Eğer yeni bir resim seçildiyse, onu Firebase Storage'a yükle
                if (_imageFile != null) {
                  updatedImageUrl = await _uploadImage(_imageFile!);
                }

                if (updatedTitle.isNotEmpty && updatedDescription.isNotEmpty) {
                  await recipeViewModel.updateRecipe(recipeId, updatedTitle, updatedDescription, updatedImageUrl ?? currentImageUrl);

                  // UI'yi güncellemek için setState() kullanıyoruz
                  setState(() {
                    _updatedTitle = updatedTitle;
                    _updatedDescription = updatedDescription;
                    _updatedImageUrl = updatedImageUrl ?? currentImageUrl;
                  });

                  // Show Snackbar after update
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Tarif başarıyla güncellendi.")),
                  );
                  Navigator.pop(context); // Dialogu kapat
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Tüm alanları doldurun.")),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(52,73,94,1),
              ),
              child: const Text(
                "Kaydet",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}




