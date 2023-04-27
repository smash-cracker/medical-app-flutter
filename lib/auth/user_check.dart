import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medical/screens/homepage.dart';
import 'package:medical/screens/login.dart';

class UserCheck extends StatelessWidget {
  const UserCheck({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print('huh');
            return HomePage();
          } else {
            print('no huh');
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
