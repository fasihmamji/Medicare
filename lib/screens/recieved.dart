import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Recieved extends StatefulWidget {
  final User? currentUser;

  const Recieved({Key? key, this.currentUser}) : super(key: key);

  @override
  State<Recieved> createState() => _RecievedState();
}

class _RecievedState extends State<Recieved> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.teal.shade900,
          title: Text(
            'My Recieving Listing',
            style: TextStyle(
              fontSize: 22,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: db.collection('Donations').snapshots(),
          builder: (context, medicineSnapshot) {
            if (medicineSnapshot.hasError)
              return Center(
                child: Text('error'),
              );
            if (medicineSnapshot.data == null)
              return Center(
                child: Text('data null'),
              );
            if (medicineSnapshot.data!.docs.isEmpty) {
              return Center(child: Text('No donated medicines'));
            }
            if (medicineSnapshot.connectionState == ConnectionState.waiting)
              return Center(child: Text('waiting'));
            List<Map<String, dynamic>?> userReqs = [];
            medicineSnapshot.data!.docs.forEach((doc) async {
              await db
                  .collection('Donations')
                  .doc(doc.id)
                  .collection('Requests')
                  .doc(widget.currentUser?.uid)
                  .get()
                  .then((doc) {
                if (doc.exists) {
                  userReqs.add(doc.data());
                }
              });
            });

            return ListView.builder(
                itemCount: userReqs.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> requested =
                      userReqs[index] as Map<String, dynamic>;
                  print(requested);

                  return Text(
                    '01',
                    style: TextStyle(color: Colors.black),
                  );
                });
          },
        ),
      ),
    );
  }
}
