// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class MedicinePrescriptionJs {
  String medicineName;
  String time;

  MedicinePrescriptionJs({required this.medicineName, required this.time});

  factory MedicinePrescriptionJs.fromJson(Map<String, dynamic> json) {
    return MedicinePrescriptionJs(
      medicineName: json['medicineName'],
      time: json['time'],
    );
  }
}

class Prescription extends StatelessWidget {
  final prescription;
  final String doctorName;
  const Prescription(
      {super.key, required this.prescription, required this.doctorName});

  Future<List<Map<String, dynamic>>> _fetchMedicines() async {
    var result = await FirebaseFirestore.instance
        .collection('prescriptions')
        .doc(prescription['prescriptionID'])
        .get();

    List<Map<String, dynamic>> medicines =
        List.from(result.data()!['medicines']);

    return medicines;
  }

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = prescription['time'].toDate();
    String formattedDate = DateFormat('dd-MMM-yyyy').format(dateTime);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        CupertinoIcons.back,
                      ),
                      Column(
                        children: [
                          Text(
                            doctorName.toUpperCase(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          Text(
                            formattedDate,
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 16),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: FaIcon(
                          FontAwesomeIcons.xmark,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Medicinces',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                FutureBuilder<Object>(
                    future: _fetchMedicines(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        List<Map<String, dynamic>> medicines =
                            snapshot.data as List<Map<String, dynamic>>;
                        return ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: medicines.length,
                            itemBuilder: (context, index) {
                              MedicinePrescriptionJs medicine =
                                  MedicinePrescriptionJs.fromJson(
                                      medicines[index]);
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        MedicineNameS(
                                          FontAwesomeIcons.pills,
                                          medicine.medicineName,
                                          '',
                                          Colors.blue[900]!,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        MedicineNameS(
                                          FontAwesomeIcons.clock,
                                          medicine.time,
                                          'Before food',
                                          Colors.redAccent[700]!,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              );
                            });
                      }
                    }),
                Text(
                  'Prescription',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  prescription['description'],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Images',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                FutureBuilder<Object>(builder: (context, snapshot) {
                  return GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: prescription['subPics'].length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: 180,
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: ((context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            prescription['subPics'][index],
                          ),
                        ),
                      );
                    }),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget MedicineNameS(
    IconData icon,
    String one,
    String two,
    Color color,
  ) {
    return Flexible(
      child: InkWell(
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[350],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              FaIcon(
                icon,
                color: color,
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(one),
                  Text(two),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
