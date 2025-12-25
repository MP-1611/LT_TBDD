import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progress;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _progress = Tween<double>(begin: 0.0, end: 0.35).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();

    Timer(const Duration(seconds: 3), () {
      // TODO: điều hướng sang Login / Onboarding
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF112117),
                  Color(0xFF0F1F16),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          /// Glow effects
          Positioned(
            top: -200,
            left: -200,
            child: _glow(Colors.greenAccent.withOpacity(0.12), 600),
          ),
          Positioned(
            bottom: -150,
            right: -150,
            child: _glow(const Color(0xFF06B6D4).withOpacity(0.12), 500),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 2 - 150,
            left: MediaQuery.of(context).size.width / 2 - 150,
            child: _glow(Colors.white.withOpacity(0.05), 300),
          ),

          /// Main content
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 80),

              /// Mascot + Title
              Column(
                children: [
                  _Mascot(),
                  const SizedBox(height: 32),

                  RichText(
                    text: const TextSpan(
                      text: "Aqua",
                      style: TextStyle(
                        fontSize: 44,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      children: [
                        TextSpan(
                          text: "Mate",
                          style: TextStyle(color: Color(0xFF36E27B)),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white.withOpacity(0.08)),
                    ),
                    child: const Text(
                      "Stay Hydrated, Stay Sharp",
                      style: TextStyle(
                        color: Color(0xFF9EB7A8),
                        fontSize: 14,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),

              /// Bottom
              Column(
                children: [
                  AnimatedBuilder(
                    animation: _progress,
                    builder: (_, __) {
                      return Container(
                        width: 220,
                        height: 6,
                        decoration: BoxDecoration(
                          color: const Color(0xFF3D5245).withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: _progress.value,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF36E27B),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF36E27B)
                                      .withOpacity(0.8),
                                  blurRadius: 12,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.lock, size: 14, color: Color(0xFF36E27B)),
                      SizedBox(width: 6),
                      Text(
                        "SECURE & PRIVATE",
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 10,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ],
          ),
        ],
      ),
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

/// Mascot widget
class _Mascot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1A3826),
            Color(0xFF0F1F16),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: Border.all(
          color: const Color(0xFF36E27B).withOpacity(0.2),
          width: 6,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF36E27B).withOpacity(0.2),
            blurRadius: 30,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Image.asset(
          "assets/images/mascot.png",
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
