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
      backgroundColor: Color(0xfff9f7fb),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: BottomNavigationBar(
            onTap: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
            currentIndex: selectedIndex,
            backgroundColor: Colors.teal.shade900,
            unselectedLabelStyle:
                Theme.of(context).bottomNavigationBarTheme.unselectedLabelStyle,
            selectedLabelStyle: TextStyle(color: Colors.white),
            showSelectedLabels: true,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.view_list, color: Colors.white),
                label: 'Market',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.done_all_outlined, color: Colors.white),
                label: 'Donations',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_task, color: Colors.white),
                label: 'Recieved',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline, color: Colors.white),
                label: 'Profile',
              ),
            ]),
      ),
      body: pages[selectedIndex],
    );
  }
}
