// // ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

// import 'dart:math';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
// import 'package:loading_animation_widget/loading_animation_widget.dart';
// import 'package:medical/screens/patient_details.dart';
// import 'package:medical/utils/patient_box.dart';

// class UserBookings extends StatefulWidget {
//   const UserBookings({super.key});

//   @override
//   State<UserBookings> createState() => _UserBookingsState();
// }

// class _UserBookingsState extends State<UserBookings> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final user = FirebaseAuth.instance.currentUser!;
//   List<dynamic> getPatiendtIDListOfDoctor = [];
//   List<QueryDocumentSnapshot> documents = [];
//   List<QueryDocumentSnapshot> Docdocuments = [];

//   Future getBookingIDsOfUser() async {
//     await _firestore.collection('users').doc(user.uid).get().then((doc) {
//       getPatiendtIDListOfDoctor = doc.data()!['bookings'];
//     });
//     print("getPatiendtIDListOfDoctor");
//     print(getPatiendtIDListOfDoctor);
//   }

// //
//   Future getDoctor(String doctorID) async {
//     final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//     List<Future<QuerySnapshot>> futures = [];

//     futures.add(
//         _firestore.collection('users').where('uid', isEqualTo: doctorID).get());

//     List<QuerySnapshot> snapshots = await Future.wait(futures);

//     Docdocuments = [];

//     for (QuerySnapshot snapshot in snapshots) {
//       print(snapshot.docs.first);

//       try {
//         documents.add(snapshot.docs.first);
//       } catch (e) {
//         print(e.toString());
//       }
//     }
//     print("Docdocuments");
//     print(Docdocuments);
//     print("Docdocuments");
//   }
//   //

//   Future getBookingDetails(List<dynamic> requestIds) async {
//     List<Future<QuerySnapshot>> futures = [];

//     for (String id in requestIds) {
//       futures.add(_firestore
//           .collection('booking')
//           .where('userID', isEqualTo: user.uid)
//           .get());
//     }

//     List<QuerySnapshot> snapshots = await Future.wait(futures);

//     documents = [];

//     for (var snapshot in snapshots) {
//       try {
//         documents.add(snapshot.docs.first);
//       } catch (e) {
//         print(e.toString());
//       }
//     }
//   }

//   bool searchBox = false;
//   String searchText = '';

//   @override
//   Widget build(BuildContext context) {
//     CollectionReference usersRef = _firestore.collection('users');
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         title: Text(
//           'Bookings',
//           style: TextStyle(color: Colors.black),
//         ),
//         centerTitle: true,
//         leading: GestureDetector(
//           onTap: Navigator.of(context).pop,
//           child: Icon(
//             CupertinoIcons.back,
//             color: Colors.black,
//           ),
//         ),
//       ),
//       body: Container(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 20.0,
//                 vertical: 8.0,
//               ),
//               child: searchBox
//                   ? searchBar('Search doctors')
//                   : Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Chip(
//                           label: Row(
//                             children: [
//                               Text('sort'),
//                               SizedBox(
//                                 width: 10,
//                               ),
//                               Icon(
//                                 CupertinoIcons.arrowtriangle_down_square,
//                                 size: 16,
//                               )
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//             ),
//             FutureBuilder(
//                 future: getBookingIDsOfUser(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return CircularProgressIndicator();
//                   }
//                   if (snapshot.connectionState == ConnectionState.done) {
//                     return Expanded(
//                       child: Column(
//                         children: [
//                           FutureBuilder(
//                             future:
//                                 getBookingDetails(getPatiendtIDListOfDoctor),
//                             builder: (context, snapshot) {
//                               if (snapshot.connectionState ==
//                                   ConnectionState.waiting) {
//                                 return Center(
//                                   child: LoadingAnimationWidget.waveDots(
//                                       color: Colors.white, size: 40),
//                                 );
//                               }

//                               if (snapshot.hasError) {
//                                 return Text(snapshot.error.toString());
//                               }

//                               if (snapshot.connectionState ==
//                                   ConnectionState.done) {
//                                 Map<String, dynamic> snap = snapshot.data!
//                                     .data() as Map<String, dynamic>;
//                                 String docid = snap['uid'];
//                                 return SingleChildScrollView(
//                                   child: Expanded(
//                                       child: Column(
//                                     children: [
//                                       Container(
//                                         height:
//                                             MediaQuery.of(context).size.height,
//                                         child: FutureBuilder(
//                                           future:
//                                               usersRef.doc(snap['uid']).get(),
//                                           builder: (BuildContext context,
//                                               AsyncSnapshot snapshot) {
//                                             if (snapshot.connectionState ==
//                                                 ConnectionState.waiting) {
//                                               return Center(
//                                                 child: LoadingAnimationWidget
//                                                     .waveDots(
//                                                         color: Colors.white,
//                                                         size: 40),
//                                               );
//                                             }
//                                             if (snapshot.hasError) {
//                                               return Text(
//                                                   snapshot.error.toString());
//                                             }
//                                             if (snapshot.connectionState ==
//                                                 ConnectionState.done) {
//                                               Map<String, dynamic> doctor =
//                                                   snapshot.data!.data()
//                                                       as Map<String, dynamic>;
//                                               return Expanded(
//                                                 child: ListView.builder(
//                                                     itemCount: documents.length,
//                                                     itemBuilder:
//                                                         (context, index) {
//                                                       Map<String, dynamic>
//                                                           data =
//                                                           documents[index]
//                                                                   .data()
//                                                               as Map<String,
//                                                                   dynamic>;
//                                                       print("snap");
//                                                       print(snap);
//                                                       print("snap");
//                                                       print("data");
//                                                       print(data);
//                                                       print("data");
//                                                       print("doctor");
//                                                       print(doctor);
//                                                       print("doctor");
//                                                       return Container(
//                                                         height: 250,
//                                                         child: GestureDetector(
//                                                             onTap: () {
//                                                               // Navigator.of(context).push(
//                                                               //     MaterialPageRoute(
//                                                               //         builder: (_) =>
//                                                               //             PatientDetails(
//                                                               //               data:
//                                                               //                   data,
//                                                               //             )));
//                                                             },
//                                                             child: Column(
//                                                               children: [
//                                                                 // Text(user[''])
//                                                                 Text(data[
//                                                                     'bookingID']),
//                                                               ],
//                                                             )),
//                                                       );
//                                                     }),
//                                               );
//                                             }
//                                             return Container();
//                                           },
//                                         ),
//                                       )
//                                     ],
//                                   )),
//                                 );
//                               }
//                               return Container();
//                             },
//                           ),
//                         ],
//                       ),
//                     );
//                   }
//                   return Container();
//                 }),

//             // GestureDetector(
//             //     onTap: () {
//             //       Navigator.of(context).push(
//             //           MaterialPageRoute(builder: (_) => PatientDetails()));
//             //     },
//             //     child: Container(height: 230, child: PatientBox())),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget searchBar(String placehold) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
//       child: CupertinoSearchTextField(
//         onChanged: (value) {
//           setState(() {
//             searchText = value;
//           });
//         },
//         borderRadius: BorderRadius.circular(10.0),
//         placeholder: placehold,
//       ),
//     );
//   }
// }

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
            return CircularProgressIndicator();
          }

          Map<String, dynamic> snap =
              snapshot.data!.data() as Map<String, dynamic>;

          print(snap);

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

                    final consultDate = DateFormat.MMMd()
                        .add_y()
                        .add_jm()
                        .parse(consultDateStr);
                    print(isSameDay(now, consultDate));

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
