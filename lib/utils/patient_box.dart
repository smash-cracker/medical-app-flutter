// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:medical/screens/patient_details.dart';

class PatientBox extends StatelessWidget {
  static bool isSameDay(DateTime? dateA, DateTime? dateB) {
    return dateA?.year == dateB?.year &&
        dateA?.month == dateB?.month &&
        dateA?.day == dateB?.day;
  }

  var bookingData;

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

  PatientBox(
      {super.key,
      required this.data,
      this.bookingData,
      this.isFromDoctor = false});
  bool isFromDoctor;
  var data;
  String time = '';
  String hour = '';
  String ap = '';
  bool isAfternoon = false;
  DateTime consultDate = DateTime.now();
  String formattedDate = '';
  @override
  Widget build(BuildContext context) {
    if (bookingData != null) {
      final consultDateStr = bookingData['consult_date'];

      consultDate = getdatetime(consultDateStr);

      formattedDate = DateFormat.MMMd().add_y().add_jm().format(consultDate);
    }
    return Scaffold(
      body: Container(
        height: 200,
        margin: EdgeInsets.all(20),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Color(0xFFe5e5fe),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: 70,
                      width: 70,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            data['photourl'],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          data['name'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        isFromDoctor
                            ? Container()
                            : SizedBox(
                                width: 150,
                                child: Text(
                                  data['hospital'],
                                  overflow: TextOverflow.fade,
                                ),
                              ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Pin ${bookingData["pin"]}',
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(CupertinoIcons.clock),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    bookingData != null
                        ? Text(
                            '$formattedDate',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : Container(),
                  ],
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => PatientDetails(
                      consultationTime: bookingData["consult_date"],
                      fromPatient: !isFromDoctor,
                      data: data,
                      pin: bookingData["pin"],
                    ),
                  ),
                );
              },
              child: Container(
                width: 60,
                height: 150,
                decoration: BoxDecoration(
                  color: Color(0xFF11142c),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: RotatedBox(
                  quarterTurns: -3,
                  child: Center(
                    child: Text(
                      'Details',
                      style: TextStyle(color: Colors.white),
                    ),
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
