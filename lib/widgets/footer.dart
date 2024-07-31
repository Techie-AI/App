import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.grey[200],
      width: double.infinity,
      child: const Column(
        children: [
          Text(
            '© 2024 TecheAi',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Follow us on:',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(FontAwesomeIcons.facebook, color: Colors.blue),
              SizedBox(width: 10),
              Icon(FontAwesomeIcons.twitter, color: Colors.blue),
              SizedBox(width: 10),
              Icon(FontAwesomeIcons.instagram, color: Colors.pink),
            ],
          ),
        ],
      ),
    );
  }
}
