import 'package:testing_app/inputwrapper.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  // const ({ Key? key }) : super(key: key)


  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/login.png'), fit: BoxFit.cover)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 70, left: 14),
                  child: const Text(
                    'Welcome to Medicare\n ',
                    style: TextStyle(
                        fontFamily: 'Lobster',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 29),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.45,
                      left: 35,
                      right: 35),
                  child: Inputwrapper(),
                ),
              ],
            ),
          ),
        ));
  }
}