import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/recipe_viewmodel.dart';
import 'views/login_view.dart';
import 'views/register_view.dart';
import 'views/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider( //her iki ViewModel'e de erişim sağlanabilir ve UI her değişiklikte güncellenebilir.
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()), // Kullanıcı yönetimi
        ChangeNotifierProvider(create: (_) => RecipeViewModel()), // Tarif yönetimi
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Yemek Tarifleri',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: AuthHandler(), // Giriş ve yönlendirme ekranı
      routes: { //ekranları arasında yönlendirme
        '/home': (context) => HomeView(userId: Provider.of<AuthViewModel>(context).userId),
        '/register': (context) => RegisterView(),
        '/login': (context) => LoginView(),
      },
    );
  }
}

class AuthHandler extends StatelessWidget { //kullanıcının giriş yapıp yapmadığını kontrol eder ve buna göre yönlendirme yapar:
  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    // Kullanıcı giriş yaptıysa HomeView'e yönlendir
    if (authViewModel.isUserLoggedIn()) {
      return HomeView(userId: authViewModel.userId); // Giriş yapılmışsa ana sayfa
    } else {
      return LoginView(); // Giriş yapılmamışsa giriş sayfası
    }
  }
}









