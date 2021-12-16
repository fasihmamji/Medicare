import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Market extends StatefulWidget {
  @override
  State<Market> createState() => _MarketState();
}

class _MarketState extends State<Market> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  FirebaseAuth auth = FirebaseAuth.instance;
  Map<String, dynamic>? currentUser;
  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    var user = auth.currentUser;
    var userData = await db.collection('Users').doc(user?.uid).get();
    var data = userData.data() as Map<String, dynamic>;

    setState(() {
      currentUser = {
        "uid": user?.uid,
        "name": "${data['fname']} ${data['lname']}"
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<QuerySnapshot>(
      stream: db.collection('Donations').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError)
          return Center(
            child: CircularProgressIndicator(),
          );
        if (snapshot.data == null)
          return Center(
            child: CircularProgressIndicator(),
          );
        if (snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No donated medicines'));
        }
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(child: CircularProgressIndicator());
        return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot doc = snapshot.data!.docs[index];

              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

              return Padding(
                padding: const EdgeInsets.all(18.0),
                child: Card(
                  child: ExpansionTile(
                    title: Text(data['medicine_name']),
                    subtitle: Text('Quantity: ${data['quantity']}'),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                'Manufactured: ${data['manufacturing_date']}')),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Expiry: ${data['expiry_date']}')),
                      ),
                      FutureBuilder<DocumentSnapshot>(
                        future: db
                            .collection('Users')
                            .doc(data['created_by'])
                            .get(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Container();
                          } else {
                            var data =
                                snapshot.data!.data() as Map<String, dynamic>;
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                      'Donated by: ${data['fname']} ${data['lname']} ')),
                            );
                          }
                        },
                      )
                    ],
                  ),
                ),
              );
            });
      },
    ));
  }
}
