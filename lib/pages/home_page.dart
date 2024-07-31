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
                  Color(0xFF2c0537),
                  Color(0xFF004081),
                  Color(0xFF007bb6),
                  Color(0xFF00b5c2),
                  Color(0xFF12eba9),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Main content
          Column(
            children: <Widget>[
              Header(),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      AnimatedWelcomeText(),
                      const SizedBox(height: 20),
                      ElevatedButton(
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
                      const SizedBox(height: 200),
                    ],
                  ),
                ),
              ),
              const Footer(),
            ],
          ),
        ],
      ),
    );
  }
}
