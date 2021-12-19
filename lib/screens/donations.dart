// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:testing_app/widgets/DonationForm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Donation extends StatefulWidget {
  final User? currentUser;

  const Donation({Key? key, this.currentUser}) : super(key: key);

  @override
  State<Donation> createState() => _DonationState();
}

class _DonationState extends State<Donation> {
  FirebaseAuth auth = FirebaseAuth.instance;

  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.teal.shade900,
          title: Text(
            'My Donation Listing',
            style: TextStyle(
              fontSize: 22,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return DonationForm();
            }));
          },
          child: Icon(
            Icons.add,
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: db
              .collection('Users')
              .doc(widget.currentUser?.uid)
              .collection('Donations')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError)
              return Center(
                child: Text('Error loading Medicines'),
              );
            if (snapshot.data == null)
              return Center(child: Text('No Donated Medicines'));
            if (snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No Donated Medicines'));
            }
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: Text('Fetching Medicines'));
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot doc = snapshot.data!.docs[index];
                  Map<String, dynamic> data =
                      doc.data() as Map<String, dynamic>;
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Card(
                      child: ExpansionTile(
                        trailing: GestureDetector(
                          onTap: () {
                            db
                                .collection('Market')
                                .doc(doc.id)
                                .delete()
                                .then((value) {
                              db
                                  .collection('Users')
                                  .doc(widget.currentUser?.uid)
                                  .collection('Donations')
                                  .doc(doc.id)
                                  .delete();
                            }).then((value) {
                              if (data['requested_by'] != null) {
                                db
                                    .collection('Users')
                                    .doc(data['requested_by'])
                                    .collection('Requests')
                                    .doc(doc.id)
                                    .delete();
                              }
                            });
                          },
                          child: Icon(Icons.delete),
                        ),
                        title: Text(data['medicine_name']),
                        subtitle:
                            Text('Quantity: ${data['quantity'].toString()}'),
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
                        ],
                      ),
                    ),
                  );
                });
          },
        ));
  }
}
