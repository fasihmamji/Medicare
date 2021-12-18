import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:testing_app/screens/editprofile.dart';
import 'package:testing_app/screens/myinfo.dart';
import 'package:testing_app/screens/settings.dart';

class Myprofile extends StatefulWidget {
  final User? currentUser;
  const Myprofile({Key? key, this.currentUser}) : super(key: key);

  @override
  State<Myprofile> createState() => _MyprofileState();
}

class _MyprofileState extends State<Myprofile> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Card cardTile(leading, title, onTap) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: Colors.brown.shade100,
          child: Icon(
            leading,
            color: Colors.black,
          ),
        ),
        title: Text(title),
        trailing: Icon(Icons.chevron_right),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    return Scaffold(
      backgroundColor: Colors.teal.shade900,
      appBar: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text('Profile',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          actions: [
            TextButton(
                child: Text(
                  'Log Out',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  auth.signOut();
                })
          ]),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: StreamBuilder<DocumentSnapshot>(
          stream: users.doc(widget.currentUser?.uid).snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }

            if (snapshot.hasData && !snapshot.data!.exists) {
              return Text("Document does not exist");
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              return ListView(
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.teal.shade300,
                        radius: 40,
                        child: Icon(
                          Icons.verified_user,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${data['fname']} ${data['lname']}",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "${data['email']}",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    child: Divider(
                      thickness: 0.5,
                      height: 20,
                      indent: 20,
                      endIndent: 20,
                      color: Colors.grey.shade100,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 36),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Donated',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            )),
                        Text('Recieved',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 36),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text('10'),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: Text('5'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 55,
                  ),
                  Container(
                    child: Column(
                      children: [
                        cardTile(Icons.directions_walk, 'My Listing', () {}),
                        cardTile(Icons.info, 'Your Information', () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  fullscreenDialog: true,
                                  builder: (context) {
                                    return MyInfo(
                                      address: data['address'],
                                      phone: data['phoneno'],
                                      dob: data['dob'],
                                      age: data['age'],
                                      cnic: data['cnic'],
                                      country: data['country'],
                                      city: data['city'],
                                      zip: data['zip'],
                                    );
                                  }));
                        }),
                        cardTile(Icons.logout, 'Edit Profile', () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return Editprofile(
                              uid: widget.currentUser?.uid,
                              fname: data['fname'],
                              lname: data['lname'],
                              address: data['address'],
                              phoneno: data['phoneno'],
                              country: data['country'],
                              city: data['city'],
                              zip: data['zip'],
                            );
                          }));
                        }),
                        cardTile(Icons.settings, 'Settings', () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return Settingspass();
                          }));
                        }),
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
