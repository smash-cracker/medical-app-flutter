// // ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:medical/screens/book_doctor.dart';
// import 'package:medical/screens/prescription.dart';
// import 'package:medical/utils/record_box.dart';

// class MedicalHistory extends StatelessWidget {
//   MedicalHistory({super.key, required this.dSnap});
//   var dSnap;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Color(0xFFdcf1ff),
//         actions: [
//           GestureDetector(
//             onTap: () {
//               Navigator.of(context).push(MaterialPageRoute(
//                   builder: (_) => BookDoctor(
//                         dSnap: dSnap,
//                       )));
//             },
//             child: Icon(
//               Icons.book,
//               color: Colors.black,
//             ),
//           ),
//         ],
//       ),
//       backgroundColor: Color(0xFFdcf1ff),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Transform.rotate(
//                 angle: 20,
//                 child: FaIcon(
//                   FontAwesomeIcons.leaf,
//                   color: Colors.white,
//                   size: 100,
//                 ),
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               Text(
//                 'Here is your',
//                 style: TextStyle(fontSize: 30),
//               ),
//               Text(
//                 'medical history',
//                 style: TextStyle(fontSize: 30),
//               ),
//               GestureDetector(
//                   onTap: () => Navigator.of(context).push(
//                         MaterialPageRoute(
//                           builder: (_) => Prescription(),
//                         ),
//                       ),
//                   child: RecordBox()),
//               GestureDetector(
//                   onTap: () => Navigator.of(context).push(
//                         MaterialPageRoute(
//                           builder: (_) => Prescription(),
//                         ),
//                       ),
//                   child: RecordBox()),
//               GestureDetector(
//                   onTap: () => Navigator.of(context).push(
//                         MaterialPageRoute(
//                           builder: (_) => Prescription(),
//                         ),
//                       ),
//                   child: RecordBox()),
//               GestureDetector(
//                   onTap: () => Navigator.of(context).push(
//                         MaterialPageRoute(
//                           builder: (_) => Prescription(),
//                         ),
//                       ),
//                   child: RecordBox()),
//               GestureDetector(
//                   onTap: () => Navigator.of(context).push(
//                         MaterialPageRoute(
//                           builder: (_) => Prescription(),
//                         ),
//                       ),
//                   child: RecordBox()),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
