import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/dashboard_page.dart';
import '../widgets/background_wrapper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? email = prefs.getString('email');
    final String? name = prefs.getString('name');

    if (email != null && name != null) {
      _navigateToDashboard(email, name);
    }
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      final String email = _emailController.text;
      final String name = _nameController.text;

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', email);
      await prefs.setString('name', name);

      _navigateToDashboard(email, name);
    }
  }

  void _navigateToDashboard(String email, String name) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DashboardPage(name: name),
      ),
    );
  }

  void _validateInputs() {
    setState(() {
      _isButtonEnabled =
          _emailController.text.isNotEmpty && _nameController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundWrapper(
      child: Center(
        child: SingleChildScrollView(
          child: LayoutBuilder(
            builder: (context, constraints) {
              double padding = constraints.maxWidth * 0.1;
              double cardWidth = constraints.maxWidth * 0.8;

              if (constraints.maxWidth > 600) {
                padding = constraints.maxWidth * 0.15;
                cardWidth = constraints.maxWidth * 0.30;
              }

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: padding),
                child: Container(
                  width: cardWidth,
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        onChanged: _validateInputs,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            // Add Logo and App Name
                            Image.asset(
                              'assets/logo.png', // Update with your logo asset path
                              height: 80,
                            ),
                            const SizedBox(height: 16.0),
                            const Text(
                              'TechieAi', // Replace with your app name
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 32.0),
                            TextFormField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Enter your email',
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!value.endsWith('@gmail.com')) {
                                  return 'Please enter a Gmail address';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16.0),
                            TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Enter your name',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 32.0),
                            ElevatedButton(
                              onPressed: _isButtonEnabled ? _login : null,
                              child: const Text('Login'),
                            ),
                            const SizedBox(height: 16.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
