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

  Card cardTile(key, value) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(key), Text(value)],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> info = {
      'Phone Number:': phone,
      'Age:': age,
      'Date of Birth:': dob,
      'Address:': address,
      'CNIC:': cnic,
      'Country:': country,
      'City:': city,
      'Zip Code:': zip,
    };

    return Scaffold(
        backgroundColor: Colors.teal.shade900,
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
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            Container(
              height: 600,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: info.length,
                  itemBuilder: (context, index) {
                    var keys = [];
                    var values = [];
                    info.forEach((key, value) {
                      keys.add(key);
                      values.add(value);
                    });
                    return cardTile(keys[index], values[index]);
                  }),
            ),
          ],
        )));
  }
}
