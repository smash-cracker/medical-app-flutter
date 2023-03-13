// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InsuranceBox extends StatelessWidget {
  const InsuranceBox({super.key, required this.amount});
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFFc6b5f2),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Neuro Ultimate',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Preimum',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text('Cover amount'),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '₹ ${((int.parse(amount)) / 100000)} Lakhs',
                style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 138, 119, 187),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Row(
                      children: [
                        Chip(
                          label: Text('No room limit'),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Chip(
                          label: Text('Hospital cash'),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromARGB(255, 138, 119, 187),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Icon(CupertinoIcons.arrow_right),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
