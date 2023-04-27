// ignore_for_file: prefer_const_constructors, unnecessary_new, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medical/auth/auth_methods.dart';
import 'package:medical/screens/homepage.dart';
import 'package:medical/screens/login%20copy.dart';
import 'package:medical/screens/signup.dart';
import 'package:medical/utils/box.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  bool isFading = true;
  bool _isLoading = false;

  void login() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods()
        .loginUser(email: email.text, password: password.text);
    if (res == 'success') {
      final user = FirebaseAuth.instance.currentUser!;
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => HomePage()));
    } else {}
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFcecff3),
            Color(0xFF7272c4),
          ],
        ),
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Transform.translate(
                      offset: Offset(-10, -20),
                      child: CustomPaint(
                        painter: OvalPainter(),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height - 200,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 100,
                      top: 100,
                      child: CustomPaint(
                        painter: OvalPainter2(),
                        child: Container(
                          width: 100,
                          height: 150,
                        ),
                      ),
                    ),
                    Positioned(
                      right: -40,
                      top: -50,
                      child: CustomPaint(
                        painter: OvalPainter2(),
                        child: Container(
                          width: 300,
                          height: 450,
                        ),
                      ),
                    ),
                    Positioned(
                      right: -40,
                      top: 200,
                      child: CustomPaint(
                        painter: OvalPainter2(),
                        child: Container(
                          width: 300,
                          height: 450,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 100,
                      top: 200,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      SignupScreen(),
                              transitionDuration: Duration(seconds: 0),
                            ),
                          );
                        },
                        child: LoginSignupBox(
                          color: 0xFFd7d5fc,
                          one: 'Sign',
                          two: 'Up',
                        ),
                      ),
                    ),
                    Positioned(
                      left: 200,
                      top: 400,
                      child: LoginSignupBox(
                        color: 0xFFf9dac6,
                        one: 'Log',
                        two: 'In',
                      ),
                    ),
                    Positioned(
                      left: 50,
                      top: 300,
                      child: FaIcon(
                        FontAwesomeIcons.snowflake,
                        color: Color(0xFFd7d5fc),
                        size: 60,
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                    color: Color(0xFFfaf8f4),
                  ),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18.0, vertical: 5),
                      child: AnimatedCrossFade(
                        duration: Duration(seconds: 1),
                        firstChild: Row(children: [
                          Icon(CupertinoIcons.mail),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'email address',
                              ),
                              controller: email,
                            ),
                          ),
                        ]),
                        secondChild: Row(children: [
                          FaIcon(
                            FontAwesomeIcons.lock,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'password',
                              ),
                              controller: password,
                              obscureText: true,
                            ),
                          ),
                        ]),
                        crossFadeState: isFading
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                      )),
                ),
                GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   PageRouteBuilder(
                    //     pageBuilder: (context, animation, secondaryAnimation) =>
                    //         PasswordScreen(),
                    //     transitionDuration: Duration(seconds: 0),
                    //   ),
                    // );
                    setState(() {
                      isFading = !isFading;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.white,
                    ),
                    child: isFading
                        ? FaIcon(
                            FontAwesomeIcons.anglesRight,
                            color: Color(0xFFd7d5fc),
                            size: 30,
                          )
                        : _isLoading
                            ? Center(
                                child: CircleAvatar(
                                  radius: 10,
                                  backgroundColor: Colors.white,
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : _isLoading
                                ? CircularProgressIndicator()
                                : GestureDetector(
                                    onTap: login,
                                    child: FaIcon(
                                      FontAwesomeIcons.check,
                                      color: Color(0xFFd7d5fc),
                                      size: 30,
                                    ),
                                  ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OvalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawOval(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class OvalPainter2 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawOval(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
