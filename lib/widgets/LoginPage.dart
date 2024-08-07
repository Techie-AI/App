import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../service/login/google_sign_in_provider.dart';
import '../pages/dashboard_page.dart'; // Import the DashboardPage

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GoogleSignInProvider _googleSignInProvider = GoogleSignInProvider();
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString('user');
    if (userData != null) {
      Map<String, dynamic> userMap =
          Map<String, dynamic>.from(json.decode(userData));
      setState(() {
        _user = UserModel.fromMap(userMap);
      });
      // If user is already signed in, navigate to DashboardPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => DashboardPage(name: _user!.displayName)),
      );
    }
  }

  Future<void> _saveUser(UserModel user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', json.encode(user.toMap()));
  }

  Future<void> _signIn() async {
    // Mobile sign-in
    final googleUser = await _googleSignInProvider.signInWithGoogle();
    if (googleUser != null) {
      final user = UserModel(
        displayName: googleUser.displayName ?? '',
        email: googleUser.email,
      );
      await _saveUser(user);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => DashboardPage(name: user.displayName)),
      );
    }
  }

  Future<void> _signOut() async {
    await _googleSignInProvider.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    setState(() {
      _user = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Sign-In Demo'),
      ),
      body: Center(
        child: _user == null
            ? ElevatedButton(
                onPressed: _signIn,
                child: Text('Sign in with Google'),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Name: ${_user!.displayName}'),
                  Text('Email: ${_user!.email}'),
                  ElevatedButton(
                    onPressed: _signOut,
                    child: Text('Sign Out'),
                  ),
                ],
              ),
      ),
    );
  }
}
