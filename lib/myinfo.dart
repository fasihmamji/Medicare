import 'package:flutter/material.dart';

class MyInfo extends StatelessWidget {
  final address;
  final phone;
  final cnic;
  final age;
  final country;
  final city;
  final zip;
  final dob;
  const MyInfo(
      {Key? key,
      this.address,
      this.phone,
      this.cnic,
      this.age,
      this.country,
      this.city,
      this.zip,
      this.dob})
      : super(key: key);

  Card cardTile(title) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title: Text(title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List info = [
      phone,
      age,
      dob,
      address,
      cnic,
      country,
      city,
      zip,
    ];

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: true,
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Your Information',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              height: 600,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: info.length,
                itemBuilder: (context, index) => cardTile(info[index]),
              ),
            )
          ],
        )));
  }
}
