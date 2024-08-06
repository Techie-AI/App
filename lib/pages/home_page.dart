import 'package:flutter/material.dart';
import '../widgets/welcome_text.dart'; // Ensure this import matches the path to your AnimatedWelcomeText widget
import 'option_screen/options_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Define colors with opacity
    final List<Color> gradientColors = [
      const Color(0xFF141821).withOpacity(0.7), // Darkest color with opacity
      const Color(0xFF1b202c).withOpacity(0.7),
      const Color(0xFF222937).withOpacity(0.7),
      const Color(0xFF293243).withOpacity(0.7),
      const Color(0xFF303b4f).withOpacity(0.7), // Lightest color with opacity
    ];

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Full-screen image
          Image.asset(
            'assets/background.webp',
            fit: BoxFit.cover,
          ),
          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          // Main content
          Column(
            children: <Widget>[
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      AnimatedWelcomeText(), // Remove `const` here
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Positioned button
          Positioned(
            bottom:
                MediaQuery.of(context).size.height * 0.300, // Relative position
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
