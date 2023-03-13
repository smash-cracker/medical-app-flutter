import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  final String userID;
  final String doctorID;
  final String date;
  final String bookingID;

  Booking({
    required this.userID,
    required this.doctorID,
    required this.date,
    required this.bookingID,
  });

  Map<String, dynamic> toJson() => {
        'userID': userID,
        'doctorID': doctorID,
        'date': date,
        'bookingID': bookingID,
      };

  static Booking fromSnap(DocumentSnapshot documentSnapshot) {
    var snapshot = documentSnapshot.data() as Map<String, dynamic>;
    return Booking(
      userID: snapshot['userID'],
      doctorID: snapshot['doctorID'],
      bookingID: snapshot['bookingID'],
      date: snapshot['date'],
    );
  }
}
