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

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return BackgroundWrapper(
      child: Padding(
        padding: EdgeInsets.all(screenSize.width * 0.05),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Container(
                        width: screenSize.width * 0.3,
                        height: screenSize.width * 0.3,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage('assets/photo.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello,',
                              style: TextStyle(
                                fontSize: screenSize.width * 0.08,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            AnimatedText(name: widget.name),
                            const SizedBox(height: 10.0),
                            TypingText(
                              text: 'How can I help you',
                              highlightText: 'today',
                              highlightColor: const LinearGradient(
                                colors: <Color>[Colors.blue, Colors.purple],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Use Flexible or SizedBox for responsive button
                Flexible(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () => _logout(context),
                      child: Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: screenSize.width * 0.04,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenSize.width * 0.03,
                          vertical: screenSize.height * 0.015,
                        ), backgroundColor: const Color.fromARGB(255, 255, 255, 255), // Customize button color
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: Center(
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
                          builder: (context) => const OptionsScreen(),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenSize.width * 0.1,
                        vertical: screenSize.height * 0.02,
                      ),
                    ),
                    child: Text(
                      'Build new PC',
                      style: TextStyle(
                        fontSize: screenSize.width * 0.05,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Expanded(
              flex: 3,
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
                            margin: EdgeInsets.symmetric(
                                vertical: screenSize.height * 0.01),
                            padding: EdgeInsets.all(screenSize.width * 0.04),
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
                                    fontSize: screenSize.width * 0.04,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Name: $name',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenSize.width * 0.04,
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
        ),
      ),
    );
  }
}
