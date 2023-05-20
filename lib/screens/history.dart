// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medical/screens/book_doctor.dart';
import 'package:medical/screens/prescription.dart';
import 'package:medical/utils/record_box.dart';

class MedicalHistory extends StatelessWidget {
  MedicalHistory({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFFe5e5fe),
        actions: [
          // GestureDetector(
          //   onTap: () {},
          //   child: Icon(
          //     Icons.book,
          //     color: Colors.black,
          //   ),
          // ),
        ],
      ),
      backgroundColor: Color(0xFFe5e5fe),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Transform.rotate(
                angle: 20,
                child: FaIcon(
                  FontAwesomeIcons.leaf,
                  color: Colors.white,
                  size: 100,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Here is your',
                style: TextStyle(fontSize: 30),
              ),
              Text(
                'medical history',
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(
                height: 150,
                child: FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(auth.currentUser!.uid)
                      .get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    }

                    Map<String, dynamic> snap =
                        snapshot.data!.data() as Map<String, dynamic>;

                    if (snap['prescriptions'] == null) {
                      return Center(
                        child: Text(
                          'No prescriptions',
                        ),
                      );
                    } else {
                      List<dynamic> bookingIds = snap['prescriptions'];

                      return ListView.builder(
                        itemCount: bookingIds.length,
                        itemBuilder: (BuildContext context, int index) {
                          String bookingId = bookingIds[index];
                          return FutureBuilder<DocumentSnapshot>(
                            future: FirebaseFirestore.instance
                                .collection('prescriptions')
                                .doc(bookingId)
                                .get(),
                            builder: (BuildContext context,
                                AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (!snapshot.hasData) {
                                return Container();
                              }
                              Map<String, dynamic> Prescriptiondata =
                                  snapshot.data!.data() as Map<String, dynamic>;

                              String doctorId = Prescriptiondata['doctorID'];

                              return FutureBuilder<DocumentSnapshot>(
                                future: FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(doctorId)
                                    .get(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                                  if (!snapshot.hasData) {
                                    return Container();
                                  }
                                  Map<String, dynamic> Doctordata =
                                      snapshot.data!.data()
                                          as Map<String, dynamic>;
                                  String doctorName = Doctordata['name'];
                                  return SizedBox(
                                    height: 150,
                                    child: GestureDetector(
                                      onTap: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => Prescription(
                                            doctorName: doctorName,
                                            prescription: Prescriptiondata,
                                          ),
                                        ),
                                      ),
                                      child: RecordBox(
                                        doctorData: Doctordata,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
