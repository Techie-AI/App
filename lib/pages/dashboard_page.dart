import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/background_wrapper.dart';
import '../pages/option_screen/options_screen.dart'; // Import the OptionsScreen
import '../pages/home_page.dart'; // Import the HomePage

class DashboardPage extends StatelessWidget {
  final String name;

  const DashboardPage({required this.name, super.key});

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
                          image: AssetImage('assets/photo.jpg'), // Replace with the actual image path
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
                        AnimatedText(name: name),
                        const SizedBox(height: 10.0), // Add spacing between the texts
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
                        builder: (context) => const OptionsScreen(), // Navigate to OptionsScreen
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
            // Previous Results placeholder
            AnimatedGlowBox(
              child: Container(
                width: double.infinity,
                height: 500.0,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 48, 48, 48),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: const Center(
                  child: Text(
                    'Previous Results',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
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
                color: Colors.white,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class AnimatedGlowBox extends StatefulWidget {
  final Widget child;

  const AnimatedGlowBox({required this.child, Key? key}) : super(key: key);

  @override
  _AnimatedGlowBoxState createState() => _AnimatedGlowBoxState();
}

class _AnimatedGlowBoxState extends State<AnimatedGlowBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
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
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.5 + 0.5 * _controller.value),
                spreadRadius: 8,
                blurRadius: 16,
              ),
            ],
          ),
          child: widget.child,
        );
      },
    );
  }
}
