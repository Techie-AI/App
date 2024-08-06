import 'package:flutter/material.dart';

class BackgroundWrapper extends StatelessWidget {
  final Widget child;

  const BackgroundWrapper({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    final List<Color> gradientColors = [
      const Color(0xFF1a447a),
      const Color(0xFF1b4177),
      const Color(0xFF1c3e73),
      const Color(0xFF1d3b70),
      const Color(0xFF1e386c),
      const Color(0xFF1f3466),
      const Color(0xFF1f3160),
      const Color(0xFF1f2d5a),
      const Color(0xFF1e2851),
      const Color(0xFF1d2348),
      const Color(0xFF1b1e3f),
      const Color(0xFF191937),
    ];

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/background.webp',
            fit: BoxFit.cover,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
