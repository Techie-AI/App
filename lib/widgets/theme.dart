import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.blue,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.blue,
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.blue,
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.blueGrey,
  ),
);

// Define the dark gradient as a decoration
BoxDecoration darkGradientBackground = const BoxDecoration(
  gradient: LinearGradient(
    colors: [
      Color(0xFF303b4f),
      Color(0xFF293243),
      Color(0xFF222937),
      Color(0xFF1b202c),
      Color(0xFF141821),
    ],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  ),
);
