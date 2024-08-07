import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/background_wrapper.dart';
import '../pages/option_screen/options_screen.dart'; // Import the OptionsScreen
import '../pages/home_page.dart'; // Import the HomePage

class DashboardPage extends StatelessWidget {
  final String name;

  const DashboardPage({required this.name, super.key});

  Future<void> _logout(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('name');
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundWrapper(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Photo at the top
              Container(
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.width * 0.3,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/photo.jpg'), // Replace with the actual image path
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              // Greeting and Button below the photo
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Hello,',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const OptionsScreen(), // Navigate to OptionsScreen
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.all(
                          16), // Change the color as needed
                    ),
                    child: const Icon(Icons.add),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () => _logout(context),
                    child: const Text('Logout'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
