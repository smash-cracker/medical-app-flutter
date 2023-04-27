// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical/auth/auth_methods.dart';
import 'package:medical/screens/insurance_details.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class InsuranceBox extends StatefulWidget {
  InsuranceBox(
      {super.key, required this.amount, this.edit, required this.snap});
  final int amount;
  bool? edit = false;
  Map<String, dynamic> snap;

  @override
  State<InsuranceBox> createState() => _InsuranceBoxState();
}

class _InsuranceBoxState extends State<InsuranceBox> {
  final _insuranceNameController = TextEditingController();

  final _insuranceAmountController = TextEditingController();

  final _insuranceDescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFFc6b5f2),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Stack(
          children: [
            if (widget.edit == true)
              Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      _showAddInsuranceModal();
                    },
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 232, 225, 250),
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(30),
                            bottomLeft: Radius.circular(10)),
                      ),
                      child: Row(
                        children: [
                          Icon(CupertinoIcons.pen),
                          Text('Edit'),
                        ],
                      ),
                    ),
                  )),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.snap['name'],
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
                    '₹ ${(widget.amount / 100000)} Lakhs',
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
                          // child: Row(
                          //   children: [
                          //     Chip(
                          //       label: Text('No room limit'),
                          //     ),
                          //     SizedBox(
                          //       width: 10,
                          //     ),
                          //     Chip(
                          //       label: Text('Hospital cash'),
                          //     ),
                          //   ],
                          // ),
                          ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => InsuranceDetails(
                                    insurance: widget.edit!, // kitti
                                    dSnap: widget.snap,
                                  )));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color.fromARGB(255, 138, 119, 187),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Icon(CupertinoIcons.arrow_right),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Edit Insurance",
                    style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () async {
                      final String result = await AuthMethods().deleteInsurance(
                        docID: widget.snap['insuranceID'],
                      );
                      Navigator.pop(context);
                      if (result == 'success') {
                        showTopSnackBar(
                          Overlay.of(context),
                          const CustomSnackBar.error(
                            message: 'Insurnce plan successfully deleted',
                          ),
                          dismissType: DismissType.onSwipe,
                          dismissDirection: [DismissDirection.startToEnd],
                        );
                        _insuranceNameController.clear();
                        _insuranceAmountController.clear();
                        _insuranceDescriptionController.clear();
                      }
                    },
                    icon: Icon(
                      Icons.delete,
                      // color: Colors.black,
                    ),
                  ),
                ],
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
                keyboardType: TextInputType.text,
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
                  final String result = await AuthMethods().updateInsurance(
                    name: insuranceName,
                    amount: insuranceAmount,
                    desc: _insuranceDescriptionController.text,
                    docID: widget.snap['insuranceID'],
                  );
                  Navigator.pop(context);
                  if (result == 'success') {
                    showTopSnackBar(
                      Overlay.of(context),
                      const CustomSnackBar.success(
                        message: 'Insurnce plan successfully edited',
                      ),
                      dismissType: DismissType.onSwipe,
                      dismissDirection: [DismissDirection.startToEnd],
                    );
                    _insuranceNameController.clear();
                    _insuranceAmountController.clear();
                    _insuranceDescriptionController.clear();
                  }
                },
                child: Text("Update Insurance"),
              ),
            ],
          ),
        );
      },
    );
  }
}
