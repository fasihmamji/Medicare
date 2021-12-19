import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Transactions extends StatefulWidget {
  final User? currentUser;
  const Transactions({Key? key, this.currentUser}) : super(key: key);

  @override
  _TransactionsState createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal.shade900,
        title: Text("Your Transactions"),
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: db.collection('Transactions').snapshots(),
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
            return Center(child: Text('No Transactions'));
          }
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          var userTransaction = [];
          var donar;
          var reciever;

          snapshot.data!.docs.forEach((doc) {
            var data = doc.data() as Map<String, dynamic>;
            if (data['donor_id'] == widget.currentUser?.uid) {
              userTransaction.add(doc);
            } else if (data['reciever_id'] == widget.currentUser?.uid) {
              userTransaction.add(doc);
            }
          });

          return userTransaction.isEmpty
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemCount: userTransaction.length,
                  itemBuilder: (context, index) {
                    var doc = userTransaction[index];

                    Map<String, dynamic> transactionData =
                        doc.data() as Map<String, dynamic>;
                    DateTime date =
                        transactionData['transaction_date'].toDate();
                    var format = DateFormat('dd-MM-yyyy ');

                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Donor ID:'),
                            Text(transactionData['donor_id']),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Reciver ID:'),
                            Text(transactionData['reciever_id']),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Medicine Name:'),
                            Text(transactionData['medicine_name']),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Quantity:'),
                            Text(transactionData['quantity'].toString()),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Transaction Date:'),
                            Text(format.format(date))
                          ],
                        ),
                        SizedBox(
                          height: 20,
                          child: Divider(
                            thickness: 1,
                            color: Colors.teal.shade900,
                            indent: 5,
                            endIndent: 2,
                          ),
                        ),
                      ],
                    );
                  });
        },
      ),
    );
  }
}
