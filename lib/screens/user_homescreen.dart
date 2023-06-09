// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medical/screens/doctor_homescreen.dart';
import 'package:medical/screens/history.dart';
import 'package:medical/screens/patients.dart';
import 'package:medical/screens/consultancy.dart';
import 'package:medical/screens/insurance_homescreen.dart';
import 'package:medical/screens/user_bookings.dart';
import 'package:medical/screens/profile.dart';

class UserHomeScreen extends StatefulWidget {
  UserHomeScreen({super.key, required this.snap});
  var snap;

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  showAlertDialog(BuildContext context, String message) {
    // set up the button
    Widget okButton = ElevatedButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Message"),
      content: Text(message),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: widget.snap["type"] == "doctor"
                ? GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (_) => DoctorHomeScreen(
                                snap: widget.snap,
                              )));
                    },
                    child: Icon(
                      Icons.swap_horiz_rounded,
                      color: Colors.black,
                      size: 30,
                    ),
                  )
                : Container(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello',
                    style: TextStyle(fontSize: 30),
                  ),
                  Text(
                    '${widget.snap["name"]} 👋',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => Consultancy(),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(30),
                  ),
                  color: Color(0xFFfaf8f4),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Row(children: [
                    Icon(CupertinoIcons.search),
                    SizedBox(
                      width: 20,
                    ),
                    Text('search for a doctor'),
                  ]),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => BookingList(),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                        color: Color(0xFFffddc2),
                      ),
                      height: MediaQuery.of(context).size.height * 0.25,
                      width: MediaQuery.of(context).size.width * 0.38,
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Color(
                                  0xFFffcea8,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: FaIcon(FontAwesomeIcons.pills),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 60,
                            ),
                            Text(
                              'My bookings',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(
                              height: 30,
                              child: FutureBuilder<DocumentSnapshot>(
                                  future: FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(user.uid)
                                      .get(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<DocumentSnapshot>
                                          snapshot) {
                                    if (!snapshot.hasData) {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    }

                                    Map<String, dynamic> snap = snapshot.data!
                                        .data() as Map<String, dynamic>;

                                    if (snap['bookings'] == null) {
                                      return Text('0 bookings');
                                    } else {
                                      final bookingIds =
                                          snap['bookings'].length;
                                      return Text(
                                          '${bookingIds.toString()} bookings');
                                    }
                                  }),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  //

                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => InsuranceHomescreen(cpy: false),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                        color: Color(0xFFe5e5fe),
                      ),
                      height: MediaQuery.of(context).size.height * 0.25,
                      width: MediaQuery.of(context).size.width * 0.38,
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Color(
                                      0xFFd7d5fc,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: FaIcon(
                                        FontAwesomeIcons.helmetSafety,
                                      ),
                                      // FaIcon(FontAwesomeIcons.pills),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 60,
                                ),
                                Text(
                                  'Insurance',
                                  // 'Pharmacy',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                  child: FutureBuilder<int>(
                                    future: FirebaseFirestore.instance
                                        .collection('insurances')
                                        .get()
                                        .then((querySnapshot) =>
                                            querySnapshot.size),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        return Text(
                                            '${snapshot.data.toString()} available');
                                      } else {
                                        return Center(
                                            child: CircularProgressIndicator());
                                      }
                                    },
                                  ),
                                ),
                                // Text('6 pharmacies'),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: FaIcon(
                              FontAwesomeIcons.snowflake,
                              color: Color(0xFFd7d5fc),
                              size: 40,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  //
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'My Health',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
            ),

            //
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    showAlertDialog(context,
                        "Smartwatch connectivity not available right now.");
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                      color: Color(0xFFfaf8f4),
                    ),
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: MediaQuery.of(context).size.width * 0.38,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(CupertinoIcons.heart),
                            Text('Heart Rate'),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '- /',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('Heart Rate'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showAlertDialog(context,
                        "Smartwatch connectivity not available right now.");
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                      color: Color(0xFFfaf8f4),
                    ),
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: MediaQuery.of(context).size.width * 0.38,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(CupertinoIcons.zzz),
                            Text('Sleep'),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '- /',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('hrs'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Container(
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(10),
            //     color: Color(0xFF6b6bbf),
            //   ),
            //   child: Row(
            //     children: [

            //       Text('chat'),
            //     ],
            //   ),
            // ),
            GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => MedicalHistory()));
              },
              child: Container(
                width: 130,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Color(0xFF6b6bbf),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      right: 18.0, left: 8, top: 8, bottom: 8),
                  child: Row(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Color(
                            0xFF8888cb,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Icon(
                              FontAwesomeIcons.pills,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Pills',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            //

            Container(
              decoration: BoxDecoration(
                color: Color(0xFF6b6bbf),
                shape: BoxShape.circle,
              ),
              child: Container(
                margin: EdgeInsets.all(5),
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Color(0xFFfca968),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
              ),
            ),

            //

            GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => ProfilePage()));
              },
              child: Container(
                width: 130,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Color(0xFF6b6bbf),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      right: 8.0, left: 18, top: 8, bottom: 8),
                  child: Row(
                    children: [
                      Text(
                        'Profile',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Color(
                            0xFF8888cb,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Icon(
                              CupertinoIcons.person_crop_circle,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
