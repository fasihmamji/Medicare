import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testing_app/screens/login.dart';

class MySignUp extends StatefulWidget {
  const MySignUp({Key? key}) : super(key: key);

  @override
  _MySignUpState createState() => _MySignUpState();
}

class _MySignUpState extends State<MySignUp> {
  FirebaseAuth auth = FirebaseAuth.instance;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
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

  Future registerUser(email, password) async {
    try {
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        db.collection('Users').doc(value.user?.uid).set({
          'email': email,
          'fname': fnameController.text,
          'lname': lnameController.text,
          'address': addressController.text,
          'phoneno': phonenoController.text,
          'age': ageController.text,
          'dob': dobController.text,
          'cnic': cnicController.text,
          'country': countryController.text,
          'city': cityController.text,
          'zip': zipController.text,
        }).then((value) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Login();
          }));
        });
      });
    } on FirebaseAuthException catch (err) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${err.message}')));
    }
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
            child: Form(
              key: formKey,
              child: ListView(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      fillColor: Colors.grey.shade200,
                      filled: true,
                      labelText: 'First Name',
                      errorStyle: TextStyle(color: Colors.red),
                      hintText: 'First Name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      prefixIcon: const Icon(Icons.person),
                    ),
                    controller: fnameController,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "First Name can't be empty";
                      }
                    },
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextFormField(
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
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Last Name can't be empty";
                      }
                    },
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextFormField(
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
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Email can't be empty";
                      }
                      if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                          .hasMatch(val)) {
                        return 'Invalid Email';
                      }
                    },
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextFormField(
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
                        child: Icon(_isHidden
                            ? Icons.visibility
                            : Icons.visibility_off),
                      ),
                    ),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Password can't be empty";
                      }
                    },
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextFormField(
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
                        child: Icon(_isHidden1
                            ? Icons.visibility
                            : Icons.visibility_off),
                      ),
                    ),
                    controller: cpasswordController,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Please re-enter password";
                      }
                      if (passwordController.text != cpasswordController.text) {
                        return "Password does not match";
                      }
                    },
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      fillColor: Colors.grey.shade200,
                      filled: true,
                      labelText: 'Address',
                      hintText: 'Address',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      prefixIcon: const Icon(Icons.home),
                    ),
                    controller: addressController,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Address can't be empty";
                      }
                    },
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextFormField(
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
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Phone Number can't be empty";
                      }
                      if (val.length != 11) return "Enter a valid phone number";
                    },
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextFormField(
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
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Age can't be empty";
                      }
                      if (int.parse(val) < 0) {
                        return "Enter a valid age";
                      }
                    },
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextFormField(
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

                      validator:
                      (val) {
                        if (val!.isEmpty) {
                          return "Date of Birth can't be empty";
                        }
                      };
                    },
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextFormField(
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
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "CNIC can't be empty";
                      }
                      if (val.length != 13) {
                        return "CNIC must be 13 digits";
                      }
                    },
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextFormField(
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
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Country can't be empty";
                      }
                    },
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextFormField(
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
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "City can't be empty";
                      }
                    },
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  TextFormField(
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
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Zip Code can't be empty";
                      }
                    },
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
                        if (formKey.currentState!.validate()) {
                          registerUser(
                              emailController.text, passwordController.text);
                        } else {
                          print("Unsuccessfull");
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
