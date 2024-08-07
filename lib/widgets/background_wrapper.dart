import 'package:flutter/material.dart';

class BackgroundWrapper extends StatelessWidget {
  final Widget child;

  const BackgroundWrapper({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/background.webp',
            fit: BoxFit.cover,
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.black,
            ),
          ),
          child,
        ],
      ),
    );
  }
}
