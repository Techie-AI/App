import 'package:flutter/material.dart';
import '../widgets/footer.dart';
import '../widgets/welcome_text.dart';
import '../widgets/header.dart';
import 'options_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFafafaf),
                  Color(0xFFc2c2c2),
                  Color(0xFFd6d6d6),
                  Color(0xFFeaeaea),
                  Color(0xFFFFFFFF),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          // Main content
          Column(
            children: <Widget>[
              Header(),
              const Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      AnimatedWelcomeText(),
                    ],
                  ),
                ),
              ),
              const Footer(),
            ],
          ),
          // Positioned button
          Positioned(
            bottom: 350, // Distance from the bottom of the screen
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OptionsScreen(),
                    ),
                  );
                },
                child: const Text('Get Started'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
