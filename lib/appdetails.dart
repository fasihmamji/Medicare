import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Appdetails extends StatefulWidget {
  @override
  _AppdetailsState createState() => _AppdetailsState();
}

class _AppdetailsState extends State<Appdetails> {
  List images = [
    "appdetail.jpg",
    "appdetail2.png",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
          scrollDirection: Axis.vertical,
          itemCount: images.length,
          itemBuilder: (_, index) {
            return Container(
              width: double.maxFinite,
              height: double.maxFinite,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/" + images[index]),
                  fit: BoxFit.fill,
                ),
              ),
              child: Container(
                margin: const EdgeInsets.only(top: 150, left: 20, right: 20),
                child: Row(
                  children: [
                    Column(
                      children: [],
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
