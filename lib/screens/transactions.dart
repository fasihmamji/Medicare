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

  var donar;
  var reciever;

  @override
  void initState() {
    super.initState();
  }

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
            return Center(child: Text('No donated medicines'));
          }
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          var userTransaction = [];

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
                        Text(transactionData['donor_id']),
                        Text(transactionData['medicine_name']),
                        Text(transactionData['reciever_id']),
                        Text(transactionData['quantity'].toString()),
                        Text(format.format(date))
                      ],
                    );
                  });
        },
      ),
    );
  }
}
