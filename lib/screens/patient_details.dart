// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical/screens/add_prescription.dart';
import 'package:medical/screens/prescription.dart';
import 'package:medical/utils/record_box.dart';

class PatientDetails extends StatelessWidget {
  PatientDetails({
    super.key,
    required this.data,
    required this.pin,
    required this.fromPatient,
  });
  final String pin;
  var data;
  bool fromPatient;

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => AddPrescription(
                patientID: data['uid'],
              ),
            ),
          );
        },
        child: Icon(CupertinoIcons.add_circled),
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        title: fromPatient
            ? Text(
                'Doctor Details',
                style: TextStyle(color: Colors.black),
              )
            : Text(
                'Patient Details',
                style: TextStyle(color: Colors.black),
              ),
        leading: Icon(
          CupertinoIcons.back,
          color: Colors.black,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xFFe5e5fe),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 9,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(0xFFf5f5da).withOpacity(0.5),
                            ),
                            child: Text(
                              'Pin : ${pin}',
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Icon(
                            CupertinoIcons.qrcode,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            data['name'],
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              '80',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              '(kg)',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'weight',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        //
                        Container(
                          margin: EdgeInsets.all(20),
                          height: 150.0,
                          width: 150.0,
                          decoration: BoxDecoration(
                            color: Color(0xFF2C74B3).withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Container(
                            margin: EdgeInsets.all(20),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: ClipOval(
                                child: Image(
                                  fit: BoxFit.cover,
                                  height: 150.0,
                                  width: 150.0,
                                  image: NetworkImage(
                                    data['photourl'],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        //
                        Column(
                          children: [
                            Text(
                              '5\'6\'\'',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              '(ft\'in\'\')',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'height',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(auth)
                    .get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }

                  Map<String, dynamic> snap =
                      snapshot.data!.data() as Map<String, dynamic>;

                  print(snap);

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
                            if (doctorId == data['uid']) {
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
                            }
                            return Container();
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
    );
  }
}
