import 'package:flutter/material.dart';

class Recieved extends StatefulWidget {
  const Recieved({Key? key}) : super(key: key);

  @override
  State<Recieved> createState() => _RecievedState();
}

class _RecievedState extends State<Recieved> {
  String? valueChoose;

  List listItem = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5"];

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
        body: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Container(
            // padding: const EdgeInsets.only(left: 16, right: 16),
            decoration: BoxDecoration(
              color: Colors.teal.shade900,
              border: Border.all(
                color: Colors.teal.shade900,
                width: 3,
              ),
              borderRadius: BorderRadius.zero,
            ),
            child: DropdownButton(
              hint: const Text('Select Item',
                  style: TextStyle(color: Colors.white)),
              dropdownColor: Colors.teal.shade900,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              iconSize: 30,
              isExpanded: true,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
              value: valueChoose,
              onChanged: (newValue) {
                setState(() {
                  valueChoose = newValue as String;
                });
              },
              items: listItem.map((valueItem) {
                return DropdownMenuItem(
                  value: valueItem,
                  child: Text(valueItem),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
