// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sized_box_for_whitespace, prefer_typing_uninitialized_variables, sort_child_properties_last

import 'package:flutter/material.dart';

class DoctorBox extends StatelessWidget {
  DoctorBox({super.key, required this.dSnap});

  var dSnap;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(
            bottom: 10,
          ),
          width: 160,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                dSnap['name'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(dSnap['specialization']),
            ],
          ),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 241, 238, 237),
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            height: 200,
            width: 160,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              child: Image(
                fit: BoxFit.cover,
                image: NetworkImage(dSnap['photourl']),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
