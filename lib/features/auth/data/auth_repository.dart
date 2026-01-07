import 'package:firebase_auth/firebase_auth.dart';
import '../../../services/google_auth_service.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleAuthService _googleAuthService = GoogleAuthService();

  // EMAIL
  Future<User?> loginWithEmail(String email, String password) async {
    final result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return result.user;
  }

  Future<User?> registerWithEmail(String email, String password) async {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return result.user;
  }

  // GOOGLE


  Future<User?> loginWithGoogle() async {
    final result = await _googleAuthService.signInWithGoogle();
    return result.user;
  }


  // FACEBOOK (GIỮ NGUYÊN)
  Future<User?> loginWithFacebook() async {
    final LoginResult loginResult =
    await FacebookAuth.instance.login();

    if (loginResult.status != LoginStatus.success) {
      throw FirebaseAuthException(
        code: 'FACEBOOK_LOGIN_FAILED',
        message: loginResult.message,
      );
    }

    final credential = FacebookAuthProvider.credential(
      loginResult.accessToken!.tokenString,
    );

    final result = await _auth.signInWithCredential(credential);
    return result.user;
  }

  Future<void> logout() async {
    await Future.wait([
      _auth.signOut(),
      _googleAuthService.signOut(),
      FacebookAuth.instance.logOut(),
    ]);
  }
}
