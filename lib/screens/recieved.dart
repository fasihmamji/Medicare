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
        body: Container(
          padding: const EdgeInsets.only(left: 16, right: 16),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.blueGrey,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: DropdownButton(
            hint: const Text('Select Item'),
            dropdownColor: Colors.blueGrey,
            icon: const Icon(Icons.arrow_drop_down),
            iconSize: 30,
            isExpanded: true,
            style: const TextStyle(
              color: Colors.black,
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
    );
  }
}
