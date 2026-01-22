import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../routes/app_routes.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool loading = false;
  String? error;

  Future<void> _resetPassword() async {
    final newPass = _newCtrl.text.trim();
    final confirm = _confirmCtrl.text.trim();

    if (newPass.length < 6) {
      setState(() => error = "Password must be at least 6 characters");
      return;
    }

    if (newPass != confirm) {
      setState(() => error = "Passwords do not match");
      return;
    }

    try {
      setState(() {
        loading = true;
        error = null;
      });

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() => error = "User not logged in");
        return;
      }

      await user.updatePassword(newPass);

      // ✅ SIGN OUT
      await FirebaseAuth.instance.signOut();

      if (!mounted) return;

      // ✅ THÔNG BÁO
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password changed. Please login again."),
        ),
      );

      // ✅ VỀ LOGIN + CLEAR STACK
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.login,
            (_) => false,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        error = e.code == 'requires-recent-login'
            ? "Please re-login and try again"
            : e.message;
      });
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF112117),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Reset Password"),
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // 🔒 ICON
            Container(
              height: 220,
              width: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF36E27B).withOpacity(0.1),
              ),
              child: const Center(
                child: Icon(Icons.lock, size: 80, color: Color(0xFF36E27B)),
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              "Create New Password",
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Your new password must be different\nfrom previous passwords.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF9EB7A8)),
            ),

            const SizedBox(height: 32),

            _passwordInput(
              controller: _newCtrl,
              hint: "New Password",
              icon: Icons.lock,
            ),
            const SizedBox(height: 16),
            _passwordInput(
              controller: _confirmCtrl,
              hint: "Confirm New Password",
              icon: Icons.lock_reset,
            ),

            if (error != null) ...[
              const SizedBox(height: 12),
              Text(error!, style: const TextStyle(color: Colors.red)),
            ],

            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF36E27B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                onPressed: loading ? null : _resetPassword,
                child: loading
                    ? const CircularProgressIndicator(color: Colors.black)
                    : const Text(
                  "Reset Password",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _passwordInput({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      obscureText: true,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38),
        filled: true,
        fillColor: const Color(0xFF1C2620),
        prefixIcon: Icon(icon, color: const Color(0xFF36E27B)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
