import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:testing_app/appdetails.dart';
import 'package:testing_app/donations.dart';
import 'package:testing_app/market.dart';
import 'package:testing_app/myprofile.dart';
import 'package:testing_app/recieved.dart';
import 'package:testing_app/update_password.dart';

class HomeScreen extends StatefulWidget {
  // const ({ Key? key }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  var pages = [Market(), Donation(), Recieved(), Myprofile()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          currentIndex: selectedIndex,
          backgroundColor: Colors.blue,
          unselectedLabelStyle: TextStyle(color: Colors.black),
          showSelectedLabels: true,
          showUnselectedLabels: true,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, color: Colors.black),
              label: 'Market',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.done_all_outlined, color: Colors.black),
              label: 'Donations',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_task, color: Colors.black),
              label: 'Recieved',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline, color: Colors.black),
              label: 'Profile',
            ),
          ]),
      body: pages[selectedIndex],
    );
  }
}
