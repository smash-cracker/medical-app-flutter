import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medical/auth/user_check.dart';
import 'package:medical/screens/login.dart';
import 'package:wiredash/wiredash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Wiredash(
      secret: 'RjKaEx8hRbFBbXr-M7Jz5CUg2KYs2sOA',
      projectId: 'medical-5b2ykyx',
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Medical',
        theme: ThemeData(
          textTheme: TextTheme(
            bodyText1: GoogleFonts.notoSansDisplay(),
            bodyText2: GoogleFonts.notoSansDisplay(),
          ),
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: Color(0xFF6b6bbf),
          ),
        ),
        home: HomePageBasic(),
      ),
    );
  }
}

class HomePageBasic extends StatefulWidget {
  const HomePageBasic({super.key});

  @override
  State<HomePageBasic> createState() => _HomePageBasicState();
}

class _HomePageBasicState extends State<HomePageBasic> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: UserCheck(),
    );
  }
}
