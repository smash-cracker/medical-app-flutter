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

  final bookingData;

  PatientBox({super.key, required this.data, this.bookingData});
  var data;
  String time = '';
  String hour = '';
  String ap = '';
  DateTime consultDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    if (bookingData != null) {
      String time = bookingData['consult_date'];

      consultDate = DateFormat.MMMd().add_y().add_jm().parse(time);
      final isAfternoon = consultDate.hour >= 12;
      hour = consultDate.hour.toString();

      ap = isAfternoon ? 'pm' : 'am';
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
                        Text(
                          'Age 23',
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
                            '${consultDate.day}-${consultDate.month}-${consultDate.year} $hour $ap',
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
                      fromPatient: true,
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
