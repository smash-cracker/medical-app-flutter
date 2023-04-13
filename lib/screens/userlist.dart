import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UserListForAnalysis extends StatefulWidget {
  // var dsnap;
  final String insuranceID;
  UserListForAnalysis({super.key, required this.insuranceID});

  @override
  State<UserListForAnalysis> createState() => _UserListForAnalysisState();
}

class _UserListForAnalysisState extends State<UserListForAnalysis> {
  List<dynamic> participantIDs = [];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  getParticipantIDs() async {
    print('us');
    final documentSnapshot =
        await _firestore.collection('insurances').doc(widget.insuranceID).get();
    for (var x in documentSnapshot.data()!['interested']) {
      if (x != null) {
        participantIDs.add(x);
        // print(x['id']);
      }
    }
    print("participantIDs");
    print(participantIDs);
    // participantIDs = widget.dsnap['certificate']['id'];
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("setting back to 0");
    participantIDs = [];
    return FutureBuilder(
      future: getParticipantIDs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              'Participants',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            leading: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
          ),
          body: SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: participantIDs.length,
                itemBuilder: (BuildContext context, int index) {
                  CollectionReference user = _firestore.collection('users');
                  return FutureBuilder<DocumentSnapshot>(
                    future: user.doc(participantIDs[index]).get(),
                    builder: (((context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        print(snapshot.data!.data());
                        Map<String, dynamic> snap =
                            snapshot.data!.data() as Map<String, dynamic>;
                        return GestureDetector(
                          onTap: () {},
                          child: Container(
                            height: 100,
                            margin: EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 228, 228, 228),
                                borderRadius: BorderRadius.circular(8)),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 4,
                                    color: Color(0xFFBCCEF8),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            CircleAvatar(
                                                backgroundColor: Color.fromARGB(
                                                    255, 224, 223, 223),
                                                child: Container(
                                                  height: 20,
                                                  width: 20,
                                                  child: SvgPicture.network(
                                                    'https://avatars.dicebear.com/api/identicon/${snap["name"]}.svg',
                                                  ),
                                                ))
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 200,
                                              child: Text(
                                                snap['name'],
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                                width: 200,
                                                child: Text(
                                                  snap['email'],
                                                  style: const TextStyle(
                                                      fontSize: 12),
                                                )),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                      return Container();
                    })),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
