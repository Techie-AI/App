import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart'; // Import path package
import 'package:techie_ai/pages/result_page/result_page.dart';
import '../widgets/background_wrapper.dart';
import '../pages/option_screen/options_screen.dart'; // Import the OptionsScreen
import '../pages/home_page.dart'; // Import the HomePage

class DashboardPage extends StatefulWidget {
  final String name;

  const DashboardPage({required this.name, super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Future<List<Map<String, dynamic>>> _resultsFuture;

  @override
  void initState() {
    super.initState();
    _resultsFuture = _fetchResults();
  }

  Future<List<Map<String, dynamic>>> _fetchResults() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'result_data.db');

    final database = await openDatabase(path, version: 1);

    // Assuming you have a table called 'results' with columns 'id', 'date', 'name', and 'data'
    final List<Map<String, dynamic>> results = await database.query('results');
    return results;
  }

  Future<void> _logout(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('name');
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundWrapper(
      child: Padding(
        padding: const EdgeInsets.all(60.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Photo and greeting text
                Row(
                  children: [
                    Container(
                      width: 160.0, // Increase size
                      height: 160.0, // Increase size
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage(
                              'assets/photo.jpg'), // Replace with the actual image path
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Hello,',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        AnimatedText(name: widget.name),
                        const SizedBox(
                            height: 10.0), // Add spacing between the texts
                        TypingText(
                          text: 'How can I help you',
                          highlightText: 'today',
                          highlightColor: const LinearGradient(
                            colors: <Color>[Colors.blue, Colors.purple],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // Logout button
                ElevatedButton(
                  onPressed: () => _logout(context),
                  child: const Text('Logout'),
                ),
              ],
            ),
            const Spacer(),
            // NEW Build text button with round background
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const OptionsScreen(), // Navigate to OptionsScreen
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 12.0,
                    ),
                  ),
                  child: const Text(
                    'Build new PC',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 60.0),
            // Previous Results section
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _resultsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'No previous results found',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  } else {
                    final results = snapshot.data!;
                    return ListView.builder(
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        final result = results[index];
                        final date = result['date'];
                        final name = result['name'];
                        final String? data = result['data'];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ResultPage.withPreviousData(
                                  previousResultData: data,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[900],
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Date: $date',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Name: $name',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedText extends StatefulWidget {
  final String name;

  const AnimatedText({required this.name, Key? key}) : super(key: key);

  @override
  _AnimatedTextState createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<AnimatedText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: <Color>[Colors.blue, Colors.purple],
              stops: [
                0.0,
                _controller.value,
              ],
              tileMode: TileMode.mirror,
            ).createShader(bounds);
          },
          child: Text(
            widget.name,
            style: const TextStyle(
              fontSize: 42, // Increase size
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}

class TypingText extends StatefulWidget {
  final String text;
  final String highlightText;
  final LinearGradient highlightColor;

  const TypingText({
    required this.text,
    required this.highlightText,
    required this.highlightColor,
    Key? key,
  }) : super(key: key);

  @override
  _TypingTextState createState() => _TypingTextState();
}

class _TypingTextState extends State<TypingText>
    with SingleTickerProviderStateMixin {
  String displayText = '';

  @override
  void initState() {
    super.initState();
    _typeText();
  }

  Future<void> _typeText() async {
    for (var char in widget.text.split('')) {
      await Future.delayed(const Duration(milliseconds: 100));
      setState(() {
        displayText += char;
      });
    }

    // Add the highlight text "today" after typing the initial text
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() {
      displayText += ' ${widget.highlightText}';
    });
  }

  @override
  Widget build(BuildContext context) {
    // Split the text into two parts
    final List<String> textParts = displayText.split(widget.highlightText);
    return Row(
      children: [
        Text(
          textParts[0],
          style: const TextStyle(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        if (textParts.length > 1) ...[
          ShaderMask(
            shaderCallback: (bounds) {
              return widget.highlightColor.createShader(bounds);
            },
            child: Text(
              widget.highlightText,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Set color to white here
              ),
            ),
          ),
          Text(
            textParts[1],
            style: const TextStyle(
              fontSize: 24,
              color: Colors.white,
            ),
          ),
        ],
      ],
    );
  }
}
