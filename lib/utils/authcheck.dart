import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:testing_app/screens/homescreen.dart';
import 'package:testing_app/screens/login.dart';
import 'package:testing_app/screens/update_password.dart';

class Authcheck extends StatelessWidget {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      builder: (context, datasnapshot) {
        if (!datasnapshot.hasData) return Login();
        if (datasnapshot.data == null) return Login();
        if (datasnapshot.data?.uid == null) {
          return Login();
        } else {
          return HomeScreen();
        }
      },
    );
  }
}
