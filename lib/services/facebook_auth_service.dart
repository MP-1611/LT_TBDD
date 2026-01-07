import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FacebookAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Đăng nhập Facebook
  Future<UserCredential> signInWithFacebook() async {
    try {
      // 1️⃣ Login Facebook
      final LoginResult result =
      await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (result.status != LoginStatus.success) {
        throw Exception("Facebook sign in failed");
      }

      // 2️⃣ Lấy access token
      final AccessToken accessToken = result.accessToken!;

      // 3️⃣ Tạo Firebase credential (API MỚI)
      final OAuthCredential credential =
      FacebookAuthProvider.credential(
        accessToken.tokenString, // ✅ API MỚI
      );
      // 4️⃣ Login Firebase
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      rethrow;
    }
  }

  /// Logout Facebook
  Future<void> signOut() async {
    await FacebookAuth.instance.logOut();
    await _auth.signOut();
  }
}


