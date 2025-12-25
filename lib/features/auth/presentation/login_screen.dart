import 'package:flutter/material.dart';
import 'package:h20_reminder/features/auth/presentation/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLogin = true;
  bool obscurePassword = true;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final authController = AuthController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF112117),
      body: Stack(
        children: [
          /// Background gradient
          Container(
            height: MediaQuery.of(context).size.height * 0.6,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF1A382E),
                  Color(0xFF112117),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          /// Green glow
          Positioned(
            top: -80,
            right: -80,
            child: _glow(const Color(0xFF36E27B).withOpacity(0.2), 280),
          ),

          /// Main content
          Column(
            children: [
              const SizedBox(height: 60),

              /// Mascot
              SizedBox(
                height: 220,
                child: Image.asset(
                  "assets/images/mascot_login.png",
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                "Stay hydrated, stay sharp.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 24),

              /// Card
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1A2620),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(40),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 12),

                        /// Handle
                        Container(
                          width: 48,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),

                        const SizedBox(height: 24),

                        /// Tabs
                        _buildTabs(),

                        const SizedBox(height: 28),

                        /// Email
                        _InputField(
                          label: "Email Address",
                          hint: "student@aquamate.com",
                          icon: Icons.mail_outline,
                          controller: emailController,
                        ),

                        const SizedBox(height: 20),

                        /// Password
                        _InputField(
                          label: "Password",
                          hint: "••••••••",
                          icon: Icons.lock_outline,
                          controller: passwordController,
                          obscure: obscurePassword,
                          suffix: IconButton(
                            icon: Icon(
                              obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.white54,
                            ),
                            onPressed: () {
                              setState(() {
                                obscurePassword = !obscurePassword;
                              });
                            },
                          ),
                        ),

                        const SizedBox(height: 12),

                        if (isLogin)
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              child: const Text(
                                "Forgot Password?",
                                style: TextStyle(color: Colors.white54),
                              ),
                            ),
                          ),

                        const SizedBox(height: 8),

                        /// Login Button
                        _PrimaryButton(
                          text: isLogin ? "Log In" : "Register",
                          onPressed: () {
                            if (isLogin) {
                              authController.loginEmail(
                                context: context,
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                              );
                            } else {
                              authController.registerEmail(
                                context: context,
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                              );
                            }
                          },
                        ),

                        const SizedBox(height: 24),

                        _divider(),

                        const SizedBox(height: 20),

                        /// Social login
                        Row(
                          children: [
                            Expanded(
                              child: _SocialButton(
                                text: "Google",
                                icon: Icons.g_mobiledata,
                                onTap: () {
                                  authController.loginGoogle(context);
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _SocialButton(
                                text: "Facebook",
                                icon: Icons.facebook,
                                onTap: () {
                                  authController.loginFacebook(context);
                                },
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        const Text(
                          "By continuing, you agree to our Terms of Service & Privacy Policy",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white38,
                          ),
                        ),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      height: 52,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFF111714),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          _tabItem("Login", isLogin, () {
            setState(() => isLogin = true);
          }),
          _tabItem("Register", !isLogin, () {
            setState(() => isLogin = false);
          }),
        ],
      ),
    );
  }

  Widget _tabItem(String text, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? const Color(0xFF2C3E33) : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: active ? const Color(0xFF36E27B) : Colors.white54,
            ),
          ),
        ),
      ),
    );
  }

  Widget _divider() {
    return Row(
      children: const [
        Expanded(child: Divider(color: Colors.white24)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            "OR CONTINUE WITH",
            style: TextStyle(
              color: Colors.white38,
              fontSize: 11,
              letterSpacing: 1.5,
            ),
          ),
        ),
        Expanded(child: Divider(color: Colors.white24)),
      ],
    );
  }

  Widget _glow(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}

/// ---------------- WIDGETS ----------------

class _InputField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final bool obscure;
  final Widget? suffix;

  const _InputField({
    required this.label,
    required this.hint,
    required this.icon,
    required this.controller,
    this.obscure = false,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 6),
          child: Text(
            label,
            style: const TextStyle(color: Colors.white70),
          ),
        ),
        TextField(
          controller: controller,
          obscureText: obscure,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white38),
            prefixIcon: Icon(icon, color: Colors.white38),
            suffixIcon: suffix,
            filled: true,
            fillColor: const Color(0xFF111714),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const _PrimaryButton({required this.text, required this.onPressed});


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF36E27B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D1F15),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward, color: Color(0xFF0D1F15)),
          ],
        ),
      ),
    );
  }

}

class _SocialButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;

  const _SocialButton({
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: const Color(0xFF111714),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

