// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medical/screens/book_doctor.dart';
import 'package:medical/screens/history.dart';
import 'package:medical/utils/doctor_box.dart';

class DoctorList extends StatelessWidget {
  const DoctorList({super.key, required this.searchText});
  final String searchText;

  @override
  Widget build(BuildContext context) {
    print(searchText);
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('users').get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          final doctorsList = (snapshot.data! as QuerySnapshot)
              .docs
              .where((doc) => doc['type'] == 'Doctor')
              .toList();
          return GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: doctorsList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisExtent: 250,
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 1,
            ),
            itemBuilder: ((context, index) {
              final snap = doctorsList[index];
              if (snap['name']
                  .toString()
                  .toLowerCase()
                  .contains(searchText.toLowerCase())) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => MedicalHistory(
                          dSnap: snap,
                        ),
                        // BookDoctor(
                        //   dSnap: snap,
                        // ),
                      ),
                    );
                  },
                  child: DoctorBox(
                    dSnap: snap,
                  ),
                );
              }
            }),
          );
        }
      }),
    );
  }
}
