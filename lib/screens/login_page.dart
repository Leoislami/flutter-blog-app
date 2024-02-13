import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signIn() async {
    try {
      // Sign in with Firebase Auth
      UserCredential userCredential = await _auth.signInWithProvider(GoogleAuthProvider());
      print('Signed in user: ${userCredential.user!.uid}');
      // Navigate to the next screen after successful login
    } catch (e) {
      print('Error signing in: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Firebase Auth'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _signIn,
          child: const Text('Sign in anonymously'),
        ),
      ),
    );
  }
}