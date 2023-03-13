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
          width: 180,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                dSnap['name'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('Neurologist'),
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
            width: 180,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              child: Image(
                fit: BoxFit.cover,
                image: NetworkImage(
                  // 'https://cdn.discordapp.com/attachments/1077128917623775273/1078389322711048312/Smash_Cracker_doctors_helping_patients_cute_helpful_4k_purple_0_d46c0828-40cd-40ab-9f90-dfb4fd03dfb2.png',
                  'https://i.pinimg.com/564x/ea/d5/aa/ead5aaa564a52353c36b961b11a07ddc.jpg',
                ),
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
