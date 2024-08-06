import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class AnimatedWelcomeText extends StatefulWidget {
  const AnimatedWelcomeText({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AnimatedWelcomeTextState createState() => _AnimatedWelcomeTextState();
}

class _AnimatedWelcomeTextState extends State<AnimatedWelcomeText>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Techie-AI',
            style: TextStyle(
              fontSize: screenWidth * 0.08,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(
              height:
                  20), // Adjust the spacing between the title and animated text
          AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText(
                'PC-Builder',
                textStyle: TextStyle(
                  fontSize: screenWidth * .02,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
                speed: const Duration(milliseconds: 200),
              ),
              TypewriterAnimatedText(
                'Build Your Dream PC',
                textStyle: TextStyle(
                  fontSize: screenWidth * .02,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
                speed: const Duration(milliseconds: 200),
              ),
              TypewriterAnimatedText(
                'Customize Components',
                textStyle: TextStyle(
                  fontSize: screenWidth * .02,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
                speed: const Duration(milliseconds: 200),
              ),
            ],
            onTap: () {
              print("Tap Event");
            },
            repeatForever: true,
          ),
        ],
      ),
    );
  }
}
