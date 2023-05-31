// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medical/model/call.dart';
import 'package:medical/screens/add_prescription.dart';
import 'package:medical/screens/call_screen.dart';
import 'package:medical/screens/prescription.dart';
import 'package:medical/utils/record_box.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

class PatientDetails extends StatelessWidget {
  PatientDetails({
    super.key,
    required this.data,
    required this.pin,
    this.fromPatient = true,
    required this.consultationTime,
  });
  final int pin;
  var data;
  final String consultationTime;
  bool fromPatient;
  final auth = FirebaseAuth.instance.currentUser;
  final firestore = FirebaseFirestore.instance;
  Call? senderCallData;
  Call? recieverCallData;

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

  void makeCall() {
    String callId = const Uuid().v1();
    senderCallData = Call(
      callerId: auth!.uid,
      callerName: 'caller',
      callerPic: data['photourl'],
      receiverId: data['uid'],
      receiverName: data['name'],
      receiverPic: data['photourl'],
      callId: callId,
      hasDialled: true,
    );

    recieverCallData = Call(
      callerId: auth!.uid,
      callerName: 'caller',
      callerPic: data['photourl'],
      receiverId: data['uid'],
      receiverName: data['name'],
      receiverPic: data['photourl'],
      callId: callId,
      hasDialled: false,
    );

    makeCallF(senderCallData!, recieverCallData!);
  }

  void makeCallF(
    Call senderCallData,
    Call receiverCallData,
  ) async {
    try {
      await firestore
          .collection('call')
          .doc(senderCallData.callerId)
          .set(senderCallData.toMap());
      await firestore
          .collection('call')
          .doc(senderCallData.receiverId)
          .set(receiverCallData.toMap());

      // Navigator.of(context).push(
      //   MaterialPageRoute(
      //       builder: (_) => CallScreen(
      //             channelId: senderCallData.callId,
      //             call: senderCallData,
      //             isGroupChat: false,
      //           )),
      // );

      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => CallScreen(
      //       channelId: senderCallData.callId,
      //       call: senderCallData,
      //       isGroupChat: false,
      //     ),
      //   ),
      // );
    } catch (e) {
      // showSnackBar(context: context, content: e.toString());
    }
  }

  static bool isSameDay(DateTime? dateA, DateTime? dateB) {
    return dateA?.year == dateB?.year &&
        dateA?.month == dateB?.month &&
        dateA?.day == dateB?.day &&
        dateA?.hour == dateB?.hour;
  }

  _launchMap(
    String hospital,
  ) async {
    final query = hospital;
    final encodedQuery = Uri.encodeComponent(query);
    final url = 'https://www.google.com/maps/search/?api=1&query=$encodedQuery';
    final uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print(e.toString());
    }
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

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final consultDateStr = consultationTime;

    final consultDate = getdatetime(consultDateStr);

    final auth = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      floatingActionButton: fromPatient
          ? Container()
          : FloatingActionButton(
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
                              color: Color.fromARGB(255, 255, 255, 248)
                                  .withOpacity(0.5),
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
                            fromPatient
                                ? isSameDay(now, consultDate)
                                    ? GestureDetector(
                                        onTap: () {
                                          makeCall();
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) => CallScreen(
                                                channelId:
                                                    senderCallData!.callId,
                                                call: senderCallData!,
                                                isGroupChat: false,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Icon(
                                          CupertinoIcons.videocam_circle,
                                          color: Colors.green,
                                          size: 30,
                                        ),
                                      )
                                    : GestureDetector(
                                        onTap: () {
                                          showAlertDialog(context,
                                              "Video call functionality only available during booked hours");
                                        },
                                        child: Icon(
                                          CupertinoIcons.videocam_circle,
                                          size: 30,
                                        ),
                                      )
                                : Container(),
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
                            fromPatient
                                ? IconButton(
                                    onPressed: () {
                                      _launchMap(data['hospital']);
                                    },
                                    icon: Icon(
                                      Icons.share_location_outlined,
                                      size: 30,
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            fromPatient
                ? Expanded(
                    child: FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(auth)
                          // .doc(data['uid'])
                          .get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return CircularProgressIndicator();
                        }

                        Map<String, dynamic> snap =
                            snapshot.data!.data() as Map<String, dynamic>;

                        print(snap['prescriptions']);

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
                              print("bookingIds");
                              print(bookingId);
                              return FutureBuilder<DocumentSnapshot>(
                                future: FirebaseFirestore.instance
                                    .collection('prescriptions')
                                    .doc(bookingId)
                                    .get(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<DocumentSnapshot> snapshotx) {
                                  if (!snapshotx.hasData) {
                                    return Container();
                                  }
                                  Map<String, dynamic> Prescriptiondata =
                                      snapshotx.data!.data()
                                          as Map<String, dynamic>;

                                  print(Prescriptiondata);

                                  String doctorId =
                                      Prescriptiondata['doctorID'];
                                  if (true) {
                                    return FutureBuilder<DocumentSnapshot>(
                                      future: FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(doctorId)
                                          .get(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<DocumentSnapshot>
                                              snapshoty) {
                                        if (!snapshoty.hasData) {
                                          return Container();
                                        }
                                        Map<String, dynamic> Doctordata =
                                            snapshoty.data!.data()
                                                as Map<String, dynamic>;
                                        String doctorName = Doctordata['name'];
                                        return SizedBox(
                                          height: 150,
                                          child: GestureDetector(
                                            onTap: () =>
                                                Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (_) => Prescription(
                                                  doctorName: doctorName,
                                                  prescription:
                                                      Prescriptiondata,
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
                  )
                : Expanded(
                    child: FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          //.doc(auth)
                          .doc(data['uid'])
                          .get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return CircularProgressIndicator();
                        }

                        Map<String, dynamic> snap =
                            snapshot.data!.data() as Map<String, dynamic>;

                        print(snap['prescriptions']);

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
                              print("bookingIds");
                              print(bookingId);
                              return FutureBuilder<DocumentSnapshot>(
                                future: FirebaseFirestore.instance
                                    .collection('prescriptions')
                                    .doc(bookingId)
                                    .get(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<DocumentSnapshot> snapshotx) {
                                  if (!snapshotx.hasData) {
                                    return Container();
                                  }
                                  Map<String, dynamic> Prescriptiondata =
                                      snapshotx.data!.data()
                                          as Map<String, dynamic>;

                                  print(Prescriptiondata);

                                  String doctorId =
                                      Prescriptiondata['doctorID'];
                                  if (true) {
                                    return FutureBuilder<DocumentSnapshot>(
                                      future: FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(doctorId)
                                          .get(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<DocumentSnapshot>
                                              snapshoty) {
                                        if (!snapshoty.hasData) {
                                          return Container();
                                        }
                                        Map<String, dynamic> Doctordata =
                                            snapshoty.data!.data()
                                                as Map<String, dynamic>;
                                        String doctorName = Doctordata['name'];
                                        return SizedBox(
                                          height: 150,
                                          child: GestureDetector(
                                            onTap: () =>
                                                Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (_) => Prescription(
                                                  doctorName: doctorName,
                                                  prescription:
                                                      Prescriptiondata,
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
