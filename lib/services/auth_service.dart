import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();


  /// Mevcut kullanıcıyı al
  Future<UserModel?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      return UserModel(
        uid: user.uid,
        email: user.email,
        displayName: user.displayName,
      );
    }
    return null;
  }

  // Kullanıcıyı dönüştür
  UserModel? _userFromFirebaseUser(User? user) {
    if (user == null) return null;
    return UserModel(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
    );
  }

  // Şifre ve E-posta ile giriş
  Future<UserModel?> signInWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return _userFromFirebaseUser(result.user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Şifre ve E-posta ile kayıt
  Future<UserModel?> registerWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return _userFromFirebaseUser(result.user);
    } catch (e) {
      print("Kayıt hatası: ${e.toString()}");
      return null;
    }
  }
  


Future<UserModel?> signInWithGoogle() async {
  try {
    // Öncelikle çıkış yaparak mevcut oturumları sonlandırıyoruz
    await _googleSignIn.signOut();

    // Kullanıcıdan her seferinde hesap seçmesini istiyoruz
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    if (googleUser == null) {
      // Eğer kullanıcı bir hesap seçmezse, null döner
      return null;
    }

    // Seçilen Google hesabı için kimlik doğrulama işlemi
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Firebase ile oturum açma
    UserCredential result = await _auth.signInWithCredential(credential);

    return _userFromFirebaseUser(result.user);
  } catch (e) {
    print("Google ile giriş hatası: ${e.toString()}");
    return null;
  }
}



Future<void> logout() async {
  try {
    // Firebase ile çıkış yap
    await _auth.signOut();
    print("Kullanıcı oturumu kapatıldı.");

    // Burada, auth state listener veya diğer kullanıcı yönetim işlemlerini güncelleyebilirsiniz.
  } catch (e) {
    print("Oturum sonlandırma sırasında hata oluştu: $e");
    throw e;  // Hata durumunda istisna fırlatılabilir
  }
}

}

