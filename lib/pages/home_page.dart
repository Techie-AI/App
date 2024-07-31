import 'package:flutter/material.dart';
import '../widgets/welcome_text.dart';
import '../widgets/header.dart';

class HomePage extends StatelessWidget {
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
                  WelcomeText(),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Add your onPressed code here!
                    },
                    child: Text('Get Started'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
