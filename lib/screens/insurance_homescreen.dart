// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api, prefer_interpolation_to_compose_strings, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medical/utils/insurance_box.dart';

class InsuranceHomescreen extends StatefulWidget {
  @override
  _InsuranceHomescreenState createState() => _InsuranceHomescreenState();
}

class _InsuranceHomescreenState extends State<InsuranceHomescreen> {
  double _currentValue = 100000;
  late String _selectedTopic;
  late String _filtertopic;
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
                      'Abhijith 👋',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text('Welcome to insurance! Let\'s find best policy'),
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
                child: ListView.builder(
                    itemCount: 3,
                    itemBuilder: (BuildContext context, int index) {
                      print(_currentValue);
                      print('<');
                      print(amounts[index]);
                      if (_currentValue >= int.parse(amounts[index])) {
                        print('true');
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Container(
                            height: 210,
                            child: InsuranceBox(
                              amount: amounts[index],
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
