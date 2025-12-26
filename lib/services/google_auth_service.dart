import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Đăng nhập bằng Google
  Future<UserCredential> signInWithGoogle() async {
    try {
      // 1️⃣ Chọn tài khoản Google
      final GoogleSignInAccount? googleUser =
      await _googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception("Google sign in aborted");
      }

      // 2️⃣ Lấy auth details
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      // 3️⃣ Tạo credential cho Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4️⃣ Đăng nhập Firebase
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      rethrow;
    }
  }

  /// Đăng xuất Google
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
