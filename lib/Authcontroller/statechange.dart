import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/Authentication/authscreen.dart';

import '../Pages/mainpage.dart';

class Statechange extends StatefulWidget {
  const Statechange({super.key});

  @override
  State<Statechange> createState() => _StatechangeState();
}

class _StatechangeState extends State<Statechange> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          // User is signed in
          if (snapshot.hasData) {
            return Mainpage(); // Show Mainpage if user is signed in
          } else {
            return AuthScreen(); // Show AuthScreen if user is not signed in
          }
        }
        return Center(
            child:
                CircularProgressIndicator()); // Show loading indicator while checking auth state
      },
    );
  }
}
