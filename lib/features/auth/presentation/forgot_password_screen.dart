import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailCtrl = TextEditingController();
  bool loading = false;

  Future<void> _sendResetLink() async {
    final email = _emailCtrl.text.trim();

    if (email.isEmpty) {
      _showSnack("Please enter your email");
      return;
    }

    try {
      setState(() => loading = true);

      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );

      if (!mounted) return;

      _showSnack("Reset link sent! Check your email ✉️");
    } on FirebaseAuthException catch (e) {
      _showSnack(e.message ?? "Something went wrong");
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF112117),
      body: SafeArea(
        child: Column(
          children: [
            _appBar(),
            _mascot(),
            Expanded(child: _content()),
          ],
        ),
      ),
    );
  }

  // ================= UI =================

  Widget _appBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                "Forgot Password?",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _mascot() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Image.asset(
        "assets/images/mascot_login.png", // 🔥 đổi theo asset của bạn
        width: 200,
      ),
    );
  }

  Widget _content() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      decoration: const BoxDecoration(
        color: Color(0xFF1A2620),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(40),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          const SizedBox(height: 24),

          const Text(
            "Enter your email address and we will send you instructions to reset your password.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 24),

          _emailInput(),
          const SizedBox(height: 24),

          _sendButton(),
          const Spacer(),

          _backToLogin(),
        ],
      ),
    );
  }

  Widget _emailInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 12, bottom: 6),
          child: Text(
            "Email Address",
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        TextField(
          controller: _emailCtrl,
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF111714),
            prefixIcon:
            const Icon(Icons.mail, color: Color(0xFF36E27B)),
            hintText: "student@aquamate.com",
            hintStyle: const TextStyle(color: Colors.white38),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _sendButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: loading ? null : _sendResetLink,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF36E27B),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: loading
            ? const SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.black,
          ),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "Send Reset Link",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.send, color: Colors.black),
          ],
        ),
      ),
    );
  }

  Widget _backToLogin() {
    return TextButton.icon(
      onPressed: () => Navigator.pop(context),
      icon: const Icon(Icons.keyboard_backspace,
          color: Colors.white38, size: 18),
      label: const Text(
        "Back to Login",
        style: TextStyle(
          color: Colors.white38,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
