import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medical/screens/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: TextTheme(
          bodyText1: GoogleFonts.notoSansDisplay(),
          bodyText2: GoogleFonts.notoSansDisplay(),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Color(0xFF6b6bbf),
        ),
      ),
      home: LoginScreen(),
    );
  }
}
