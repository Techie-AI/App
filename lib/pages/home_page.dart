import 'package:flutter/material.dart';
import '../widgets/welcome_text.dart'; // Ensure this import matches the path to your AnimatedWelcomeText widget
import '../widgets/LoginPage.dart'; // Import the LoginScreen
import 'dashboard_page.dart'; // Import the DashboardPage
import '../service/login/google_sign_in_provider.dart'; // Import the GoogleSignInProvider
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GoogleSignInProvider _googleSignInProvider = GoogleSignInProvider();
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString('user');
    if (userData != null) {
      Map<String, dynamic> userMap =
          Map<String, dynamic>.from(json.decode(userData));
      setState(() {
        _user = UserModel.fromMap(userMap);
      });
      // If user is already signed in, navigate to DashboardPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => DashboardPage(name: _user!.displayName)),
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
                onPressed: () async {
                  final googleUser = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                  if (googleUser != null) {
                    final user = UserModel(
                      displayName: googleUser.displayName ?? '',
                      email: googleUser.email,
                    );
                    await _saveUser(user);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DashboardPage(name: user.displayName)),
                    );
                  }
                },
                child: const Text('Get Started'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveUser(UserModel user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', json.encode(user.toMap()));
  }
}
