import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Settingspass extends StatefulWidget {
  @override
  _SettingspassState createState() => _SettingspassState();
}

class _SettingspassState extends State<Settingspass> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blueGrey,
        automaticallyImplyLeading: true,
        title: Text(
          'Reset Password',
          style: TextStyle(fontSize: 30),
        ),
      ),
      body: Stack(
        children: [
          // Positioned(
          //   top: -100,
          //   child: Image.asset(
          //     'assets/login.png',
          //     fit: BoxFit.cover,
          //   ),
          // ),
          // const Padding(
          //   padding: EdgeInsets.only(top: 100, left: 50),
          //   child: Text(
          //     'Reset Password',
          //     style: TextStyle(
          //         // fontFamily: 'Lobster',
          //         color: Colors.black,
          //         fontWeight: FontWeight.bold,
          //         fontSize: 45),
          //   ),
          // ),
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.4,
              right: 35,
              left: 35,
            ),
            child: ListView(
              children: [
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    fillColor: Colors.grey.shade200,
                    filled: true,
                    labelText: 'Email',
                    hintText: 'Current Email',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Icon(Icons.email),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: ElevatedButton(
                    child:const Text(
                      'Verify',
                      style: TextStyle(fontSize: 22),
                    ),
                    onPressed: () {
                      auth.sendPasswordResetEmail(email: emailController.text);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
