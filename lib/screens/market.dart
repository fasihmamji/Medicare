import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Market extends StatefulWidget {
  final User? currentUser;

  const Market({Key? key, this.currentUser}) : super(key: key);
  @override
  State<Market> createState() => _MarketState();
}

class _MarketState extends State<Market> {
  bool isSearching = false;
  FirebaseFirestore db = FirebaseFirestore.instance;

  FirebaseAuth auth = FirebaseAuth.instance;
  String query = '';
  TextEditingController queryController = TextEditingController();
  bool isRequested = false;

  TextEditingController quantityController = TextEditingController();
  String quantity = '';

  bool isValid = false;
  String? error = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.teal.shade900,
          title: !isSearching
              ? Text('All Medicines')
              : TextField(
                  controller: queryController,
                  onChanged: (val) {
                    setState(() {
                      query = val;
                    });
                  },
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    hintText: "Search Medicine Here",
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                ),
          actions: [
            isSearching
                ? IconButton(
                    icon: Icon(Icons.cancel),
                    onPressed: () {
                      setState(() {
                        this.isSearching = false;
                        queryController.clear();
                        query = '';
                      });
                    },
                  )
                : IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        this.isSearching = true;
                      });
                    },
                  ),
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: query == ''
              ? db.collection('Market').snapshots()
              : db
                  .collection('Market')
                  .where('medicine_name', isEqualTo: query)
                  .snapshots(),
          builder: (context, medicineSnapshot) {
            if (medicineSnapshot.hasError)
              return Center(
                child: Text('Error loading medicines'),
              );
            if (medicineSnapshot.data == null)
              return Center(
                child: Text('No Donated Medicines'),
              );
            if (medicineSnapshot.data!.docs.isEmpty) {
              return Center(child: Text('No Donated Medicines'));
            }
            if (medicineSnapshot.connectionState == ConnectionState.waiting)
              return Center(child: Text('No Donated Medicines'));
            return ListView.builder(
                itemCount: medicineSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot doc = medicineSnapshot.data!.docs[index];

                  Map<String, dynamic> medicineData =
                      doc.data() as Map<String, dynamic>;

                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      child: ExpansionTile(
                        title: Text(medicineData['medicine_name']),
                        subtitle: Text(
                            'Quantity: ${medicineData['quantity'].toString()}'),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                    'Manufactured: ${medicineData['manufacturing_date']}')),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                    'Expiry: ${medicineData['expiry_date']}')),
                          ),
                          FutureBuilder<DocumentSnapshot>(
                            future: db
                                .collection('Users')
                                .doc(medicineData['created_by'])
                                .get(),
                            builder: (context, userSnapshot) {
                              if (!userSnapshot.hasData) {
                                return Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text('Loading...'));
                              } else {
                                var userData = userSnapshot.data!.data()
                                    as Map<String, dynamic>;
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                              'Donated by: ${userData['fname']} ${userData['lname']} ')),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: GestureDetector(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: medicineData[
                                                                'requested_by'] ==
                                                            null
                                                        ? Text('Contact')
                                                        : Text('Sorry'),
                                                    content: medicineData[
                                                                'requested_by'] ==
                                                            null
                                                        ? Text(
                                                            '${userData['phoneno']}')
                                                        : Text(
                                                            'Already requested by someone else'),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text('OK'))
                                                    ],
                                                  );
                                                }).then((value) {
                                              medicineData['requested_by'] ==
                                                      null
                                                  ? db
                                                      .collection('Users')
                                                      .doc(widget
                                                          .currentUser?.uid)
                                                      .collection('Requests')
                                                      .doc(doc.id)
                                                      .set({
                                                      "donator_id":
                                                          medicineData[
                                                              'created_by'],
                                                      "donator_name":
                                                          '${userData['fname']} ${userData['lname']}',
                                                      "quantity": medicineData[
                                                          'quantity'],
                                                      "medicine_name":
                                                          medicineData[
                                                              'medicine_name'],

                                                      // "requested_by":
                                                      //     currentUser?.uid,
                                                      "requested_on":
                                                          DateTime.now()
                                                    }).then((value) {
                                                      db
                                                          .collection('Users')
                                                          .doc(medicineData[
                                                              'created_by'])
                                                          .collection(
                                                              'Donations')
                                                          .doc(doc.id)
                                                          .update({
                                                        "requested_by": widget
                                                            .currentUser?.uid
                                                      }).then((value) {
                                                        db
                                                            .collection(
                                                                'Market')
                                                            .doc(doc.id)
                                                            .update({
                                                          "requested_by": widget
                                                              .currentUser?.uid
                                                        });
                                                      });
                                                    })
                                                  : null;
                                            });
                                          },
                                          child: medicineData['created_by'] ==
                                                  widget.currentUser?.uid
                                              ? Container()
                                              : Container(
                                                  padding: EdgeInsets.all(5),
                                                  child: Text(
                                                    'Request',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.teal.shade900,
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ),
                                  ],
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
