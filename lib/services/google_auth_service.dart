import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  bool _initialized = false;

  Future<void> _ensureInitialized() async {
    if (_initialized) return;

    await _googleSignIn.initialize(
      // KHÔNG cần clientId trên Android
      // clientId chỉ dùng cho Web / iOS nếu cần
    );

    _initialized = true;
  }

  Future<UserCredential> signInWithGoogle() async {
    await _ensureInitialized();

    // 🔥 API MỚI: authenticate()
    final GoogleSignInAccount googleUser =
    await _googleSignIn.authenticate();

    // 🔥 CHỈ CÓ idToken
    final String? idToken =
        googleUser.authentication.idToken;

    if (idToken == null) {
      throw FirebaseAuthException(
        code: 'GOOGLE_NO_ID_TOKEN',
        message: 'Google did not return an ID token',
      );
    }

    final OAuthCredential credential =
    GoogleAuthProvider.credential(
      idToken: idToken,
    );

    return await _auth.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
