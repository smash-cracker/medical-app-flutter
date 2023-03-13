// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:medical/screens/patient_details.dart';
import 'package:medical/utils/patient_box.dart';

class Patients extends StatefulWidget {
  const Patients({super.key});

  @override
  State<Patients> createState() => _PatientsState();
}

class _PatientsState extends State<Patients> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;
  List<dynamic> getPatiendtIDListOfDoctor = [];
  List<QueryDocumentSnapshot> documents = [];

  Future getPatienttIDsOfDoctor() async {
    await _firestore.collection('users').doc(user.uid).get().then((doc) {
      getPatiendtIDListOfDoctor = doc.data()!['patients'];
    });
    print("getPatiendtIDListOfDoctor");
    print(getPatiendtIDListOfDoctor);
  }

  Future getPatientDetails(List<dynamic> requestIds) async {
    List<Future<QuerySnapshot>> futures = [];

    for (String id in requestIds) {
      futures.add(
          _firestore.collection('users').where('uid', isEqualTo: id).get());
    }

    List<QuerySnapshot> snapshots = await Future.wait(futures);

    documents = [];

    for (var snapshot in snapshots) {
      try {
        documents.add(snapshot.docs.first);
      } catch (e) {
        print(e.toString());
      }
    }
  }

  bool searchBox = false;
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Patients',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: Navigator.of(context).pop,
          child: Icon(
            CupertinoIcons.back,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 8.0,
              ),
              child: searchBox
                  ? searchBar('Search doctors')
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Chip(
                          label: Row(
                            children: [
                              Text('sort'),
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
                        GestureDetector(
                          onTap: () {
                            searchBox = true;
                          },
                          child: Icon(
                            CupertinoIcons.search,
                          ),
                        ),
                      ],
                    ),
            ),
            FutureBuilder(
                future: getPatienttIDsOfDoctor(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Expanded(
                      child: Column(
                        children: [
                          FutureBuilder(
                            future:
                                getPatientDetails(getPatiendtIDListOfDoctor),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: LoadingAnimationWidget.waveDots(
                                      color: Colors.white, size: 40),
                                );
                              }

                              if (snapshot.hasError) {
                                return Text(snapshot.error.toString());
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return Expanded(
                                  child: ListView.builder(
                                      itemCount: documents.length,
                                      itemBuilder: (context, index) {
                                        Map<String, dynamic> data =
                                            documents[index].data()
                                                as Map<String, dynamic>;
                                        return Container(
                                          height: 250,
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          PatientDetails(
                                                            data: data,
                                                          )));
                                            },
                                            child: PatientBox(
                                              data: data,
                                            ),
                                          ),
                                        );
                                      }),
                                );
                              }
                              return Container();
                            },
                          ),
                        ],
                      ),
                    );
                  }
                  return Container();
                }),

            // GestureDetector(
            //     onTap: () {
            //       Navigator.of(context).push(
            //           MaterialPageRoute(builder: (_) => PatientDetails()));
            //     },
            //     child: Container(height: 230, child: PatientBox())),
          ],
        ),
      ),
    );
  }

  Widget searchBar(String placehold) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
      child: CupertinoSearchTextField(
        onChanged: (value) {
          setState(() {
            searchText = value;
          });
        },
        borderRadius: BorderRadius.circular(10.0),
        placeholder: placehold,
      ),
    );
  }
}
