// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medical/screens/userlist.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class InsuranceDetails extends StatefulWidget {
  InsuranceDetails({super.key, required this.dSnap, required this.insurance});
  Map<String, dynamic> dSnap;
  final bool insurance;

  @override
  State<InsuranceDetails> createState() => _InsuranceDetailsState();
}

class _InsuranceDetailsState extends State<InsuranceDetails> {
  List<dynamic> participantIDs = [];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  getParticipantIDs() async {
    print('us');
    final documentSnapshot = await _firestore
        .collection('insurances')
        .doc(widget.dSnap['insuranceID'])
        .get();
    for (var x in documentSnapshot.data()!['interested']) {
      if (x != null) {
        participantIDs.add(x);
        // print(x['id']);
      }
    }
    print("participantIDs");
    print(participantIDs);
    // participantIDs = widget.dsnap['certificate']['id'];
  }
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // final user = FirebaseAuth.instance.currentUser!;

  // Future applyToTeach() async {
  //   try {
  //     await _firestore.collection('users').doc(user.uid).update({
  //       'applied': FieldValue.arrayUnion(
  //         [widget.dSnap['requestID']],
  //       ),
  //     });
  //   } catch (e) {
  //     print(e.toString());
  //   }

  //   try {
  //     await _firestore
  //         .collection('requests')
  //         .doc(widget.dSnap['requestID'])
  //         .update({
  //       'applicants': FieldValue.arrayUnion(
  //         [user.uid],
  //       ),
  //     });
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    participantIDs = [];

    return FutureBuilder(
        future: getParticipantIDs(),
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 200,
                            width: 200,
                            child: Image(
                              fit: BoxFit.cover,
                              image: AssetImage('assets/doctor.png'),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Cashless Treatment'),
                                  Text('No Paperwork'),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Chip(
                            avatar: Icon(CupertinoIcons.heart),
                            backgroundColor: Colors.orangeAccent,
                            label: Text(
                              'Health Insurance',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(widget.dSnap['desc']),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text('Sum assured'),
                              Text(widget.dSnap['amount'].toString()),
                            ],
                          ),
                          Container(
                            height: 30,
                            width: 1,
                            color: Colors.black,
                          ),
                          Column(
                            children: [
                              Text('Insurance Date'),
                              Text('20-03-2025'),
                            ],
                          ),
                          VerticalDivider(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: widget.insurance
                ? GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserListForAnalysis(
                                  // dsnap: dsnap,
                                  insuranceID: widget.dSnap['insuranceID'],
                                ))),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 12),
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 10),
                        child: ClipPath(
                          clipper: CustomClipPath(
                            cornerRadius: 20,
                            bottomBulgeHeight: 20,
                            bottomBulgeWidth: 60,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFd1cec8),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.solidFaceSmile,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      FaIcon(
                                        FontAwesomeIcons.solidFaceSmile,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      FaIcon(
                                        FontAwesomeIcons.solidFaceSmile,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                      '${participantIDs.length} people interested'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(
                    margin: EdgeInsets.symmetric(horizontal: 12),
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, bottom: 10),
                      child: SlideAction(
                        borderRadius: 12,
                        elevation: 0,
                        innerColor: Colors.white,
                        text: "Slide to Register",
                        textStyle: GoogleFonts.poppins(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                        sliderButtonIcon: Icon(Icons.local_hospital),
                        onSubmit: () {
                          //fest event lite registration

                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Confirmation'),
                                content: Text(
                                    'This will share your details with insurance company for contacting you'),
                                actions: <Widget>[
                                  ElevatedButton(
                                    child: Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  ElevatedButton(
                                    child: Text('Continue'),
                                    onPressed: () async {
                                      FirebaseFirestore.instance
                                          .collection('insurances')
                                          .doc(widget.dSnap['insuranceID'])
                                          .update({
                                        'interested': FieldValue.arrayUnion([
                                          FirebaseAuth.instance.currentUser!.uid
                                        ])
                                      });
                                      final snackBar = SnackBar(
                                        elevation: 0,
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Colors.transparent,
                                        content: AwesomeSnackbarContent(
                                          title: 'Yay!',
                                          message:
                                              'Insurance company will contact you soon',
                                          contentType: ContentType.success,
                                        ),
                                      );

                                      ScaffoldMessenger.of(context)
                                        ..hideCurrentSnackBar()
                                        ..showSnackBar(snackBar);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
          );
        });
  }
}

class CustomClipPath extends CustomClipper<Path> {
  final double cornerRadius;
  final double bottomBulgeHeight;
  final double bottomBulgeWidth;

  CustomClipPath({
    required this.cornerRadius,
    required this.bottomBulgeHeight,
    required this.bottomBulgeWidth,
  });
  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(cornerRadius, 0);
    path.lineTo(size.width - cornerRadius, 0);
    path.quadraticBezierTo(
        size.width, 0, size.width, cornerRadius); // top-right curve
    path.lineTo(size.width, size.height - cornerRadius);
    path.quadraticBezierTo(size.width, size.height, size.width - cornerRadius,
        size.height); // bottom-right curve
    path.lineTo(
        cornerRadius + (size.width - 2 * cornerRadius - bottomBulgeWidth) / 2,
        size.height);
    path.lineTo(
        size.width / 2, size.height + bottomBulgeHeight + 10); // bottom bulge
    path.lineTo(
        cornerRadius + (size.width + 2 * cornerRadius + bottomBulgeWidth) / 2,
        size.height);
    path.lineTo(cornerRadius, size.height);
    path.quadraticBezierTo(
        0, size.height, 0, size.height - cornerRadius); // bottom-left curve
    path.lineTo(0, cornerRadius);
    path.quadraticBezierTo(0, 0, cornerRadius, 0); // top-left curve
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
