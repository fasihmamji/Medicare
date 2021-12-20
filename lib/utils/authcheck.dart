import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:testing_app/screens/homescreen.dart';
import 'package:testing_app/screens/login.dart';

class Authcheck extends StatelessWidget {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      builder: (context, datasnapshot) {
        if (!datasnapshot.hasData) return const Login();
        if (datasnapshot.data == null) return const Login();
        if (datasnapshot.data?.uid == null) {
          return const Login();
        } else {
          return const HomeScreen();
        }
      },
    );
  }
}
