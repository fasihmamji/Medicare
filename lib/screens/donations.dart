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
          child: Icon(Icons.add),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: db
              .collection('Donations')
              .where("created_by", isEqualTo: widget.currentUser?.uid)
              .snapshots(),
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
                  Map<String, dynamic> data =
                      doc.data() as Map<String, dynamic>;
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Card(
                      child: ExpansionTile(
                        trailing: IconButton(
                          onPressed: () {
                            db.collection('Donations').doc(doc.id).delete();
                          },
                          icon: Icon(Icons.delete),
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                    'Donator: ${data['fname']}  ${data['lname']}')),
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
