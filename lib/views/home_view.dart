import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yemek_tarifi/viewmodels/auth_viewmodel.dart';
import 'package:yemek_tarifi/viewmodels/recipe_viewmodel.dart';
import 'package:yemek_tarifi/views/recipe_detail_view.dart';
import 'package:yemek_tarifi/views/recipe_add_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yemek_tarifi/views/login_view.dart';

class HomeView extends StatefulWidget {
  final String userId;

  HomeView({required this.userId});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  TextEditingController _searchController = TextEditingController();
  List filteredRecipes = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterRecipes); // kullanıcı arama yaparken tarifler dinamik olarak filtrelenir.
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterRecipes);
    _searchController.dispose();
    super.dispose();
  }

  // Arama fonksiyonu
  void _filterRecipes() {
    final recipeViewModel = Provider.of<RecipeViewModel>(context, listen: false);
    final query = _searchController.text;

    if (query.isNotEmpty) {
      filteredRecipes = recipeViewModel.recipes
          .where((recipe) => recipe.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } else {
      filteredRecipes = List.from(recipeViewModel.recipes);
    }
    setState(() {}); //uı'daki değişiklikleri günceller
  }

  Future<void> _logout(BuildContext context) async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    try {
      await authViewModel.logout();
      await FirebaseAuth.instance.signOut();
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginView()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Çıkış yapılamadı.")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Çıkış yapılamadı. Tekrar deneyin.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final recipeViewModel = Provider.of<RecipeViewModel>(context);
    recipeViewModel.fetchRecipes(widget.userId);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tariflerim",
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 24, color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(52,73,94,1),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Bulanıklaştırılmış arka plan resmi
          Positioned.fill(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Image.asset(
                "assets/pic6a.jpg",
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              // Arama çubuğu
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Tarif Ara...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              // Tarifler Listesi
              Expanded(
                child: recipeViewModel.recipes.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.no_food, size: 80, color: const Color.fromARGB(255, 227, 226, 226)),
                            SizedBox(height: 20),
                            Text(
                              "Henüz tarif yok.",
                              style: TextStyle(fontSize: 18, color: Colors.black54),
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        padding: EdgeInsets.all(10),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: filteredRecipes.isNotEmpty ? filteredRecipes.length : recipeViewModel.recipes.length,
                        itemBuilder: (context, index) {
                          final recipe = filteredRecipes.isNotEmpty
                              ? filteredRecipes[index]
                              : recipeViewModel.recipes[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => RecipeDetailView(recipeId: recipe.id),
                                ),
                              );
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                                      child: recipe.imageUrl.isNotEmpty
                                          ? Image.network(
                                              recipe.imageUrl,
                                              fit: BoxFit.cover,
                                            )
                                          : Container(
                                              color: Colors.grey.shade300,
                                              child: Icon(
                                                Icons.image,
                                                size: 50,
                                                color: Colors.grey,
                                              ),
                                            ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          recipe.title,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          recipe.description,
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 12,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RecipeAddView(userId: widget.userId),
            ),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Color.fromRGBO(52,73,94,1),
      ),
    );
  }
}




