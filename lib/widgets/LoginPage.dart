import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/dashboard_page.dart';

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

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _nameFocusNode = FocusNode();

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
    return Scaffold(
      body: Container(
        color: Colors.black, 
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
                      color: const Color(
                          0xFF303030), 
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Form(
                          key: _formKey,
                          onChanged: _validateInputs,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              // Add Logo and App Name
                              Image.asset(
                                'assets/login.png', // Update with your logo asset path
                                height: 100,
                                width:
                                    100, // Adjust the width and height as needed
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(height: 16.0),
                              const Text(
                                'TechieAi', // Replace with your app name
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white, // Text color
                                ),
                              ),
                              const SizedBox(height: 32.0),
                              _buildTextField(
                                controller: _emailController,
                                label: 'Enter your email',
                                icon: Icons.email,
                                focusNode: _emailFocusNode,
                                nextFocusNode: _nameFocusNode,
                                onSubmitted: (_) {
                                  _nameFocusNode
                                      .requestFocus(); // Move focus to the name field
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  if (!RegExp(r'^[a-zA-Z]{2,}')
                                      .hasMatch(value)) {
                                    return 'Email must start with at least two alphabets';
                                  }
                                  if (!value.endsWith('@gmail.com')) {
                                    return 'Please enter a Gmail address';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16.0),
                              _buildTextField(
                                controller: _nameController,
                                label: 'Enter your name',
                                icon: Icons.person,
                                focusNode: _nameFocusNode,
                                onSubmitted: (_) {
                                  _login(); // Call login when Enter is pressed
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your name';
                                  }
                                  if (value.length < 2) {
                                    return 'Name must be at least two characters';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 32.0),
                              ElevatedButton(
                                onPressed: _isButtonEnabled ? _login : null,
                                style: ElevatedButton.styleFrom(
                                  elevation: 5,
                                  backgroundColor: Colors
                                      .blue, // Button background color matching the theme
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0,
                                    vertical: 12.0,
                                  ),
                                ),
                                child: const Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors
                                        .white, // Button text color matching the theme
                                  ),
                                ),
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
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required FocusNode focusNode,
    FocusNode? nextFocusNode,
    void Function(String)? onSubmitted,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0), // Rounded corners
          borderSide: const BorderSide(color: Colors.white), // Border color
        ),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white), // Label text color
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(
              color: Colors.white), // Border color when enabled
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide:
              const BorderSide(color: Colors.blue), // Border color when focused
        ),
        prefixIcon:
            Icon(icon, color: Colors.white), // Icon inside the input field
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.0), // Padding inside the text field
      ),
      style: const TextStyle(color: Colors.white), // Text color
      validator: validator,
      onFieldSubmitted: (value) {
        if (onSubmitted != null) {
          onSubmitted(value);
        } else if (nextFocusNode != null) {
          nextFocusNode.requestFocus(); // Move to the next field if provided
        }
      },
    );
  }
}
