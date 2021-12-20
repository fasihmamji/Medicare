import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:testing_app/screens/editprofile.dart';
import 'package:testing_app/screens/myinfo.dart';
import 'package:testing_app/screens/settings.dart';
import 'package:testing_app/screens/transactions.dart';

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
      backgroundColor: Color(0xfff9f7fb),
      appBar: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text('Profile',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          actions: [
            TextButton(
                child: Text(
                  'Log Out',
                  style: TextStyle(
                    color: Colors.black,
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
                        backgroundColor: Colors.teal.shade700,
                        radius: 40,
                        child: Icon(
                          Icons.person_sharp,
                          size: 40,
                          color: Colors.black,
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
                                color: Colors.black,
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
                          color: Colors.grey.shade400,
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
                      color: Colors.grey.shade500,
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
                                color: Colors.black,
                                fontWeight: FontWeight.w600)),
                        Text('Recieved',
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  FutureBuilder<QuerySnapshot>(
                      future: firestore.collection('Transactions').get(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Align(
                              alignment: Alignment.center,
                              child: Text('Loading...'));
                        }
                        var donated = 0;
                        var recieved = 0;
                        snapshot.data!.docs.forEach((doc) {
                          var data = doc.data() as Map<String, dynamic>;
                          if (data['donor_id'] == widget.currentUser?.uid) {
                            donated++;
                          } else if (data['reciever_id'] ==
                              widget.currentUser?.uid) {
                            recieved++;
                          }
                        });
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 36),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                child: Text(donated.toString()),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 24),
                                child: Text(recieved.toString()),
                              )
                            ],
                          ),
                        );
                      }),
                  SizedBox(
                    height: 55,
                  ),
                  Container(
                    child: Column(
                      children: [
                        cardTile(Icons.list_outlined, 'Your Transactions',
                            () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Transactions(
                              currentUser: widget.currentUser,
                            );
                          }));
                        }),
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
                        cardTile(Icons.edit, 'Edit Profile', () {
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
