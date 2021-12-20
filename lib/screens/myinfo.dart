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

  Widget cardTile(key, value) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text(key), Text(value)],
            ),
          )),
    );
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
        appBar: AppBar(
          elevation: 0,
          title: Text(
            'Your Information',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: true,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top:12,bottom: 10),
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
        ));
  }
}
