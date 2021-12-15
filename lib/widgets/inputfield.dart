import 'package:flutter/material.dart';

class Inputfield extends StatefulWidget {
  //const ({ Key? key }) : super(key: key);

  @override
  State<Inputfield> createState() => _InputfieldState();
}

class _InputfieldState extends State<Inputfield> {
  bool _isHidden = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
              fillColor: Colors.grey.shade200,
              filled: true,
              labelText: 'E-Mail',
              border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              prefixIcon: const Icon(Icons.email),
              hintText: 'abcdxye@gmail.com'),
        ),
        const SizedBox(
          height: 10,
        ),
        TextField(
          obscureText: _isHidden,
          keyboardType: TextInputType.visiblePassword,
          decoration: InputDecoration(
              fillColor: Colors.grey.shade200,
              filled: true,
              labelText: 'Password',
              border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: InkWell(
                onTap: () => setState(() {
                  _isHidden = !_isHidden;
                }),
                child:
                Icon(_isHidden ? Icons.visibility : Icons.visibility_off),
              ),
              hintText: 'Password'),
        ),
      ],
    );
  }
}