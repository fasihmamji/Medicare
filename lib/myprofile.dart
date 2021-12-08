import 'package:firebase/firebase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class Myprofile extends StatefulWidget {
  @override
  State<Myprofile> createState() => _MyprofileState();
}

class _MyprofileState extends State<Myprofile> {
  // FirebaseFirestore firestore = FirebaseFirestore.instance;
  final Stream<QuerySnapshot> users = FirebaseFirestore.instance.collection('Users').snapshots();




  // Future<List?> read() async {
  //   QuerySnapshot querySnapshot;
  //   List docs = [];
  //   try{
  //     querySnapshot = await firestore.collection('fname').orderBy('timestamp').get();
  //     if(querySnapshot.docs.isNotEmpty){
  //       for(var doc in querySnapshot.docs.toList()){
  //         Map a = {"fname":doc['fname'],"lname":doc['lname']};
  //         docs.add(a);
  //       }
  //       return docs;
  //     }
  //   }
  //   catch(e){
  //     print(e);
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        title: Text(
          'User Profile',
          style: TextStyle(
            fontSize: 25,
            fontFamily: 'Pacifico',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body:
        StreamBuilder<QuerySnapshot>(stream: users, builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot,
            ){
          if(snapshot.hasError){
            return Text('Something Went Wrong');
          }
          if(snapshot.connectionState == ConnectionState.waiting){
            return Text('Loading');
          }
          final data = snapshot.data?.docs;
          return ListView.builder(
              itemCount: data?.length,
              itemBuilder: (context,index){
                return Text('Name:${data?[index]['fname']}');
              },
          );
        },
        )
    );
  }
}
