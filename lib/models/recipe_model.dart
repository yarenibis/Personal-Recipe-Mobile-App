class RecipeModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;

  RecipeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() { //key-value: firestore kaydetmek için
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
    };
  }

  factory RecipeModel.fromMap(String id, Map<String, dynamic> map) { //veritabanından veya API'den alınan bir Map'i alır ve bir RecipeModel nesnesi oluşturur.
    return RecipeModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }
}
