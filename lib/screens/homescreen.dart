// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    CollectionReference users = _firestore.collection('users');
    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(user.uid).get(),
        builder: (((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Text(''),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> snap =
                snapshot.data!.data() as Map<String, dynamic>;
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.white,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Icon(
                    CupertinoIcons.person_crop_circle,
                    color: Colors.black,
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: Icon(
                      CupertinoIcons.list_bullet_indent,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              body: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 35.0, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello',
                            style: TextStyle(fontSize: 30),
                          ),
                          Text(
                            '${snap["name"]} 👋',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                        color: Color(0xFFfaf8f4),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Row(children: [
                          Icon(CupertinoIcons.search),
                          SizedBox(
                            width: 20,
                          ),
                          Text('search for a doctor'),
                        ]),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                              color: Color(0xFFffddc2),
                            ),
                            height: MediaQuery.of(context).size.height * 0.23,
                            width: MediaQuery.of(context).size.width * 0.38,
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: Color(
                                        0xFFffcea8,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child:
                                            FaIcon(FontAwesomeIcons.comments),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 60,
                                  ),
                                  Text(
                                    'consultation',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text('55 doctors'),
                                ],
                              ),
                            ),
                          ),
                          //

                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                              color: Color(0xFFe5e5fe),
                            ),
                            height: MediaQuery.of(context).size.height * 0.23,
                            width: MediaQuery.of(context).size.width * 0.38,
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 40,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color: Color(
                                            0xFFd7d5fc,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child:
                                                FaIcon(FontAwesomeIcons.pills),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 60,
                                      ),
                                      Text(
                                        'Pharmacy',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text('6 pharmacies'),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  top: 10,
                                  right: 10,
                                  child: FaIcon(
                                    FontAwesomeIcons.snowflake,
                                    color: Color(0xFFd7d5fc),
                                    size: 40,
                                  ),
                                )
                              ],
                            ),
                          ),

                          //
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'My Health',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                    ),

                    //
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                            color: Color(0xFFfaf8f4),
                          ),
                          height: MediaQuery.of(context).size.height * 0.15,
                          width: MediaQuery.of(context).size.width * 0.38,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(CupertinoIcons.heart),
                                  Text('Heart Rate'),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '78 /',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text('Heart Rate'),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                            color: Color(0xFFfaf8f4),
                          ),
                          height: MediaQuery.of(context).size.height * 0.15,
                          width: MediaQuery.of(context).size.width * 0.38,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(CupertinoIcons.zzz),
                                  Text('Sleep'),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '8 /',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text('hrs'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              bottomNavigationBar: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 35.0, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Container(
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(10),
                    //     color: Color(0xFF6b6bbf),
                    //   ),
                    //   child: Row(
                    //     children: [

                    //       Text('chat'),
                    //     ],
                    //   ),
                    // ),
                    Container(
                      width: 130,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Color(0xFF6b6bbf),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            right: 18.0, left: 8, top: 8, bottom: 8),
                        child: Row(
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Color(
                                  0xFF8888cb,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Icon(
                                    CupertinoIcons.chat_bubble,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Chat',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),

                    //

                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF6b6bbf),
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        margin: EdgeInsets.all(5),
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color(0xFFfca968),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Icon(
                          Icons.menu,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    //

                    Container(
                      width: 130,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Color(0xFF6b6bbf),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            right: 8.0, left: 18, top: 8, bottom: 8),
                        child: Row(
                          children: [
                            Text(
                              'Profile',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Color(
                                  0xFF8888cb,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Icon(
                                    CupertinoIcons.person_crop_circle,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return Container();
        })));
  }
}
