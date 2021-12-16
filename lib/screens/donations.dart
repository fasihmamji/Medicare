// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:testing_app/widgets/DonationForm.dart';

class Donation extends StatelessWidget {
  const Donation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Donation'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return DonationForm();
          }));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
