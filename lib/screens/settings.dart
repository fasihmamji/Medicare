import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Settingspass extends StatefulWidget {
  const Settingspass({Key? key}) : super(key: key);

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
        backgroundColor: Colors.teal.shade900,
        automaticallyImplyLeading: true,
        title: const Text(
          'Reset Password',
          style: TextStyle(fontSize: 20),
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
          Padding(
            padding: EdgeInsets.only(top: 150, left: 30),
            child: Container(
              child: Text(
                "Enter Your Current Email",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              top: 200,
              // MediaQuery.of(context).size.height * 0.4,
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
                    style: ElevatedButton.styleFrom(
                      primary: Colors.teal.shade900,
                    ),
                    child: const Text(
                      'Verify',
                      style: TextStyle(fontSize: 22),
                    ),
                    onPressed: () {
                      try {
                        auth
                            .sendPasswordResetEmail(email: emailController.text)
                            .then((value) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            
                              content: Text(
                                  'A password reset link is successfully sent on ${emailController.text}')));
                        });
                      } on FirebaseAuthException catch (err) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${err.message}')));
                      }
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
