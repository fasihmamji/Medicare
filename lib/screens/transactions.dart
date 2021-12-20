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
                  child: Text('You have not done any transactions'),
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

                    return Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Card(
                        elevation: 0,
                        borderOnForeground: false,
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Container(
                            padding: EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Colors.grey,
                                  offset: const Offset(2.0, 4.0),
                                  blurRadius: 4),
                            ],
                            ),
                            child: Column(
                              
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Text(
                                        'Donor ID:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                    ),
                                    FutureBuilder<DocumentSnapshot>(
                                        future: db
                                            .collection('Users')
                                            .doc(transactionData['donor_id'])
                                            .get(),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData) {
                                            return Align(
                                                alignment: Alignment.centerRight,
                                                child: Text('Loading...'));
                                          }
                                          Map<String, dynamic> donorData =
                                              snapshot.data!.data()
                                                  as Map<String, dynamic>;
                                          return Padding(
                                            padding:
                                                const EdgeInsets.only(right: 5),
                                            child: Text(
                                                '${donorData['fname']} ${donorData['lname']}'),
                                          );
                                        })
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Text('Reciver ID:',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15)),
                                    ),
                                    FutureBuilder<DocumentSnapshot>(
                                        future: db
                                            .collection('Users')
                                            .doc(transactionData['reciever_id'])
                                            .get(),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData) {
                                            return Align(
                                                alignment: Alignment.centerRight,
                                                child: Text('Loading...'));
                                          }
                                          Map<String, dynamic> recieverData =
                                              snapshot.data!.data()
                                                  as Map<String, dynamic>;
                                          return Padding(
                                            padding:
                                                const EdgeInsets.only(right: 5),
                                            child: Text(
                                                '${recieverData['fname']} ${recieverData['lname']}'),
                                          );
                                        })
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left:5),
                                      child: Text('Medicine Name:',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right:5),
                                      child: Text(transactionData['medicine_name']),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left:5),
                                      child: Text('Quantity:',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right:5),
                                      child: Text(transactionData['quantity'].toString()),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left:5),
                                      child: Text('Transaction Date:',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right:5),
                                      child: Text(format.format(date)),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  });
        },
      ),
    );
  }
}
