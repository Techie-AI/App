import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:techie_ai/pages/result_page/result_page.dart';
import 'package:techie_ai/widgets/animated_text.dart';
import 'package:techie_ai/widgets/typing_text.dart';
import 'package:techie_ai/pages/option_screen/options_screen.dart';
import 'package:techie_ai/pages/home_page.dart';
import '../widgets/background_wrapper.dart';
import '../pages/result_page/database_helper.dart';

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
    _resultsFuture = DatabaseHelper().getResults();
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

  double responsiveFontSize(BuildContext context, double size) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;

    // Adjust font size based on screen width
    if (screenWidth > 1200) {
      return size * 1.5; // Large screens
    } else if (screenWidth > 800) {
      return size * 1.2; // Medium screens
    } else {
      return size; // Small screens
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLargeScreen = mediaQuery.size.width > 600;

    return BackgroundWrapper(
      child: Padding(
        padding: EdgeInsets.all(isLargeScreen ? 60.0 : 20.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          Container(
                            width: isLargeScreen ? 160.0 : 80.0,
                            height: isLargeScreen ? 160.0 : 80.0,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage('assets/photo.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hello,',
                                  style: TextStyle(
                                    fontSize: responsiveFontSize(context, 32),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                AnimatedText(
                                  name: widget.name,
                                  fontSize: 32,
                                ),
                                const SizedBox(height: 10.0),
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: isLargeScreen
                                        ? constraints.maxWidth * 0.6
                                        : constraints.maxWidth * 0.4,
                                  ),
                                  child: TypingText(
                                    text: 'How can I help you Today?',
                                    highlightColor: const LinearGradient(
                                      colors: <Color>[
                                        Colors.blue,
                                        Colors.purple
                                      ],
                                    ),
                                    textStyle: TextStyle(
                                      fontSize: responsiveFontSize(context, 18),
                                      color: Colors
                                          .white, // Ensure text color is set
                                    ), highlightText: 'Today?',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _logout(context),
                      child: Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: responsiveFontSize(context, 16),
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Center(
                  child: Container(
                    width: isLargeScreen ? 300.0 : constraints.maxWidth * 0.8,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OptionsScreen(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 12.0,
                        ),
                      ),
                      child: Text(
                        'Build new PC',
                        style: TextStyle(
                          fontSize: responsiveFontSize(context, 24),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 60.0),
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
                                margin:
                                    const EdgeInsets.symmetric(vertical: 8.0),
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
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            responsiveFontSize(context, 16),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      'Name: $name',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            responsiveFontSize(context, 16),
                                      ),
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
            );
          },
        ),
      ),
    );
  }
}
