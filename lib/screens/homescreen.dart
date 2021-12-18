import 'package:firebase_auth/firebase_auth.dart';
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
  FirebaseAuth auth = FirebaseAuth.instance;

  int selectedIndex = 0;
  User? currentUser;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    var user = auth.currentUser;
    // var userData = await db.collection('Users').doc(user?.uid).get();
    // var data = userData.data() as Map<String, dynamic>;

    setState(() {
      currentUser = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    var pages = [
      Market(
        currentUser: currentUser,
      ),
      Donation(
        currentUser: currentUser,
      ),
      Recieved(
        currentUser: currentUser,
      ),
      Myprofile(
        currentUser: currentUser,
      )
    ];

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
