import 'package:flutter/material.dart';
import '../widgets/footer.dart';
import '../widgets/video_section.dart';
import '../widgets/image_section.dart';
import '../widgets/welcome_text.dart';
import '../widgets/header.dart';
import 'options_screen.dart';
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                  const SizedBox(height: 20),
                  VideoSection(),
                  const SizedBox(height: 20),
                  ImageSection(),
                ],
              ),
            ),
          ),
          const Footer(),
        ],
      ),
    );
  }
}
