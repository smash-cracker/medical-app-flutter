// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, iterable_contains_unrelated_type

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:medical/model/booking.dart';
import 'package:medical/screens/booking_confirm.dart';
import 'package:medical/screens/history.dart';
import 'package:uuid/uuid.dart';
import '../utils/date_utils.dart' as date_util;

class BookDoctor extends StatefulWidget {
  const BookDoctor({super.key, required this.dSnap});
  final DocumentSnapshot<Object?> dSnap;

  @override
  State<BookDoctor> createState() => _BookDoctorState();
}

class _BookDoctorState extends State<BookDoctor> {
  List<DateTime> currentMonthList = List.empty();
  late ScrollController scrollController;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;

  DateTime currentDateTime = DateTime.now();
  int _selected = DateTime.now().day;
  int _selectedTime = DateTime.now().day;
  List<String> redList = [];
  String noon = '';

  int date = DateTime.now().day;
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
      title: Text("Not available"),
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

  Future<String> bookUser({
    required String userID,
    required String doctorID,
    required String date,
  }) async {
    String result = "some error occured";
    String bookingID = const Uuid().v1();
    Booking booking = Booking(
        userID: userID, doctorID: doctorID, date: date, bookingID: bookingID);
    try {
      if (true) {
        var now = DateTime.now();
        var formatter = DateFormat('yyyy');
        String year = formatter.format(now);
        var rng = Random();
        var pin = rng.nextInt(9000) + 1000;

        await _firestore.collection('booking').doc(bookingID).set({
          'userID': userID,
          'doctorID': doctorID,
          'date': date,
          'bookingID': bookingID,
          'consult_date':
              '${DateFormat('MMMM').format(DateTime.now()).toString().substring(0, 3)} ${_selected + 1} $year ${_selectedTime + 1}:00 $noon',
          'pin': pin,
        });
        result = "success";
      }
    } catch (err) {
      result = err.toString();
    }
    try {
      await _firestore.collection('users').doc(widget.dSnap['uid']).update({
        'patients': FieldValue.arrayUnion(
          [bookingID],
        ),
      });
    } catch (e) {
      print(e.toString());
    }

    try {
      await _firestore.collection('users').doc(user.uid).update({
        'bookings': FieldValue.arrayUnion(
          [bookingID],
        ),
      });
    } catch (e) {
      print(e.toString());
    }

    return result;
  }

  Future bookUserToList() async {
    try {
      await _firestore.collection('users').doc(widget.dSnap['uid']).update({
        'patients': FieldValue.arrayUnion(
          [user.uid],
        ),
      });
    } catch (e) {
      print(e.toString());
    }
    // try {
    //   await _firestore.collection('users').doc(widget.dSnap['uid']).set({
    //     'patients': FieldValue.arrayUnion(
    //       [user.uid],
    //     ),
    //   });
    // } catch (e) {
    //   print(e.toString());
    // }
  }

  List<String> datesList = [];

  @override
  void initState() {
    super.initState();
    currentMonthList = date_util.DateUtils.daysInMonth(currentDateTime);
    currentMonthList.sort((a, b) => a.day.compareTo(b.day));
    currentMonthList = currentMonthList.toSet().toList();
    scrollController =
        ScrollController(initialScrollOffset: 70.0 * currentDateTime.day);

    //dates to list
  }

  Widget horizontalTimeCapsule() {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 23,
        itemBuilder: (BuildContext context, int index) {
          int hour = index + 1;
          String time = '$hour:00';
          if (redList.contains('$hour:00')) {
            return Center(
              child: TimecapsuleView(index, time, true),
            );
          } else {
            return Center(
              child: TimecapsuleView(index, time, false),
            );
          }
        },
      ),
    );
  }

  Widget TimecapsuleView(int index, String time, bool red) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
        child: GestureDetector(
          onTap: () {
            if (red) {
              showAlertDialog(context, "This slot is already booked");
            } else {
              setState(() {
                _selectedTime = index;
                noon = index < 11 ? 'AM' : 'PM';
              });
            }
          },
          child: Container(
            width: 90,
            height: 110,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: _selectedTime == index
                      ? [
                          Color(0xFFFFFFFF),
                          Color(0xFFFFFFFF),
                          Color(0xFFFFFFFF),
                        ]
                      : [
                          Color(0xFFc0c1e5),
                          Color(0xFFc0c1e5),
                          Color(0xFFc0c1e5),
                        ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(0.0, 1.0),
                  stops: const [0.0, 0.5, 1.0],
                  tileMode: TileMode.clamp),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 28,
                      color: red ? Colors.red : Colors.black,
                    ),
                  ),
                  index < 11
                      ? Text(
                          'AM',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: red ? Colors.red : Colors.black,
                          ),
                        )
                      : Text(
                          'PM',
                          style: TextStyle(
                            color: red ? Colors.red : Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget horizontalScrollTimeCapsule() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 24,
        itemBuilder: (context, index) {
          final time = TimeOfDay(hour: index ~/ 2, minute: (index % 2) * 30);

          return Container(
            margin: EdgeInsets.symmetric(horizontal: 4),
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(time.format(context)),
          );
        },
      ),
    );
  }

  Widget hrizontalCapsuleListView() {
    return SizedBox(
      height: 140,
      child: Row(
        children: [
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: currentMonthList.length,
              itemBuilder: (BuildContext context, int index) {
                return capsuleView(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget capsuleView(int index) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
        child: GestureDetector(
          onTap: () {
            setState(() {
              currentDateTime = currentMonthList[index];
              date = (index + 1);
              _selected = date - 1;
            });
          },
          child: Container(
            width: 90,
            height: 110,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: (currentMonthList[index].day != currentDateTime.day)
                      ? [
                          Color(0xFFc0c1e5),
                          Color(0xFFc0c1e5),
                          Color(0xFFc0c1e5),
                        ]
                      : [
                          Color(0xFFFFFFFF),
                          Color(0xFFFFFFFF),
                          Color(0xFFFFFFFF),
                        ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(0.0, 1.0),
                  stops: const [0.0, 0.5, 1.0],
                  tileMode: TileMode.clamp),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    currentMonthList[index].day.toString(),
                    style: TextStyle(
                      fontSize: 28,
                    ),
                  ),
                  Text(
                    date_util.DateUtils
                        .weekdays[currentMonthList[index].weekday - 1],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    datesList.clear();
    redList.clear();
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(
            top: 18.0,
            right: 18.0,
            left: 18.0,
          ),
          child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('booking')
                  .where('doctorID', isEqualTo: widget.dSnap['uid'])
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  for (var doc in snapshot.data!.docs) {
                    String date = doc['consult_date'];
                    datesList.add(date);
                  }

                  //start logic
                  for (var x in datesList) {
                    var datas = x.split(' ');
                    if (DateFormat('MMMM')
                            .format(DateTime.now())
                            .toString()
                            .substring(0, 3) ==
                        datas[0]) {
                      if (_selected + 1 == int.parse(datas[1])) {
                        redList.add(datas[3]);
                      }
                    }
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Icon(
                              CupertinoIcons.back,
                            ),
                          ),
                          Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                widget.dSnap['name'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(widget.dSnap['specialization']),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),

                          SizedBox(
                            width: 100,
                            height: 100,
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                              child: Image(
                                fit: BoxFit.cover,
                                image: NetworkImage(widget.dSnap['photourl']),
                              ),
                            ),
                          ),
                          // GestureDetector(
                          //   onTap: () {
                          //     Navigator.of(context).push(
                          //       MaterialPageRoute(
                          //         builder: (_) =>
                          //         // MedicalHistory(),
                          //       ),
                          //     );
                          //   },
                          //   child: FaIcon(
                          //     FontAwesomeIcons.book,
                          //   ),
                          // ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFF6d6ebb),
                                Color(0xFFcccdf1),
                              ],
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                'Book',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 45,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              hrizontalCapsuleListView(),

                              // horizontalScrollTimeCapsule(),
                              horizontalTimeCapsule(),
                              GestureDetector(
                                onTap: () async {
                                  print(
                                    '${_selected + 1}-${_selectedTime + 1}-$noon',
                                  );
                                  bookUser(
                                      date: DateTime.now().toString(),
                                      doctorID: widget.dSnap['uid'],
                                      userID: user.uid);
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => BookConfirm(
                                        datetime:
                                            '${_selected + 1}-${_selectedTime + 1}-$noon',
                                        doc: widget.dSnap['name'],
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(40)),
                                  height: 80.0,
                                  width: 200.0,
                                  child: Center(
                                    child: Text(
                                      'Book now',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }

                return Container();
              }),
        ),
      ),
    );
  }
}
