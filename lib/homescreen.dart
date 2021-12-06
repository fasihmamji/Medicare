import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  // const ({ Key? key }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Home', style: TextStyle(color: Colors.blue.shade400)),
        iconTheme: IconThemeData(color: Colors.blue.shade400),
      ),
      drawer: Drawer(
        //want to decrease the size of drawer add container and set its widht

        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue.shade900),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      'MediCare',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                 // Image.asset('assets/img4.png'),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.account_circle, color: Colors.green.shade400),
              title: Text(
                'Profile',
                style: TextStyle(color: Colors.blue.shade400, fontSize: 20),
              ),
            ),
            ListTile(
              leading: Icon(Icons.favorite, color: Colors.pink),
              title: Text(
                'Your Contribution\'s',
                style: TextStyle(color: Colors.blue.shade400, fontSize: 20),
              ),
            ),
            ListTile(
              leading: Icon(Icons.article),
              title: Text(
                'App Details',
                style: TextStyle(color: Colors.blue.shade400, fontSize: 20),
              ),
            ),
            ListTile(
              onTap: (){
                FirebaseAuth.instance.signOut();
              },
              leading: Icon(Icons.arrow_back),
              title: Text(
                'Sign Out',
                style: TextStyle(color: Colors.blue.shade400, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
        //  Image.asset(
          //  'assets/img3.jpg',
         // ),
          Container(
            padding:
            EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 200,
                  width: 150,
                  child: ElevatedButton(
                    onPressed: () => {},
                    child: Text('Hello'),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.lightGreen.shade600),
                  ),
                ),
                SizedBox(
                  height: 200,
                  width: 150,
                  child: ElevatedButton(
                      onPressed: () => {},
                      child: Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 90),
                            child: Text(
                              'Hello',
                              style: TextStyle(fontSize: 20),
                            ),
                          )
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.blue.shade900)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}