// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:medical/screens/patient_details.dart';
import 'package:medical/utils/patient_box.dart';

class BookingList extends StatefulWidget {
  BookingList({
    super.key,
  });

  @override
  _BookingListState createState() => _BookingListState();
}

class _BookingListState extends State<BookingList> {
  final user = FirebaseAuth.instance.currentUser!;
  String selectedOption = 'Upcoming'; // Set the default value to 'All'
  Widget _buildOption(String option) {
    return ListTile(
      title: Text(option),
      onTap: () {
        Navigator.of(context)
            .pop(option); // Close the dialog and return the selected option
      },
    );
  }

  DateTime getdatetime(String dateString) {
    final parts = dateString.split(' ');
    final monthStr = parts[0];
    final day = int.parse(parts[1]);
    final year = int.parse(parts[2]);
    final time = int.parse(parts[3].split(':')[0]);

    int month;
    switch (monthStr) {
      case 'Jan':
        month = 1;
        break;
      case 'Feb':
        month = 2;
        break;
      case 'Mar':
        month = 3;
        break;
      case 'Apr':
        month = 4;
        break;
      case 'May':
        month = 5;
        break;
      case 'Jun':
        month = 6;
        break;
      case 'Jul':
        month = 7;
        break;
      case 'Aug':
        month = 8;
        break;
      case 'Sep':
        month = 9;
        break;
      case 'Oct':
        month = 10;
        break;
      case 'Nov':
        month = 11;
        break;
      case 'Dec':
        month = 12;
        break;
      default:
        throw ArgumentError('Invalid month string: $monthStr');
    }

    return DateTime(year, month, day, time);
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filter Options'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                _buildOption('All'),
                _buildOption('Completed'),
                _buildOption('Today'),
                _buildOption('Upcoming'),
              ],
            ),
          ),
        );
      },
    ).then((value) {
      // The dialog has been closed, update the selectedOption variable
      if (value != null) {
        setState(() {
          selectedOption = value;
        });
        // Do something with the selected option, such as filter the list
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final String userId = user.uid;
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking List'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: GestureDetector(
                  onTap: () {
                    _showFilterDialog();
                  },
                  child: Chip(
                    label: Row(
                      children: [
                        Text(selectedOption),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          CupertinoIcons.arrowtriangle_down_square,
                          size: 16,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(userId)
                  .get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                Map<String, dynamic> snap =
                    snapshot.data!.data() as Map<String, dynamic>;

                if (snap['bookings'] == null) {
                  return Center(
                    child: Text(
                      'No Bookings',
                    ),
                  );
                } else {
                  List<dynamic> bookingIds = snap['bookings'];

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
                          String doctorId = data['doctorID'];

                          if (selectedOption == 'All') {
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
                                Map<String, dynamic> datas = snapshot.data!
                                    .data() as Map<String, dynamic>;
                                String doctorName = datas['name'];
                                return SizedBox(
                                  height: 250,
                                  child: PatientBox(
                                    bookingData: data,
                                    data: datas,
                                  ),
                                );
                              },
                            );
                          } else if (selectedOption == 'Today') {
                            final now = DateTime.now();

                            final consultDateStr = data['consult_date'];

                            final consultDate = getdatetime(consultDateStr);
                            if (isSameDay(now, consultDate)) {
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
                                  Map<String, dynamic> datas = snapshot.data!
                                      .data() as Map<String, dynamic>;
                                  String doctorName = datas['name'];
                                  return SizedBox(
                                    height: 250,
                                    child: PatientBox(
                                      bookingData: data,
                                      data: datas,
                                    ),
                                  );
                                },
                              );
                            }
                          } else if (selectedOption == 'Completed') {
                            final now = DateTime.now();

                            final consultDateStr = data['consult_date'];

                            final consultDate = getdatetime(consultDateStr);

                            if (consultDate.isBefore(now)) {
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
                                  Map<String, dynamic> datas = snapshot.data!
                                      .data() as Map<String, dynamic>;
                                  String doctorName = datas['name'];
                                  return SizedBox(
                                    height: 250,
                                    child: PatientBox(
                                      bookingData: data,
                                      data: datas,
                                    ),
                                  );
                                },
                              );
                            }
                          } else {
                            final now = DateTime.now();

                            final consultDateStr = data['consult_date'];

                            final consultDate = getdatetime(consultDateStr);

                            if (consultDate.isAfter(now)) {
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
                                  Map<String, dynamic> datas = snapshot.data!
                                      .data() as Map<String, dynamic>;
                                  String doctorName = datas['name'];
                                  return SizedBox(
                                    height: 250,
                                    child: PatientBox(
                                      bookingData: data,
                                      data: datas,
                                    ),
                                  );
                                },
                              );
                            }
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
