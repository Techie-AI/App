import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/welcome_text.dart';
import '../pages/dashboard_page.dart';
import '../widgets/LoginPage.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _navigateBasedOnLoginStatus(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? email = prefs.getString('email');
    final String? name = prefs.getString('name');

    if (email != null && name != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardPage(name: name),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
    }
  }

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
          const Column(
            children: <Widget>[
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      AnimatedWelcomeText(),
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
                onPressed: () => _navigateBasedOnLoginStatus(context),
                child: const Text('Get Started'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
