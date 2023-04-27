// // ignore_for_file: prefer_const_constructors
// import 'dart:typed_data';

// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:medical/auth/auth_methods.dart';
// import 'package:medical/screens/login.dart';
// import 'package:medical/utils/utils.dart';

// class SignupScreen extends StatefulWidget {
//   const SignupScreen({Key? key}) : super(key: key);

//   @override
//   State<SignupScreen> createState() => _SignupScreenState();
// }

// class _SignupScreenState extends State<SignupScreen> {
//   Uint8List? _image;

//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmPassword = TextEditingController();
//   final _nameController = TextEditingController();
//   String selectedRadioButton = 'User';

//   bool passwordSame() {
//     if (_passwordController.text.trim() == _confirmPassword.text.trim()) {
//       return true;
//     } else {
//       return false;
//     }
//   }

//   Future signUp() async {
//     if (passwordSame()) {
//       UserCredential credentials = await FirebaseAuth.instance
//           .createUserWithEmailAndPassword(
//               email: _emailController.text.trim(),
//               password: _passwordController.text.trim());
//     }
//   }

//   void selectImage() async {
//     Uint8List? im = await pickImage(ImageSource.gallery);

//     setState(() {
//       _image = im;
//     });
//   }

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     _confirmPassword.dispose();
//     super.dispose();
//   }

//   List<String> types = ['user', 'doctor', 'insurance'];

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Container(
//       // height: 200,
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [
//             Color(0xFFcecff3),
//             Color(0xFF7272c4),
//           ],
//         ),
//       ),
//       child: SafeArea(
//         child: Scaffold(
//             backgroundColor: Color.fromARGB(255, 157, 157, 190),
//             // resizeToAvoidBottomInset: false,
//             body: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10.0),
//               child: SingleChildScrollView(
//                 child: Padding(
//                   padding: const EdgeInsets.only(
//                       top: 28.0, left: 10, right: 10, bottom: 10),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Stack(
//                         children: [
//                           Transform.translate(
//                             offset: Offset(-10, -20),
//                             child: CustomPaint(
//                               painter: OvalPainter(),
//                               child: Container(
//                                 width: MediaQuery.of(context).size.width,
//                                 height:
//                                     MediaQuery.of(context).size.height - 200,
//                               ),
//                             ),
//                           ),
//                           Positioned(
//                             left: 100,
//                             top: 100,
//                             child: CustomPaint(
//                               painter: OvalPainter2(),
//                               child: Container(
//                                 width: 100,
//                                 height: 150,
//                               ),
//                             ),
//                           ),
//                           Positioned(
//                             right: -40,
//                             top: -50,
//                             child: CustomPaint(
//                               painter: OvalPainter2(),
//                               child: Container(
//                                 width: 300,
//                                 height: 450,
//                               ),
//                             ),
//                           ),
//                           Positioned(
//                             right: -40,
//                             top: 200,
//                             child: CustomPaint(
//                               painter: OvalPainter2(),
//                               child: Container(
//                                 width: 300,
//                                 height: 450,
//                               ),
//                             ),
//                           ),
//                           Positioned(
//                             left: 50,
//                             top: 300,
//                             child: FaIcon(
//                               FontAwesomeIcons.snowflake,
//                               color: Color(0xFFd7d5fc),
//                               size: 60,
//                             ),
//                           ),
//                           Positioned(
//                             child: Column(
//                               children: [
//                                 Stack(
//                                   children: [
//                                     _image != null
//                                         ? CircleAvatar(
//                                             radius: 64,
//                                             backgroundImage:
//                                                 MemoryImage(_image!),
//                                           )
//                                         : const CircleAvatar(
//                                             radius: 64,
//                                             backgroundColor: Colors.purple,
//                                           ),
//                                     Positioned(
//                                       bottom: -5,
//                                       right: -5,
//                                       child: IconButton(
//                                         onPressed: selectImage,
//                                         icon: const Icon(Icons.add_a_photo),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 Container(
//                                   padding: EdgeInsets.only(
//                                       top: 35.0, left: 20.0, right: 20.0),
//                                   child: Column(
//                                     // ignore: prefer_const_literals_to_create_immutables
//                                     children: [
//                                       TextField(
//                                         controller: _nameController,
//                                         decoration: InputDecoration(
//                                           border: OutlineInputBorder(),
//                                           labelText: 'name',
//                                           labelStyle: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               color: Colors.grey),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         height: 20,
//                                       ),
//                                       TextField(
//                                         controller: _emailController,
//                                         keyboardType:
//                                             TextInputType.emailAddress,
//                                         decoration: InputDecoration(
//                                           border: OutlineInputBorder(),
//                                           labelText: 'email',
//                                           labelStyle: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               color: Colors.grey),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         height: 20,
//                                       ),
//                                       TextField(
//                                         obscureText: true,
//                                         controller: _passwordController,
//                                         decoration: InputDecoration(
//                                           border: OutlineInputBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(10.0)),
//                                           labelText: 'password',
//                                           labelStyle: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               color: Colors.grey),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         height: 20,
//                                       ),
//                                       TextField(
//                                         obscureText: true,
//                                         controller: _confirmPassword,
//                                         decoration: InputDecoration(
//                                           border: OutlineInputBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(10.0)),
//                                           labelText: 'confirm password',
//                                           labelStyle: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               color: Colors.grey),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         height: 20,
//                                       ),
//                                       Container(
//                                         height: 60,
//                                         width: 320,
//                                         child: DropdownSearch<String>(
//                                           popupProps: PopupProps.menu(
//                                             showSearchBox: true,
//                                             showSelectedItems: true,
//                                           ),
//                                           items: types,
//                                           dropdownDecoratorProps:
//                                               DropDownDecoratorProps(
//                                             dropdownSearchDecoration:
//                                                 InputDecoration(
//                                               border: OutlineInputBorder(
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                           10.0)),
//                                               labelText: 'choose role',
//                                               labelStyle: TextStyle(
//                                                   fontWeight: FontWeight.bold,
//                                                   color: Colors.grey),
//                                             ),
//                                           ),
//                                           onChanged: (val) {
//                                             setState(() {
//                                               selectedRadioButton = val!;
//                                             });
//                                           },
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         height: 20,
//                                       ),
//                                       SizedBox(
//                                         height: 60.0,
//                                         child: Material(
//                                           borderRadius:
//                                               BorderRadius.circular(10.0),
//                                           shadowColor: Colors.blueAccent,
//                                           color: Colors.blue,
//                                           elevation: 0,
//                                           child: GestureDetector(
//                                             onTap: () {
//                                               // signUp();
//                                               AuthMethods().signupUser(
//                                                 type: selectedRadioButton,
//                                                 email: _emailController.text
//                                                     .trim(),
//                                                 password: _passwordController
//                                                     .text
//                                                     .trim(),
//                                                 name:
//                                                     _nameController.text.trim(),
//                                                 file: _image!,
//                                               );

//                                               Navigator.of(context)
//                                                   .pushReplacement(
//                                                       MaterialPageRoute(
//                                                           builder: (_) =>
//                                                               LoginScreen()));
//                                             },
//                                             child: Center(
//                                               child: Text(
//                                                 'SIGNUP',
//                                                 style: TextStyle(
//                                                     color: Colors.white,
//                                                     fontWeight:
//                                                         FontWeight.bold),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         height: 20.0,
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             )),
//       ),
//     );
//   }
// }

// class OvalPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.white
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 1;

//     canvas.drawOval(Rect.fromLTWH(0, 0, size.width, size.height), paint);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => false;
// }

// class OvalPainter2 extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.white
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 1;

//     canvas.drawOval(Rect.fromLTWH(0, 0, size.width, size.height), paint);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => false;
// }
