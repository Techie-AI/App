  import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'package:techie_ai/service/response_provider.dart';
  import 'package:flutter_dotenv/flutter_dotenv.dart';
  import 'pages/home_page.dart';

  Future<void> main() async {
    await dotenv.load(fileName: ".env");

    runApp(
      ChangeNotifierProvider(
        create: (context) => ResponseProvider(),
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
      );
    }
  }
