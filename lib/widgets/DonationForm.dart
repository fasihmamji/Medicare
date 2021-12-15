// ignore: file_names
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum MedicineForm { Tablet, Syrup }

class DonationForm extends StatefulWidget {
  const DonationForm({Key? key}) : super(key: key);

  @override
  State<DonationForm> createState() => _DonationFormState();
}

class _DonationFormState extends State<DonationForm> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  MedicineForm? form = MedicineForm.Tablet;
  bool filtered = false;
  var selectedGenres = [];
  var selectedForm = 1;
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> fetchMedicines = filtered
        ? db
            .collection('Medicine')
            .where('genre', arrayContains: selectedGenres)
            .where('form', isEqualTo: selectedForm)
            .snapshots()
        : db.collection('Medicine').snapshots();
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: true,
              centerTitle: true,
              elevation: 0,
              actions: [
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                                title: Text('Filter'),
                                content: Container(
                                  child: Column(
                                    children: [
                                      ListTile(
                                        title: const Text('Tablet'),
                                        leading: Radio<MedicineForm>(
                                          value: MedicineForm.Tablet,
                                          groupValue: form,
                                          onChanged: (MedicineForm? value) {
                                            setState(() {
                                              form = value;
                                            });
                                          },
                                        ),
                                      ),
                                      ListTile(
                                        title: const Text('Syrup'),
                                        leading: Radio<MedicineForm>(
                                          value: MedicineForm.Syrup,
                                          groupValue: form,
                                          onChanged: (MedicineForm? value) {
                                            setState(() {
                                              form = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ));
                          });
                    },
                    icon: Icon(
                      Icons.filter_list,
                      color: Colors.black,
                    ))
              ],
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
                  stream: fetchMedicines,
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
                    print(names);
                    return Text('hh');
                  },
                )
              ],
            )));
  }
}
