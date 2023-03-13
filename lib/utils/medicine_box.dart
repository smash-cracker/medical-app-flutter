// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MedicineBox extends StatefulWidget {
  const MedicineBox({Key? key}) : super(key: key);

  @override
  _MedicineBoxState createState() => _MedicineBoxState();
}

class _MedicineBoxState extends State<MedicineBox> {
  String? _selectedValue;
  // List<List<String>> _rows = [
  //   ['', 'Select'],
  //   ['', 'Select'],
  // ];
  // void _addRow() {
  //   setState(() {
  //     _rows.add(['', 'Select']);
  //     print('+++++++++++');
  //     print(_rows);
  //     print('+++++++++++');
  //   });
  // }

  @override
  void initState() {
    super.initState();
    // print(_rows);
  }

  // void _updateRow(int index, List<String> values) {
  //   setState(() {
  //     _rows[index] = values;
  //   });
  // }

  // void _removeRow(int index) {
  //   setState(() {
  //     _rows.removeAt(index);
  //     print('-----------------');
  //     print(_rows);

  //     print('-----------------');
  //   });
  // }

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

  Widget _buildDialog() {
    final double maxHeight = MediaQuery.of(context).size.height * 0.5;

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        List<String> filteredList = _selectedValue != null
            ? _medicines.where((String value) {
                return value
                    .toLowerCase()
                    .contains(_selectedValue!.toLowerCase());
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
                        _selectedValue = value;
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
                            _selectedValue = filteredList[index];
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              MedicineName(
                FontAwesomeIcons.pills,
                'Medicine',
                _selectedValue ?? 'Select',
                Colors.blue[900]!,
              ),
              SizedBox(
                width: 10,
              ),
              MedicineName(
                FontAwesomeIcons.clock,
                'Time',
                'Select',
                Colors.redAccent[700]!,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          // for (int i = 1; i < 3; i++)
          //   Row(
          //     children: [
          //       Expanded(
          //         child: MedicineName(
          //           FontAwesomeIcons.pills,
          //           'Medicine',
          //           _rows[i][0],
          //           Colors.blue[900]!,
          //         ),
          //       ),
          //       SizedBox(
          //         width: 10,
          //       ),
          //       Expanded(
          //         child: MedicineName(
          //           FontAwesomeIcons.clock,
          //           'Time',
          //           _rows[i][1],
          //           Colors.redAccent[700]!,
          //         ),
          //       ),
          //       IconButton(
          //         onPressed: () => _removeRow(i),
          //         icon: Icon(Icons.delete),
          //       ),
          //     ],
          //   ),
          // FloatingActionButton(
          //   onPressed: _addRow,
          //   child: Icon(Icons.add),
          // ),
        ],
      ),
    );
  }
}
