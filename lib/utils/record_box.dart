// ignore_for_file: prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RecordBox extends StatelessWidget {
  final doctorData;
  final PrescriptionData;
  RecordBox({super.key, this.doctorData, this.PrescriptionData});

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = PrescriptionData['time'].toDate();
    String monthName = DateFormat('MMMM').format(dateTime);
    String day = dateTime.day.toString();
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color(0xFFAEE2FF),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xFFdcf1ff),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(monthName),
                        Text(day),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        doctorData != null
                            ? Text(
                                doctorData['specialization'],
                                style: TextStyle(fontSize: 20),
                              )
                            : Text(
                                doctorData['specialization'],
                                style: TextStyle(fontSize: 20),
                              ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Text(doctorData['name']),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
