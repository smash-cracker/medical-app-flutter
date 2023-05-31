// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medical/utils/medicine_box.dart';
import 'package:uuid/uuid.dart';

class FirebaseApi {
  static UploadTask? uploadFile(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putFile(file);
    } on FirebaseException catch (e) {
      print(e);
    }
  }
}

class MedicinePrescription {
  String medicineName;

  String time;

  MedicinePrescription(this.medicineName, this.time);

  Map<String, dynamic> toJson() {
    return {
      'medicineName': this.medicineName,
      'time': this.time,
    };
  }
}

class AddPrescription extends StatefulWidget {
  const AddPrescription({super.key, required this.patientID});
  final String patientID;

  @override
  State<AddPrescription> createState() => _AddPrescriptionState();
}

class _AddPrescriptionState extends State<AddPrescription> {
  PlatformFile? pickedFile;
  UploadTask? task;
  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.first;

    setState(() {
      pickedFile = path;
      subImagesArray.add(
        pickedFile!.path!,
      );
    });
  }

  TextEditingController _desc = TextEditingController();
  //upload

  Future uploadPrescription() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser!;
    final fileMain = File(pickedFile!.path!);
    String postId = const Uuid().v1();
    final destination = 'prescriptions/$postId';

    task = FirebaseApi.uploadFile(destination, fileMain);
    setState(() {});

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    try {
      _firestore.collection('prescriptions').doc(postId).set({
        'prescriptionID': postId,
        'doctorID': user.uid,
        'time': DateTime.now(),
        'description': _desc.text,
        'patientID': widget.patientID,
        'subPics': [],
      });
    } catch (e) {
      print(e.toString());
    }

    try {
      _firestore.collection('users').doc(widget.patientID).update({
        'prescriptions': FieldValue.arrayUnion([postId])
      });
    } catch (e) {
      print(e.toString());
    }

    try {
      int count = 0;
      for (var x in subImagesArray) {
        final destination = 'prescriptions/${postId}/${count}';
        var file = File(x);
        task = FirebaseApi.uploadFile(destination, file);
        setState(() {});

        final snapshot = await task!.whenComplete(() {});
        final urlDownload = await snapshot.ref.getDownloadURL();
        try {
          _firestore.collection('prescriptions').doc(postId).update({
            'subPics': FieldValue.arrayUnion([urlDownload])
          });
        } catch (e) {
          print(e.toString());
        }
        count += 1;
      }
    } catch (e) {
      print(e.toString());
    }

    try {
      FirebaseFirestore.instance
          .collection('prescriptions')
          .doc(postId)
          .update({
            'medicines': FieldValue.arrayUnion(
                medicinePrescriptions.map((m) => m.toJson()).toList())
          })
          .then((value) => print("Medicines added to document"))
          .catchError((error) => print("Failed to add medicines: $error"));
    } catch (e) {
      print(e.toString());
    }
  }
  //xxxxxxxxxxxx

  String? _selectedMedicine;
  List<String> subImagesArray = [];

  String? _selectedTime;
  List<MedicinePrescription> medicinePrescriptions = [];
  void _addMedicine() {
    if (_selectedMedicine != null && _selectedTime != null) {
      final medicinePrescription =
          MedicinePrescription(_selectedMedicine!, _selectedTime!);
      final medicine = MedicinePrescription(
          medicinePrescription.medicineName, medicinePrescription.time);
      setState(() {
        medicinePrescriptions.add(medicine);
        _selectedMedicine = null;
        _selectedTime = null;
      });
    }
  }

  List<String> _medicines = [
    'Paracetamol',
    'Aspirin',
    'Ibuprofen',
    'Acetaminophen',
    'Naproxen',
    'Diclofenac',
    'Meloxicam',
    'Celecoxib',
    'Indomethacin',
    'Ketorolac',
    'Tramadol',
    'Oxycodone',
    'Hydrocodone',
    'Codeine',
    'Morphine',
  ];

  List<String> _times = [
    '1 x Day',
    '1 x Day Before Food',
    '2 x Day',
    '2 x Day Before Food',
    '3 x Day',
    '3 x Day Before Food',
  ];
  String selectedValue = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      CupertinoIcons.back,
                    ),
                    Column(
                      children: [
                        // Text('Dr. Harry'),
                        // Text('09-12-2350'),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: FaIcon(
                        FontAwesomeIcons.xmark,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Medicinces',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: medicinePrescriptions.length + 1,
                  itemBuilder: (context, snapshot) {
                    if (snapshot == medicinePrescriptions.length) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                MedicineName(
                                  FontAwesomeIcons.pills,
                                  'Medicine',
                                  'select',
                                  Colors.blue[900]!,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                time(
                                  FontAwesomeIcons.clock,
                                  'Time',
                                  'select',
                                  Colors.redAccent[700]!,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                MedicineName(
                                  FontAwesomeIcons.pills,
                                  'Medicine',
                                  medicinePrescriptions[snapshot].medicineName,
                                  Colors.blue[900]!,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                time(
                                  FontAwesomeIcons.clock,
                                  'Time',
                                  medicinePrescriptions[snapshot].time,
                                  Colors.redAccent[700]!,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      );
                    }
                  }),
              SizedBox(
                height: 10,
              ),
              Text(
                'Prescription',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: TextField(
                  controller: _desc,
                  maxLines: 10,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Images',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: subImagesArray.length + 1,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisExtent: 180,
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 1,
                ),
                itemBuilder: ((context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: index == subImagesArray.length
                          ? GestureDetector(
                              onTap: selectFile,
                              child: Container(
                                  color: Color.fromARGB(255, 181, 153, 187),
                                  width: 30,
                                  height: 30,
                                  child: Icon(Icons.add_a_photo)),
                            )
                          : Image.file(
                              fit: BoxFit.cover,
                              File(
                                subImagesArray[index],
                              ),
                            ),
                    ),
                  );
                }),
              ),
              ElevatedButton(
                  onPressed: () {
                    uploadPrescription();
                  },
                  child: Text('Upload Prescription'))
            ],
          ),
        ),
      ),
    );
  }

  Widget MedicineName(
    IconData icon,
    String one,
    String two,
    Color color,
  ) {
    return Flexible(
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (_) => _buildDialog(),
          );
        },
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[350],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              FaIcon(
                icon,
                color: color,
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(one),
                  Text(two),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget time(
    IconData icon,
    String one,
    String two,
    Color color,
  ) {
    return Flexible(
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (_) => _buildDialogtime(),
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.grey[350],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              FaIcon(
                icon,
                color: color,
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(one),
                  Text(
                    two,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDialog() {
    final double maxHeight = MediaQuery.of(context).size.height * 0.5;

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        List<String> filteredList = _selectedMedicine != null
            ? _medicines.where((String value) {
                return value
                    .toLowerCase()
                    .contains(_selectedMedicine!.toLowerCase());
              }).toList()
            : _medicines;

        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Container(
            constraints: BoxConstraints(maxHeight: maxHeight),
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 60,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search medicine',
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _selectedMedicine = value;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(filteredList[index]),
                        onTap: () {
                          setState(() {
                            _selectedMedicine = filteredList[index];
                            _addMedicine();
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDialogtime() {
    final double maxHeight = MediaQuery.of(context).size.height * 0.5;

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        List<String> filteredList = _selectedTime != null
            ? _times.where((String value) {
                return value
                    .toLowerCase()
                    .contains(_selectedTime!.toLowerCase());
              }).toList()
            : _times;

        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Container(
            constraints: BoxConstraints(maxHeight: maxHeight),
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 60,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search time',
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _selectedTime = value;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(filteredList[index]),
                        onTap: () {
                          setState(() {
                            _selectedTime = filteredList[index];
                            _addMedicine();
                            print(medicinePrescriptions);
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
