import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

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
          stream: db
              .collection('Users')
              .doc(widget.currentUser?.uid)
              .collection('Requests')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError)
              return Center(
                child: Text('No Medicines Requested yet'),
              );
            if (snapshot.data == null)
              return Center(
                child: Text('No Medicines Requested yet'),
              );
            if (snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No Medicines Requested yet'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: Text('No Medicines Requested yet'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot doc = snapshot.data!.docs[index];

                  Map<String, dynamic> data =
                      doc.data() as Map<String, dynamic>;
                  DateTime date = data['requested_on'].toDate();
                  var format = DateFormat('dd-MM-yyyy ');

                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Card(
                        child: Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Colors.grey,
                                  offset: const Offset(2.0, 4.0),
                                  blurRadius: 4),
                            ],
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text('Medicine Name: '),
                                      Text(data['medicine_name']),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text('Requested On: '),
                                      Text(format.format(date)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text('Donator: '),
                                      Text(data['donator_name']),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text('Quantity: '),
                                      Text(data['quantity'].toString()),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      GestureDetector(
                                          child: Icon(Icons.done),
                                          onTap: () {
                                            db.collection('Transactions').add({
                                              "medicine_name":
                                                  data['medicine_name'],
                                              "quantity": data['quantity'],
                                              "donor_id": data['donator_id'],
                                              "reciever_id":
                                                  widget.currentUser?.uid,
                                              "transaction_date": DateTime.now()
                                            }).then((value) {
                                              db
                                                  .collection('Users')
                                                  .doc(widget.currentUser?.uid)
                                                  .collection('Requests')
                                                  .doc(doc.id)
                                                  .delete();
                                            }).then((value) {
                                              db
                                                  .collection('Market')
                                                  .doc(doc.id)
                                                  .delete();
                                            }).then((value){
                                              db
                                                .collection('Users')
                                                .doc(data['donator_id'])
                                                .collection('Donations')
                                                .doc(doc.id)
                                                .delete();
                                            });
                                          }),
                                      GestureDetector(
                                          child: Icon(Icons.clear),
                                          onTap: () {
                                            db
                                                .collection('Users')
                                                .doc(data['donator_id'])
                                                .collection('Donations')
                                                .doc(doc.id)
                                                .update({
                                              "requested_by": null
                                            }).then((value) {
                                              db
                                                  .collection('Market')
                                                  .doc(doc.id)
                                                  .update({
                                                "requested_by": null
                                              }).then((value) {
                                                db
                                                    .collection('Users')
                                                    .doc(
                                                        widget.currentUser?.uid)
                                                    .collection('Requests')
                                                    .doc(doc.id)
                                                    .delete();
                                              });
                                            });
                                          }),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
