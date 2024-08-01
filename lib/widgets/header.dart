import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF274fa8),
            Color(0xFF0072c0),
            Color(0xFF0090bf),
          ],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      width: double.infinity,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Uncomment and provide your logo path if needed
          // Image.asset(
          //   'assets/images/logo.png',
          //   height: 80,
          // ),
          SizedBox(width: 10),
          Text(
            'TecheAi',
            style: TextStyle(
              fontSize: 30,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
