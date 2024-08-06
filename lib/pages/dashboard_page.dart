import 'package:flutter/material.dart';
import '../widgets/background_wrapper.dart';
import '../pages/option_screen/options_screen.dart'; // Import the OptionsScreen

class DashboardPage extends StatelessWidget {
  final String name;

  const DashboardPage({required this.name, super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundWrapper(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Left Side: Photo
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: MediaQuery.of(context).size.width * 0.3,
                    // decoration: const BoxDecoration(
                    //   shape: BoxShape.circle,
                    //   image: DecorationImage(
                    //     image: AssetImage(
                    //         'assets/photo.jpg'), // Replace with the actual image path
                    //     fit: BoxFit.cover,
                    //   ),
                    // ),
                  ),
                  const SizedBox(width: 20.0),
                  // Right Side: Greeting and Button
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                            shape: const CircleBorder(), backgroundColor: Colors.blue,
                            padding: const EdgeInsets.all(16), // Change the color as needed
                          ),
                          child: const Icon(Icons.add),
                        ),
                      ],
                    ),
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
