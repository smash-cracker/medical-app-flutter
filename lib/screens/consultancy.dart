// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical/utils/doctor_list.dart';

class Consultancy extends StatefulWidget {
  Consultancy({super.key});

  @override
  State<Consultancy> createState() => _ConsultancyState();
}

class _ConsultancyState extends State<Consultancy> {
  bool searchBox = false;
  String searchText = '';

  String selectedOption = 'All';

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filter Options'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                _buildOption('All'),
                _buildOption('Completed'),
                _buildOption('Today'),
                _buildOption('Upcoming'),
              ],
            ),
          ),
        );
      },
    ).then((value) {
      if (value != null) {
        selectedOption = value;
        // Do something with the selected option, such as filter the list
      }
    });
  }

  Widget _buildOption(String option) {
    return ListTile(
      title: Text(option),
      onTap: () {
        Navigator.of(context)
            .pop(option); // Close the dialog and return the selected option
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFFe5e5fe),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            CupertinoIcons.back,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Consultation',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Choose a doctor',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              height: MediaQuery.of(context).size.height * 0.2,
              decoration: BoxDecoration(
                color: Color(0xFFe5e5fe),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18.0,
                  vertical: 8.0,
                ),
                child: searchBox
                    ? searchBar('Search doctors')
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // GestureDetector(
                          //   onTap: () {
                          //     // _showFilterDialog();
                          //   },
                          //   child: Chip(
                          //     label: Row(
                          //       children: [
                          //         Text(''),
                          //         SizedBox(
                          //           width: 10,
                          //         ),
                          //         Icon(
                          //           CupertinoIcons.arrowtriangle_down_square,
                          //           size: 16,
                          //         )
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                searchBox = true;
                              });
                            },
                            child: Icon(
                              CupertinoIcons.search,
                            ),
                          ),
                        ],
                      )),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18.0,
                vertical: 8.0,
              ),
              child: DoctorList(
                searchText: searchText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget searchBar(String placehold) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
      child: CupertinoSearchTextField(
        onChanged: (value) {
          setState(() {
            searchText = value;
          });
        },
        borderRadius: BorderRadius.circular(10.0),
        placeholder: placehold,
      ),
    );
  }
}
