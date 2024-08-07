import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techie_ai/service/response_provider.dart';
import 'package:techie_ai/service/description_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'pages/home_page.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<void> main() async {
  // Initialize environment variables
  await dotenv.load(fileName: ".env");

  // Initialize sqflite_ffi
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  // Run the app
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ResponseProvider()),
        ChangeNotifierProvider(create: (context) => DescriptionProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TechieAi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        '/home': (context) => const HomePage(),
        // Define any other routes if needed
      },
    );
  }
}
