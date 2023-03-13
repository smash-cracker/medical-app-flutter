import 'package:cloud_firestore/cloud_firestore.dart';

class Doctor {
  final String name;
  final String email;
  final List<String> patients;
  final String uid;

  Doctor({
    required this.name,
    required this.email,
    this.patients = const [],
    required this.uid,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'patients': patients,
        'uid': uid,
      };

  static Doctor fromSnap(DocumentSnapshot documentSnapshot) {
    var snapshot = documentSnapshot.data() as Map<String, dynamic>;
    return Doctor(
      name: snapshot['name'],
      email: snapshot['email'],
      uid: snapshot['uid'],
      patients: snapshot['patients'],
    );
  }
}
