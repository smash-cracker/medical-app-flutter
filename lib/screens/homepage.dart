import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:medical/screens/doctor_homescreen.dart';
import 'package:medical/screens/user_honescreen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser!;
    CollectionReference users = _firestore.collection('users');
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
          future: users.doc(user.uid).get(),
          builder: (((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: LoadingAnimationWidget.waveDots(
                    color: Colors.black, size: 40),
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> snap =
                  snapshot.data!.data() as Map<String, dynamic>;
              if (snap['type'] == 'Doctor') {
                print('2 huh');
                return DoctorHomeScreen(
                  snap: snap,
                );
              } else {
                print('no huh');
                return UserHomeScreen(
                  snap: snap,
                );
              }
            }
            return Container();
          }))),
    );
  }
}
