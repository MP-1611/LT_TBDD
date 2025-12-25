import 'package:flutter/material.dart';
import '../data/auth_repository.dart';

class AuthController {
  final AuthRepository _repo = AuthRepository();

  Future<void> loginEmail({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      await _repo.loginWithEmail(email, password);
      _goNext(context);
    } catch (e) {
      _showError(context, e.toString());
    }
  }

  Future<void> registerEmail({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      await _repo.registerWithEmail(email, password);
      _goNext(context);
    } catch (e) {
      _showError(context, e.toString());
    }
  }

  Future<void> loginGoogle(BuildContext context) async {
    try {
      await _repo.signInWithGoogle();
      _goNext(context);
    } catch (e) {
      _showError(context, e.toString());
    }
  }

  Future<void> loginFacebook(BuildContext context) async {
    try {
      await _repo.signInWithFacebook();
      _goNext(context);
    } catch (e) {
      _showError(context, e.toString());
    }
  }

  void _goNext(BuildContext context) {
    // TODO: chuyển sang Gender / Onboarding
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
