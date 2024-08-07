import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<GoogleSignInAccount?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      return googleUser;
    } catch (e) {
      print(e); // Handle errors here
      return null;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}

class UserModel {
  final String displayName;
  final String email;

  UserModel({required this.displayName, required this.email});

  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'email': email,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      displayName: map['displayName'],
      email: map['email'],
    );
  }
}
