import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class AnimatedWelcomeText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedTextKit(
      animatedTexts: [
        TypewriterAnimatedText(
          'Welcome to your Home Page!',
          textStyle: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(101, 197, 153, 10),
          ),
          speed: const Duration(milliseconds: 150),
        ),
        TypewriterAnimatedText(
          'We are excited to have you here!',
          textStyle: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w600,
            color: Color.fromARGB(255, 255, 0, 21),
          ),
          speed: const Duration(milliseconds: 150),
        ),
        TypewriterAnimatedText(
          'Explore and enjoy the features!',
          textStyle: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.normal,
            color: Color.fromARGB(255, 65, 122, 136),
          ),
          speed: const Duration(milliseconds: 150),
        ),
      ],
      totalRepeatCount: 1,
      onFinished: () {
        // Optional: Add actions when the animation finishes
      },
    );
  }
}
