import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techie_ai/service/response_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'pages/home_page.dart';
import 'package:techie_ai/pages/options_screen.dart';
import 'package:techie_ai/service/chat_service.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        // Add other providers here if necessary
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Techie AI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: OptionsScreen(),
    );
  }
}
