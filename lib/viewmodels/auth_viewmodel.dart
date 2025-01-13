import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthViewModel extends ChangeNotifier { //auth işlemleri ve uı değişimi (provider ile)
  final AuthService _authService = AuthService();
  UserModel? _currentUser;
  String _errorMessage = ''; 
  String get errorMessage => _errorMessage;

  UserModel? get currentUser => _currentUser;
  String get userId => _currentUser?.uid ?? ""; // userId özelliği

  /// Başlangıçta mevcut kullanıcıyı yükle
  AuthViewModel() {
    _initializeCurrentUser();
  }

  Future<void> _initializeCurrentUser() async {
    try {
      _currentUser = await _authService.getCurrentUser();
      notifyListeners();
    } catch (e) {
      debugPrint("Mevcut kullanıcı yüklenirken hata: $e");
    }
  }



// E-posta formatı doğrulama (sadece '@' karakterinin olup olmadığını kontrol et)
bool _isValidEmail(String email) {
  // Eğer e-posta adresi '@' karakterini içermiyorsa false döner
  if (!email.contains('@')) {
    return false; // Hatalı e-posta
  }
  return true; // Geçerli e-posta
}




  /// E-posta ve şifre ile giriş
  Future<bool> loginWithEmail(String email, String password) async {
    try {
      _currentUser = await _authService.signInWithEmail(email, password);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("E-posta ile giriş hatası: $e");
      
      return false;
    }
  }


  /// Google ile giriş
  Future<bool> loginWithGoogle() async {
    try {
      _currentUser = await _authService.signInWithGoogle();
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Google ile giriş hatası: $e");
      return false;
    }
  }

  /// E-posta ve şifre ile kayıt ol
 /* Future<bool> registerWithEmail(String email, String password) async {
    try {
      _currentUser = await _authService.registerWithEmail(email, password);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Kayıt olma hatası: $e");
      return false;
    }
  }*/


  // E-posta ve şifre ile kayıt ol
  Future<bool> registerWithEmail(String email, String password) async {
    if (!_isValidEmail(email)) {
  _errorMessage = "Geçersiz e-posta! E-posta adresiniz '@' karakterini içermelidir.";
  notifyListeners();
  return false;
}

    try {
      _currentUser = await _authService.registerWithEmail(email, password);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Kayıt olma hatası: $e");
      _errorMessage = "Kayıt başarısız. Lütfen tekrar deneyin!";
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
  try {
    // Firebase'den çıkış yap
    await _authService.logout();
    _currentUser = null; // Kullanıcıyı sıfırla
    notifyListeners(); // UI'ı güncelle
  } catch (e) {
    debugPrint("Çıkış yaparken hata: $e");
  }
}

  /// Kullanıcı oturumu var mı?
  bool isUserLoggedIn() {
    return _currentUser != null;
  }
}


