// ignore_for_file: prefer_const_constructors, unnecessary_new, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medical/auth/auth_methods.dart';
import 'package:medical/screens/homepage.dart';
import 'package:medical/screens/login%20copy.dart';
import 'package:medical/screens/signup.dart';
import 'package:medical/utils/box.dart';
import 'package:medical/utils/utils.dart';

class BasicDetails extends StatefulWidget {
  const BasicDetails({super.key});

  @override
  State<BasicDetails> createState() => _BasicDetails();
}

class _BasicDetails extends State<BasicDetails> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPassword = TextEditingController();
  final _nameController = TextEditingController();
  final _hospitalController = TextEditingController();
  final _specializationController = TextEditingController();
  final _doctorIdController = TextEditingController();
  String selectedRadioButton = 'user';
  TextEditingController allergiesController = TextEditingController();
  TextEditingController surgeriesController = TextEditingController();
  TextEditingController extraDetailsController = TextEditingController();
  Uint8List? _image;
  void selectImage() async {
    Uint8List? im = await pickImage(ImageSource.gallery);

    setState(() {
      _image = im;
    });
  }

  bool isFading = true;
  bool _isLoading = false;

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future signUp() async {
    setState(() {
      _isLoading = true;
    });

    String x = await AuthMethods().signupUser(
        type: selectedRadioButton,
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        name: _nameController.text.trim(),
        file: _image!,
        hospital: _hospitalController.text,
        specialization: _specializationController.text,
        doctorId: _doctorIdController.text,
        allergies: allergiesController.text,
        extra: extraDetailsController.text,
        surgeries: surgeriesController.text);
    print(x);
    Navigator.popUntil(context, (route) => route.isFirst);

    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) => HomePage()));
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFcecff3),
            Color(0xFF7272c4),
          ],
        ),
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Transform.translate(
                      offset: Offset(-10, -20),
                      child: CustomPaint(
                        painter: OvalPainter(),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height - 200,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 100,
                      top: 100,
                      child: CustomPaint(
                        painter: OvalPainter2(),
                        child: Container(
                          width: 100,
                          height: 150,
                        ),
                      ),
                    ),
                    Positioned(
                      right: -40,
                      top: -50,
                      child: CustomPaint(
                        painter: OvalPainter2(),
                        child: Container(
                          width: 300,
                          height: 450,
                        ),
                      ),
                    ),
                    Positioned(
                      right: -40,
                      top: 200,
                      child: CustomPaint(
                        painter: OvalPainter2(),
                        child: Container(
                          width: 300,
                          height: 450,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                        color: Color(0xFFfaf8f4),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18.0, vertical: 5),
                          child: AnimatedCrossFade(
                            duration: Duration(seconds: 1),
                            firstChild: Container(
                              padding: EdgeInsets.only(
                                  top: 35.0, left: 20.0, right: 20.0),
                              child: Column(
                                // ignore: prefer_const_literals_to_create_immutables
                                children: [
                                  Stack(
                                    children: [
                                      _image != null
                                          ? CircleAvatar(
                                              radius: 64,
                                              backgroundImage:
                                                  MemoryImage(_image!),
                                            )
                                          : const CircleAvatar(
                                              radius: 64,
                                              backgroundColor: Colors.purple,
                                            ),
                                      Positioned(
                                        bottom: -5,
                                        right: -5,
                                        child: IconButton(
                                          onPressed: selectImage,
                                          icon: const Icon(Icons.add_a_photo),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  TextField(
                                    controller: _nameController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'name',
                                      labelStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  TextField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'email',
                                      labelStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  TextField(
                                    obscureText: true,
                                    controller: _passwordController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      labelText: 'password',
                                      labelStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  TextField(
                                    obscureText: true,
                                    controller: _confirmPassword,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      labelText: 'confirm password',
                                      labelStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                      height: 60,
                                      width: 320,
                                      child:
                                          // DropdownSearch<String>(
                                          //   popupProps: PopupProps.menu(
                                          //     showSearchBox: true,
                                          //     showSelectedItems: true,
                                          //   ),
                                          //   items: types,
                                          //   dropdownDecoratorProps: DropDownDecoratorProps(
                                          //     dropdownSearchDecoration: InputDecoration(
                                          //       border: OutlineInputBorder(
                                          //           borderRadius:
                                          //               BorderRadius.circular(10.0)),
                                          //       labelText: 'choose role',
                                          //       labelStyle: TextStyle(
                                          //           fontWeight: FontWeight.bold,
                                          //           color: Colors.black),
                                          //     ),
                                          //   ),
                                          //   onChanged: (val) {
                                          //     setState(() {
                                          //       selectedRadioButton = val!;
                                          //     });
                                          //   },
                                          // ),
                                          InputDecorator(
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10.0)),
                                        )),
                                        child: DropdownButton(
                                          value: 'user',
                                          icon: const Icon(
                                              Icons.keyboard_arrow_down),
                                          items: [
                                            DropdownMenuItem(
                                              child: Text("User"),
                                              value: "user",
                                            ),
                                            DropdownMenuItem(
                                              child: Text("Doctor"),
                                              value: "doctor",
                                            ),
                                            DropdownMenuItem(
                                              child: Text("Insurance"),
                                              value: "insurance",
                                            )
                                          ],
                                          onChanged: (val) {
                                            setState(() {
                                              selectedRadioButton = val!;
                                            });
                                          },
                                        ),
                                      )),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  selectedRadioButton == "doctor"
                                      ? TextField(
                                          controller: _specializationController,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'Specialization',
                                            labelStyle: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                        )
                                      : Container(),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  selectedRadioButton == "doctor"
                                      ? TextField(
                                          controller: _hospitalController,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'Hospital',
                                            labelStyle: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        )
                                      : Container(),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  selectedRadioButton == "doctor"
                                      ? TextField(
                                          controller: _doctorIdController,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'Doctor Id',
                                            labelStyle: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        )
                                      : Container(),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                            secondChild: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Allergies',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8.0),
                                  TextField(
                                    controller: allergiesController,
                                    decoration: InputDecoration(
                                      hintText: 'Enter any allergies...',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  SizedBox(height: 16.0),
                                  Text(
                                    'Surgeries',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8.0),
                                  TextField(
                                    controller: surgeriesController,
                                    decoration: InputDecoration(
                                      hintText: 'Enter any surgeries...',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  SizedBox(height: 16.0),
                                  Text(
                                    'Extra Details',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8.0),
                                  TextField(
                                    controller: extraDetailsController,
                                    maxLines: 3,
                                    decoration: InputDecoration(
                                      hintText: 'Enter any extra details...',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  SizedBox(height: 24.0),
                                  ElevatedButton(
                                    onPressed: () {
                                      String allergies =
                                          allergiesController.text;
                                      String surgeries =
                                          surgeriesController.text;
                                      String extraDetails =
                                          extraDetailsController.text;

                                      // Perform actions with the entered data, such as saving it to a database

                                      // Optional: Reset the text fields after submitting
                                      allergiesController.clear();
                                      surgeriesController.clear();
                                      extraDetailsController.clear();

                                      // Optional: Show a confirmation dialog or navigate to a different page
                                    },
                                    child: Text('Submit'),
                                  ),
                                ],
                              ),
                            ),
                            crossFadeState: isFading
                                ? CrossFadeState.showFirst
                                : CrossFadeState.showSecond,
                          )),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      isFading = !isFading;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.white,
                    ),
                    child: isFading
                        ? FaIcon(
                            FontAwesomeIcons.anglesRight,
                            color: Color(0xFFd7d5fc),
                            size: 30,
                          )
                        : _isLoading
                            ? Center(
                                child: CircleAvatar(
                                  radius: 10,
                                  backgroundColor: Colors.white,
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : _isLoading
                                ? CircularProgressIndicator()
                                : GestureDetector(
                                    onTap: () async {
                                      await signUp();
                                    },
                                    child: FaIcon(
                                      FontAwesomeIcons.check,
                                      color: Color(0xFFd7d5fc),
                                      size: 30,
                                    ),
                                  ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OvalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawOval(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class OvalPainter2 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawOval(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
