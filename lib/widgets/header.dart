import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.blue,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image.asset(
          //   'assets/images/logo.png',
          //   height: 80,
          // ),
          const SizedBox(width: 10),
          Text(
            'TecheAi',
            style: TextStyle(
              fontSize: 28,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
