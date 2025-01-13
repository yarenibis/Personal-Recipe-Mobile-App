import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:yemek_tarifi/viewmodels/recipe_viewmodel.dart';

class RecipeAddView extends StatefulWidget {
  final String userId;

  RecipeAddView({required this.userId});

  @override
  _RecipeAddViewState createState() => _RecipeAddViewState();
}

class _RecipeAddViewState extends State<RecipeAddView> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  File? _imageFile;

  final _formKey = GlobalKey<FormState>();

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final recipeViewModel = Provider.of<RecipeViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Yeni Tarif Ekle",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
        ),
        backgroundColor: Color.fromRGBO(52, 73, 94, 1),
        iconTheme: const IconThemeData(
          color: Colors.white, // Geri butonunun rengini beyaz yapar
        ),
      ),
      body: Stack(
        children: [
          // Arka plan resmi
          Positioned.fill(
            child: Image.asset(
              "assets/pic3.jpg",
              fit: BoxFit.cover,
            ),
          ),
          // Blur ve kart yapısı
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.black.withOpacity(0.2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Center(
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: Colors.white.withOpacity(0.9),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            labelText: "Tarif Adı",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Tarif adı boş bırakılamaz.";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _descriptionController,
                          decoration: InputDecoration(
                            labelText: "Açıklama",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Açıklama boş bırakılamaz.";
                            }
                            return null;
                          },
                          maxLines: 3,
                        ),
                        SizedBox(height: 16),
                        _imageFile == null
                            ? TextButton.icon(
                                onPressed: _pickImage,
                                icon: Icon(Icons.photo, color: Color.fromRGBO(52, 73, 94, 1)),
                                label: const Text(
                                  "Fotoğraf Seç",
                                  style: TextStyle(color: Color.fromRGBO(52, 73, 94, 1)),
                                ),
                              )
                            : Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.file(
                                      _imageFile!,
                                      height: 150,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: _pickImage,
                                    child: Text(
                                      "Başka Fotoğraf Seç",
                                      style: TextStyle(color: Color.fromRGBO(52, 73, 94, 1)),
                                    ),
                                  ),
                                ],
                              ),
                        SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              if (_imageFile == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Lütfen bir fotoğraf seçin.")),
                                );
                                return;
                              }

                              final title = _titleController.text.trim();
                              final description = _descriptionController.text.trim();

                              await recipeViewModel.addRecipe(
                                widget.userId,
                                title,
                                description,
                                _imageFile!,
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Tarif başarıyla eklendi.")),
                              );

                              Navigator.pop(context); // Geri dön
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(52, 73, 94, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: Text(
                            "Tarifi Ekle",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}


