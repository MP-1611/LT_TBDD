import 'package:flutter/material.dart';

class ExpOverlay extends StatefulWidget {
  final int level;
  final int currentXp;
  final int xpToNext;
  final Duration visibleDuration;

  const ExpOverlay({
    super.key,
    required this.level,
    required this.currentXp,
    required this.xpToNext,
    this.visibleDuration = const Duration(seconds: 5),
  });

  @override
  State<ExpOverlay> createState() => _ExpOverlayState();
}

class _ExpOverlayState extends State<ExpOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _slide = Tween<Offset>(
      begin: const Offset(0, 1), // 👇 dưới màn hình
      end: const Offset(0, 0),   // 👆 hiện lên
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _showThenHide();
  }

  Future<void> _showThenHide() async {
    await _controller.forward(); // slide up

    await Future.delayed(widget.visibleDuration);

    if (!mounted) return;
    await _controller.reverse(); // slide down

    if (mounted) {
      Navigator.of(context).pop(); // remove overlay
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress =
    (widget.currentXp / widget.xpToNext).clamp(0.0, 1.0);

    return Positioned(
      left: 16,
      right: 16,
      bottom: 24,
      child: SlideTransition(
        position: _slide,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1C2620),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Level ${widget.level}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progress,
                  minHeight: 10,
                  backgroundColor: Colors.black26,
                  valueColor: const AlwaysStoppedAnimation(
                    Color(0xFF36E27B),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                const SizedBox(height: 6),
                Text(
                  "${widget.currentXp} / ${widget.xpToNext} XP",
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
