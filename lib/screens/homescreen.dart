import 'package:flutter/material.dart';
import 'package:testing_app/screens/donations.dart';
import 'package:testing_app/screens/market.dart';
import 'package:testing_app/screens/myprofile.dart';
import 'package:testing_app/screens/recieved.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

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
