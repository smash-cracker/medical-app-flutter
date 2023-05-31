// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:medical/screens/patient_details.dart';
import 'package:medical/utils/patient_box.dart';

class DoctorBookingList extends StatefulWidget {
  DoctorBookingList({
    super.key,
  });

  @override
  _DoctorBookingListState createState() => _DoctorBookingListState();
}

class _DoctorBookingListState extends State<DoctorBookingList> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    final String userId = user.uid;
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking List'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance.collection('users').doc(userId).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: Center(child: CircularProgressIndicator()));
          }

          Map<String, dynamic> snap =
              snapshot.data!.data() as Map<String, dynamic>;

          if (snap['patients'] == null) {
            return Center(
              child: Text(
                'No Bookings',
              ),
            );
          } else {
            List<dynamic> bookingIds = snap['patients'];

            return ListView.builder(
              itemCount: bookingIds.length,
              itemBuilder: (BuildContext context, int index) {
                String bookingId = bookingIds[index];
                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('booking')
                      .doc(bookingId)
                      .get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    }
                    Map<String, dynamic> data =
                        snapshot.data!.data() as Map<String, dynamic>;

                    final now = DateTime.now();

                    final consultDateStr = data['consult_date'];

                    final updatedDateStr =
                        consultDateStr.replaceAll(RegExp(r"\s[AP]M$"), "");

                    final dateFormat = DateFormat("MMM d yyyy HH:mm");
                    final consultDate = dateFormat.parse(updatedDateStr);

                    if (isSameDay(now, consultDate)) {
                      String doctorId = data['userID'];
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
                          Map<String, dynamic> datas =
                              snapshot.data!.data() as Map<String, dynamic>;
                          String doctorName = datas['name'];
                          return SizedBox(
                            height: 250,
                            child: PatientBox(
                              isFromDoctor: true,
                              bookingData: data,
                              data: datas,
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
    );
  }

  static bool isSameDay(DateTime? dateA, DateTime? dateB) {
    return dateA?.year == dateB?.year &&
        dateA?.month == dateB?.month &&
        dateA?.day == dateB?.day;
  }
}

class BookingBox extends StatelessWidget {
  final String bookingId;
  final String doctorName;

  BookingBox({required this.bookingId, required this.doctorName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Booking ID: $bookingId'),
          SizedBox(height: 5),
          Text('Doctor Name: $doctorName'),
        ],
      ),
    );
  }
}
