import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testing_app/login.dart';

class MySignUp extends StatefulWidget {
  const MySignUp({Key? key}) : super(key: key);

  @override
  _MySignUpState createState() => _MySignUpState();
}

class _MySignUpState extends State<MySignUp> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  final dateController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final fnameController = TextEditingController();
  final lnameController = TextEditingController();
  final cpasswordController = TextEditingController();
  final addressController = TextEditingController();
  final phonenoController = TextEditingController();
  final ageController = TextEditingController();
  final dobController = TextEditingController();
  final cnicController = TextEditingController();
  final countryController = TextEditingController();
  final cityController = TextEditingController();
  final zipController = TextEditingController();
  bool _isHidden = true;
  bool _isHidden1 = true;
  @override
   void dispose() {
    // Clean up the controller when the widget is removed
    dateController.dispose();
    super.dispose();
  }
  Future registerUser(email,password) async {
    await auth.createUserWithEmailAndPassword(email: email, password: password)
        .then((value) { db.collection('Users').doc(value.user?.uid).set({
      'email':email,
      'fname':fnameController.text,
      'lname':lnameController.text,
      'address':addressController.text,
      'phoneno':phonenoController.text,
      'age':ageController.text,
      'dob':dobController.text,
      'cnic':cnicController.text,
      'country':countryController.text,
      'city':cityController.text,
      'zip':zipController.text,
    }).then((value) {
      Navigator.push(context, MaterialPageRoute(builder: (context){
        return Login();
      }));
    });

    });

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          Positioned(
            top: -100,
            child: Image.asset(
              'assets/login.png',
              fit: BoxFit.cover,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 70, left: 50),
            child: Text(
              'Medicare \nSign Up',
              style: TextStyle(
                  fontFamily: 'Lobster',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 40),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.4,
              right: 35,
              left: 35,
            ),
            child: ListView(
              children: [
                TextField(
                  decoration: InputDecoration(
                    fillColor: Colors.grey.shade200,
                    filled: true,
                    labelText: 'First Name',
                    hintText: 'First Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Icon(Icons.person),
                  ),
                  controller: fnameController,
                ),
                const SizedBox(
                  height: 25,
                ),
                TextField(
                  decoration: InputDecoration(
                    fillColor: Colors.grey.shade200,
                    filled: true,
                    labelText: 'Last Name',
                    hintText: 'Last Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Icon(Icons.person),
                  ),
                  controller: lnameController,
                ),
                const SizedBox(
                  height: 25,
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    fillColor: Colors.grey.shade200,
                    filled: true,
                    labelText: 'Email',
                    hintText: 'Email',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Icon(Icons.email),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                TextField(
                  controller: passwordController,
                  obscureText: _isHidden,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    fillColor: Colors.grey.shade200,
                    filled: true,
                    labelText: 'Password',
                    hintText: 'Password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Icon(Icons.password),
                    suffixIcon: InkWell(
                      onTap: () => setState(() {
                        _isHidden = !_isHidden;
                      }),
                      child: Icon(
                          _isHidden ? Icons.visibility : Icons.visibility_off),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                TextField(
                  obscureText: _isHidden1,
                  decoration: InputDecoration(
                    fillColor: Colors.grey.shade200,
                    filled: true,
                    labelText: 'Confirm Password',
                    hintText: 'Confirm Password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Icon(Icons.password),
                    suffixIcon: InkWell(
                      onTap: () => setState(() {
                        _isHidden1 = !_isHidden1;
                      }),
                      child: Icon(
                          _isHidden1 ? Icons.visibility : Icons.visibility_off),
                    ),
                  ),
                  controller: cpasswordController,
                ),
                const SizedBox(
                  height: 25,
                ),
                TextField(
                  decoration: InputDecoration(
                    fillColor: Colors.grey.shade200,
                    filled: true,
                    labelText: 'Address',
                    hintText: 'Address',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Icon(Icons.home),
                  ),
                  controller:addressController,
                ),
                const SizedBox(
                  height: 25,
                ),
                TextField(
                  decoration: InputDecoration(
                    fillColor: Colors.grey.shade200,
                    filled: true,
                    labelText: 'Phone#',
                    hintText: 'Phone#',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Icon(Icons.phone),
                  ),
                  controller: phonenoController,
                ),
                const SizedBox(
                  height: 25,
                ),
                TextField(
                  decoration: InputDecoration(
                    fillColor: Colors.grey.shade200,
                    filled: true,
                    labelText: 'Age',
                    hintText: 'Age',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Icon(Icons.person),
                  ),
                  controller: ageController,
                ),
                const SizedBox(
                  height: 25,
                ),
                TextField(
                  readOnly: true,
                  decoration: InputDecoration(
                    fillColor: Colors.grey.shade200,
                    filled: true,
                    labelText: 'DOB',
                    hintText: 'Date Of Birth',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Icon(Icons.calendar_today),
                  ),
                  controller: dobController,
                  onTap: () async {
                    var date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1990),
                      lastDate: DateTime(2022),
                    );
                    dobController.text = date.toString().substring(0, 10);
                  },
                ),
                const SizedBox(
                  height: 25,
                ),
                TextField(
                  decoration: InputDecoration(
                    fillColor: Colors.grey.shade200,
                    filled: true,
                    labelText: 'CNIC',
                    hintText: 'CNIC',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Icon(Icons.badge),
                  ),
                  controller: cnicController,
                ),
                const SizedBox(
                  height: 25,
                ),
                TextField(
                  decoration: InputDecoration(
                    fillColor: Colors.grey.shade200,
                    filled: true,
                    labelText: 'Country',
                    hintText: 'Country',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Icon(Icons.flag),
                  ),
                  controller: countryController,
                ),
                const SizedBox(
                  height: 25,
                ),
                TextField(
                  decoration: InputDecoration(
                    fillColor: Colors.grey.shade200,
                    filled: true,
                    labelText: 'City',
                    hintText: 'City',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon: const Icon(Icons.flag),
                  ),
                  controller: cityController,
                ),
                SizedBox(
                  height: 25,
                ),
                TextField(
                  decoration: InputDecoration(
                    fillColor: Colors.grey.shade200,
                    filled: true,
                    labelText: 'Zip Code',
                    hintText: 'Zip Code',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    prefixIcon: Icon(Icons.add_location),
                  ),
                  controller: zipController,
                ),
                const SizedBox(
                  height: 35,
                ),
                SizedBox(
                  height: 50,
                  width: 250,
                  child: ElevatedButton(
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 22),
                    ),
                    onPressed: () {
                      registerUser(emailController.text, passwordController.text);
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}