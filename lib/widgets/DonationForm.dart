import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DonationForm extends StatefulWidget {
  const DonationForm({Key? key}) : super(key: key);

  @override
  State<DonationForm> createState() => _DonationFormState();
}

class _DonationFormState extends State<DonationForm> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  String? selectedName;
  Object? selectedDosage;
  TextEditingController manufacturerController = TextEditingController();
  TextEditingController expiryController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  User? currentUser;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() {
    var user = auth.currentUser;
    setState(() {
      currentUser = user;
    });
  }

  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: true,
              iconTheme: IconThemeData(color: Colors.black),
              centerTitle: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              title: Text(
                'Enter Medicine Details',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: ListView(
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: db.collection('Medicine').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) return CircularProgressIndicator();
                    if (snapshot.data == null)
                      return CircularProgressIndicator();
                    List names = [];
                    for (int index = 0;
                        index < snapshot.data!.docs.length;
                        index++) {
                      DocumentSnapshot doc = snapshot.data!.docs[index];

                      names.add(doc['name']);
                    }

                    return names.isEmpty
                        ? Center(
                            child: Text('No data available'),
                          )
                        : Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Medicine Name',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    Expanded(
                                      child: DropdownButton(
                                          value: selectedName,
                                          onChanged: (val) {
                                            setState(() {
                                              selectedName = val as String;
                                              selectedDosage = null;
                                              isSelected = true;
                                            });
                                          },
                                          items: names.map((name) {
                                            return DropdownMenuItem(
                                              value: name,
                                              child: Text(name),
                                            );
                                          }).toList()),
                                    )
                                  ],
                                ),
                              ),
                              isSelected
                                  ? StreamBuilder<DocumentSnapshot>(
                                      stream: db
                                          .collection('Medicine')
                                          .doc(selectedName)
                                          .snapshots(),
                                      builder: (_, snapshot) {
                                        if (snapshot.hasError) {
                                          return Text("Something went wrong");
                                        }
                                        if (snapshot.hasData &&
                                            !snapshot.data!.exists) {
                                          return Text(
                                              "Document does not exist");
                                        }
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }

                                        Map<String, dynamic> data =
                                            snapshot.data!.data()
                                                as Map<String, dynamic>;
                                        var dosages = [];
                                        var desc = [];
                                        data['dosage'].forEach((element) {
                                          dosages.add(element);
                                        });
                                        data['genre'].forEach((element) {
                                          desc.add(element);
                                        });

                                        return Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Row(
                                                children: [
                                                  Text('Medicine Form'),
                                                  SizedBox(
                                                    width: 30,
                                                  ),
                                                  Text('${data['form']}'),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Row(children: [
                                                Expanded(
                                                    child: Text(
                                                        'Medicine Dosage')),
                                                Expanded(
                                                  child: DropdownButton(
                                                      value: selectedDosage,
                                                      onChanged: (val) {
                                                        setState(() {
                                                          selectedDosage = val;
                                                        });
                                                      },
                                                      items:
                                                          dosages.map((dosage) {
                                                        return DropdownMenuItem(
                                                          value: dosage,
                                                          child: Text(dosage),
                                                        );
                                                      }).toList()),
                                                ),
                                              ]),
                                            ),
                                            TextField(
                                              decoration: InputDecoration(
                                                fillColor: Colors.grey.shade200,
                                                filled: true,
                                                labelText: 'Quantity',
                                                hintText: 'Quantity',
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                prefixIcon: const Icon(
                                                    Icons.note_add),
                                              ),
                                              controller: quantityController,
                                            ),
                                            TextField(
                                              readOnly: true,
                                              decoration: InputDecoration(
                                                fillColor: Colors.grey.shade200,
                                                filled: true,
                                                labelText: 'Manufacture Date',
                                                hintText: 'Manufacture Date',
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                prefixIcon: const Icon(
                                                    Icons.calendar_today),
                                              ),
                                              controller:
                                                  manufacturerController,
                                              onTap: () async {
                                                var date = await showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime(2019),
                                                  lastDate: DateTime(2030),
                                                );
                                                manufacturerController.text =
                                                    date
                                                        .toString()
                                                        .substring(0, 10);
                                              },
                                            ),
                                            TextField(
                                              readOnly: true,
                                              decoration: InputDecoration(
                                                fillColor: Colors.grey.shade200,
                                                filled: true,
                                                labelText: 'Expiry Date',
                                                hintText: 'Expiry Date',
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                prefixIcon: const Icon(
                                                    Icons.calendar_today),
                                              ),
                                              controller: expiryController,
                                              onTap: () async {
                                                var date = await showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime(2019),
                                                  lastDate: DateTime(2030),
                                                );
                                                expiryController.text = date
                                                    .toString()
                                                    .substring(0, 10);
                                              },
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Column(
                                                children: [
                                                  Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        'Medicine Used for:',
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      )),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Column(
                                                      children: List.from(
                                                          desc.map((e) => Row(
                                                                children: [
                                                                  Text(
                                                                    '\u2022',
                                                                  ),
                                                                  Text('$e'),
                                                                ],
                                                              )))),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: GestureDetector(
                                                    child: Container(
                                                        height: 30,
                                                        child: Center(
                                                          child: Text(
                                                            'CANCEL',
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                letterSpacing:
                                                                    2.2,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 50),
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20))),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      db
                                                          .collection(
                                                              'Donations')
                                                          .add({
                                                        'medicine_name':
                                                            selectedName,
                                                        "medicine_dosage":
                                                            selectedDosage,
                                                        "quantity":
                                                            quantityController
                                                                .text,
                                                        "manufacturing_date":
                                                            manufacturerController
                                                                .text,
                                                        "expiry_date":
                                                            expiryController
                                                                .text,
                                                        "created_by":
                                                            currentUser?.uid
                                                      });
                                                    },
                                                    child: Container(
                                                        height: 30,
                                                        child: Center(
                                                          child: Text(
                                                            'DONATE',
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                letterSpacing:
                                                                    2.2,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 50),
                                                        decoration: BoxDecoration(
                                                            color: Colors
                                                                .blue.shade900,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20))),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        );
                                      },
                                    )
                                  : Text('Select a medicine')
                            ],
                          );
                  },
                ),
              ],
            )));
  }
}
