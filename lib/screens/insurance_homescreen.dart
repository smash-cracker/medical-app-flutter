// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api, prefer_interpolation_to_compose_strings, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medical/auth/auth_methods.dart';
import 'package:medical/utils/insurance_box.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class InsuranceHomescreen extends StatefulWidget {
  @override
  _InsuranceHomescreenState createState() => _InsuranceHomescreenState();
}

class _InsuranceHomescreenState extends State<InsuranceHomescreen> {
  final _insuranceNameController = TextEditingController();
  final _insuranceAmountController = TextEditingController();
  final _insuranceDescriptionController = TextEditingController();

  double _currentValue = 100000;
  late String _selectedTopic;
  late String _filtertopic;
  List<TextEditingController> _controllers = [];

  @override
  void dispose() {
    _controllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void _addRow() {
    setState(() {
      _controllers.add(TextEditingController());
    });
  }

  void _deleteRow(int index) {
    setState(() {
      _controllers.removeAt(index);
    });
  }

  List<String> amounts = [
    '100000',
    '200000',
    '500000',
  ];
  List<String> insuranceTypes = [
    'Single',
    'Parents',
    'Children',
    'Family',
  ];
  List<IconData> insuranceIcons = [
    FontAwesomeIcons.person,
    Icons.people,
    Icons.child_care,
    Icons.family_restroom
  ];

  @override
  void initState() {
    super.initState();
    _selectedTopic = insuranceTypes[0];
    _filtertopic = insuranceTypes[0];
    _controllers.add(TextEditingController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello',
                      style: TextStyle(fontSize: 30),
                    ),
                    Text(
                      'Insurance Providers 👋',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text('Welcome to insurance dashboard!'),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: insuranceTypes.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedTopic = insuranceTypes[index];
                                  _filtertopic = insuranceTypes[index];
                                });
                              },
                              child: Chip(
                                backgroundColor:
                                    _selectedTopic == insuranceTypes[index]
                                        ? Color(0xFFc6b5f2)
                                        : Colors.grey[200],
                                label: Row(children: [
                                  Icon(insuranceIcons[index]),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    insuranceTypes[index],
                                  ),
                                ]),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Color(0xFFc6b5f2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Choose range'),
                            Text(_currentValue.toString().split('.')[0]),
                          ],
                        ),
                      ),
                      Slider(
                        value: _currentValue,
                        min: 100000,
                        max: 1000000,
                        divisions: 9,
                        label: _currentValue.toString(),
                        onChanged: (double value) {
                          setState(() {
                            _currentValue = value;
                          });
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            for (var i = 1; i <= 9; i++)
                              Text(
                                (i).toString() + "L",
                                style: TextStyle(fontSize: 12),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('insurances')
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      final documents = snapshot.data!.docs;

                      return ListView.builder(
                          itemCount: documents.length,
                          itemBuilder: (BuildContext context, int index) {
                            final document = documents[index];
                            final data = document.data();
                            Map<String, dynamic> snap =
                                document.data() as Map<String, dynamic>;

                            if (data != null) {
                              print(_currentValue.runtimeType);
                              print('<');
                              print(snap['amount'].runtimeType);
                              if (_currentValue >= snap['amount']) {
                                print('true');
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Container(
                                    height: 210,
                                    child: InsuranceBox(
                                      edit: true,
                                      amount: snap['amount'],
                                    ),
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            }
                          });
                    }),
              ),
              // Expanded(
              //   child: ListView.builder(
              //       itemCount: 3,
              //       itemBuilder: (BuildContext context, int index) {
              //         print(_currentValue);
              //         print('<');
              //         print(amounts[index]);
              //         if (_currentValue >= int.parse(amounts[index])) {
              //           print('true');
              //           return Padding(
              //             padding: const EdgeInsets.symmetric(vertical: 8.0),
              //             child: Container(
              //               height: 210,
              //               child: InsuranceBox(
              //                 edit: true,
              //                 amount: amounts[index],
              //               ),
              //             ),
              //           );
              //         } else {
              //           return Container();
              //         }
              //       }),
              // ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 138, 119, 187),
        onPressed: () {
          _showAddInsuranceModal();
        },
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }

  void _showAddInsuranceModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 16,
            left: 16,
            right: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "Add Insurance",
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _insuranceNameController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: "Insurance Name",
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _insuranceAmountController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: "Insurance Amount",
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _insuranceDescriptionController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: "Insurance Description",
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16.0),
              // Expanded(
              //     child: ListView.builder(
              //         itemCount: _controllers.length,
              //         itemBuilder: (BuildContext context, int index) {
              //           return Row(
              //             children: [
              //               Expanded(
              //                 child: Padding(
              //                   padding: EdgeInsets.all(8),
              //                   child: TextField(
              //                     controller: _controllers[index],
              //                   ),
              //                 ),
              //               ),
              //               IconButton(
              //                 onPressed: _addRow,
              //                 icon: Icon(Icons.add),
              //               ),
              //               IconButton(
              //                 onPressed: () {
              //                   _deleteRow(index);
              //                 },
              //                 icon: Icon(Icons.delete),
              //               ),
              //             ],
              //           );
              //         })),
              ElevatedButton(
                onPressed: () async {
                  String insuranceName = _insuranceNameController.text;
                  int insuranceAmount =
                      int.tryParse(_insuranceAmountController.text) ?? 0;
                  final String result = await AuthMethods().addInsurance(
                      name: insuranceName,
                      amount: insuranceAmount,
                      desc: _insuranceDescriptionController.text);
                  Navigator.pop(context);
                  if (result == 'success') {
                    showTopSnackBar(
                      Overlay.of(context),
                      const CustomSnackBar.success(
                        message: 'Insurnce plan successfully added',
                      ),
                      dismissType: DismissType.onSwipe,
                      dismissDirection: [DismissDirection.startToEnd],
                    );
                    _insuranceAmountController.clear();
                    _insuranceAmountController.clear();
                  }
                },
                child: Text("Add Insurance"),
              ),
            ],
          ),
        );
      },
    );
  }

  Container buildButton(BuildContext context, String text) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            spreadRadius: 6,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
