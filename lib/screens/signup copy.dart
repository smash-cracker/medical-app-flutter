// // ignore_for_file: prefer_const_constructors, unnecessary_new, prefer_const_literals_to_create_immutables

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:medical/screens/login.dart';
// import 'package:medical/utils/box.dart';
// import 'package:medical/utils/inputbox.dart';

// class SignupScreen extends StatefulWidget {
//   const SignupScreen({super.key});

//   @override
//   State<SignupScreen> createState() => _SignupScreenState();
// }

// class _SignupScreenState extends State<SignupScreen>
//     with SingleTickerProviderStateMixin {
//   int currentStep = 1;
//   late AnimationController _controller;
//   late Animation<double> _opacityAnimation;
//   late Animation<Offset> _positionAnimation;
//   bool isFading = true;
//   List<TextEditingController> controllers =
//       List.generate(5, (index) => TextEditingController());
//   ValueNotifier<int> selectedWidgetIndex = ValueNotifier<int>(0);
//   String selectedRadioButton = 'User';

//   List<String> names = ["name", "email", "password", "confirm password", "u/d"];
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 500),
//       vsync: this,
//     );
//     _opacityAnimation =
//         Tween<double>(begin: 1.0, end: 0.0).animate(_controller);
//     _positionAnimation = Tween<Offset>(
//       begin: const Offset(0, 0),
//       end: const Offset(-1, 0),
//     ).animate(_controller);
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _onNextPressed() {
//     if (currentStep < 4) {
//       setState(() {
//         print(currentStep);
//         currentStep++;
//       });
//     } else {
//       for (int i = 0; i < controllers.length; i++) {
//         print(controllers[i].text);
//         setState(() {
//           isFading = false;
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
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
//           backgroundColor: Colors.transparent,
//           body: SingleChildScrollView(
//             child: Column(
//               children: [
//                 Stack(
//                   children: [
//                     Transform.translate(
//                       offset: Offset(-10, -20),
//                       child: CustomPaint(
//                         painter: OvalPainter(),
//                         child: Container(
//                           width: MediaQuery.of(context).size.width,
//                           height: MediaQuery.of(context).size.height - 200,
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       left: 100,
//                       top: 100,
//                       child: CustomPaint(
//                         painter: OvalPainter2(),
//                         child: Container(
//                           width: 100,
//                           height: 150,
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       right: -40,
//                       top: -50,
//                       child: CustomPaint(
//                         painter: OvalPainter2(),
//                         child: Container(
//                           width: 300,
//                           height: 450,
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       right: -40,
//                       top: 200,
//                       child: CustomPaint(
//                         painter: OvalPainter2(),
//                         child: Container(
//                           width: 300,
//                           height: 450,
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       left: 100,
//                       top: 200,
//                       child: GestureDetector(
//                         onTap: () {
//                           Navigator.pushReplacement(
//                             context,
//                             PageRouteBuilder(
//                               pageBuilder:
//                                   (context, animation, secondaryAnimation) =>
//                                       LoginScreen(),
//                               transitionDuration: Duration(seconds: 0),
//                             ),
//                           );
//                         },
//                         child: LoginSignupBox(
//                           color: 0xFFd7d5fc,
//                           one: 'Log',
//                           two: 'In',
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       left: 200,
//                       top: 400,
//                       child: LoginSignupBox(
//                         color: 0xFFf9dac6,
//                         one: 'Sign',
//                         two: 'Up',
//                       ),
//                     ),
//                     Positioned(
//                       left: 50,
//                       top: 300,
//                       child: FaIcon(
//                         FontAwesomeIcons.snowflake,
//                         color: Color(0xFFd7d5fc),
//                         size: 60,
//                       ),
//                     ),
//                   ],
//                 ),
//                 //

//                 Stack(
//                   children: [
//                     Container(
//                       width: 200,
//                       height: 50,
//                       margin: EdgeInsets.symmetric(horizontal: 20),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(20),
//                         ),
//                         color: Color(0xFFfaf8f4),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Row(children: [
//                           Icon(Icons.person),
//                           SizedBox(
//                             width: 20,
//                           ),
//                           Expanded(
//                             child: Container(
//                               width: 200,
//                               height: 50,
//                               child: TextField(
//                                 autofocus: true,
//                                 decoration: InputDecoration(
//                                     border: InputBorder.none,
//                                     hintText: 'Name',
//                                     hintStyle: TextStyle(color: Colors.black)),
//                                 controller: controllers[0],
//                               ),
//                             ),
//                           ),
//                         ]),
//                       ),
//                     ),
//                     Container(
//                       height: 50,
//                       width: 300,
//                       child: Opacity(
//                         opacity: selectedWidgetIndex.value == 1 ? 1.0 : 0.0,
//                         child: InputBox(
//                           controller: controllers[1],
//                           text: 'password',
//                           iconData: Icons.password,
//                         ),
//                       ),
//                     ),
//                     Container(
//                       height: 50,
//                       width: 300,
//                       child: Opacity(
//                         opacity: selectedWidgetIndex.value == 2 ? 1.0 : 0.0,
//                         child: InputBox(
//                           controller: controllers[2],
//                           text: 'confirm password',
//                           iconData: Icons.password,
//                         ),
//                       ),
//                     ),
//                     Container(
//                       height: 50,
//                       width: 300,
//                       child: Row(
//                         children: [
//                           Flexible(
//                             child: RadioListTile(
//                                 value: 'User',
//                                 title: Text(
//                                   'User',
//                                   style: TextStyle(color: Colors.white),
//                                 ),
//                                 activeColor: Color(0xFFC31DC7),
//                                 groupValue: selectedRadioButton,
//                                 selectedTileColor: Color(0xFFC31DC7),
//                                 onChanged: (value) {
//                                   setState(() {
//                                     selectedRadioButton = 'User';
//                                   });
//                                 }),
//                           ),
//                           Flexible(
//                             child: RadioListTile(
//                                 value: 'Doctor',
//                                 title: Text(
//                                   'Doctor',
//                                   style: TextStyle(color: Colors.white),
//                                 ),
//                                 activeColor: Color(0xFFC31DC7),
//                                 groupValue: selectedRadioButton,
//                                 onChanged: (value) {
//                                   setState(() {
//                                     selectedRadioButton = 'Doctor';
//                                   });
//                                 }),
//                           )
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),

//                 //
//                 Container(
//                     padding: EdgeInsets.all(10),
//                     margin: EdgeInsets.only(top: 20),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(100),
//                       color: Colors.white,
//                     ),
//                     child: selectedWidgetIndex.value == 3
//                         ? GestureDetector(
//                             onTap: () {
//                               print(controllers[0].text);
//                               print(controllers[1].text);
//                               print(controllers[2].text);
//                             },
//                             child: FaIcon(
//                               FontAwesomeIcons.check,
//                               color: Color(0xFFd7d5fc),
//                               size: 30,
//                             ),
//                           )
//                         : GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 selectedWidgetIndex.value += 1;
//                               });
//                             },
//                             child: FaIcon(
//                               FontAwesomeIcons.anglesRight,
//                               color: Color(0xFFd7d5fc),
//                               size: 30,
//                             ),
//                           )),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildStep(int step) {
//     return Container(
//       height: 40,
//       width: 200,
//       child: AnimatedPositioned(
//         top: 0,
//         bottom: 0,
//         left: step == currentStep ? 0 : -MediaQuery.of(context).size.width,
//         right: step == currentStep ? 0 : MediaQuery.of(context).size.width,
//         duration: const Duration(milliseconds: 500),
//         curve: Curves.easeInOut,
//         child: FadeTransition(
//           opacity: _opacityAnimation,
//           child: SlideTransition(
//             position: _positionAnimation,
//             child: Container(
//               height: 40,
//               width: 200,
//               margin: EdgeInsets.symmetric(horizontal: 20),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.all(
//                   Radius.circular(20),
//                 ),
//                 color: Color(0xFFfaf8f4),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Container(
//                   height: 40,
//                   width: 200,
//                   child: Row(
//                     children: [
//                       Expanded(child: Icon(CupertinoIcons.mail)),
//                       SizedBox(
//                         width: 20,
//                       ),
//                       Expanded(
//                         child: TextField(
//                           decoration: InputDecoration(
//                             border: InputBorder.none,
//                             hintText: names[step],
//                           ),
//                           controller: controllers[step],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
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
