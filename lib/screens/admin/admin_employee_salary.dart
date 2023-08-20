import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';

class AdminEmployeeSalary extends StatefulWidget {
  DocumentSnapshot employee;

  AdminEmployeeSalary({super.key, required this.employee});

  @override
  State<AdminEmployeeSalary> createState() => _AdminEmployeeSalaryState();
}

class _AdminEmployeeSalaryState extends State<AdminEmployeeSalary> {
  // Firebase Firestore
  late FirebaseFirestore db;

  TextEditingController txtIncrement = TextEditingController();
  bool validateIncrement = false;

  _init() async {
    db = FirebaseFirestore.instance;
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  // Load data into Stream Builder
  _streamSnapshot() => db
      .collection("tblEmployeeSalaryIncrements")
      .where('empid', isEqualTo: widget.employee.id)
      .snapshots();

  _incrementSalary() async {
    // Empty Field Validation
    setState(() {
      txtIncrement.text.isEmpty
          ? validateIncrement = true
          : validateIncrement = false;
    });

    double increment = double.parse(txtIncrement.text.toString());
    final oldSalary = widget.employee['salary'];
    double newSalary = (oldSalary * increment / 100) + oldSalary;

    final data = {
      'empid': widget.employee.id,
      'IncrementDate': DateFormat('dd-MM-yyy').format(DateTime.now()),
      'PreviousSalary': oldSalary,
      'NewSalary': newSalary,
    };

    bool incrementSalary = false;
    // Add a document into tblEmployeeSalaryIncrements on Cloud Firestore
    await db
        .collection('tblEmployeeSalaryIncrements')
        .add(data)
        .then((documentSnapshot) {
      // Clear Field
      setState(() {
        txtIncrement.text = '';
      });
      print("Employee Salary Increment with ID: ${documentSnapshot.id}");
      incrementSalary = true;
    }).onError((error, stackTrace) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        text: 'Not Increment Salary!',
      );
      print("Error writing document: $error");
    });

    // update document into tblEmployee on Cloud Firestore
    if (incrementSalary) {
      await db
          .collection("tblEmployee")
          .doc(widget.employee.id)
          .update({'salary': newSalary}).then((documentSnapshot) {
        Navigator.pop(context);
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'Increment Salary Successfully',
        );
        // widget.employee['salary'] = newSalary;
      }).onError((error, stackTrace) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.warning,
          text: 'Not Increment Salary on  Employee!',
        );
        print("Error writing document: $error");
      });
    }
  }

  String _defaultIncrementValue(String designation) {
    if (designation == 'Project Manager') {
      return "25";
    } else if (designation == 'Assistant Manager') {
      return "20";
    } else if (designation == 'Sr. Developer') {
      return "15";
    } else if (designation == 'Jr. Developer') {
      return "10";
    } else {
      return "0";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
          stream: _streamSnapshot(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.docs.isNotEmpty) {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    final DocumentSnapshot documentSnapshot =
                        snapshot.data!.docs[index];
                    print(documentSnapshot.data);
                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        leading:
                            Text(documentSnapshot['IncrementDate'].toString()),
                        subtitle:
                            Text(documentSnapshot['PreviousSalary'].toString()),
                        trailing:
                            Text(documentSnapshot['NewSalary'].toString()),
                      ),
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text(
                    'No Record!',
                    style: TextStyle(
                        fontSize: 30,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w300),
                  ),
                );
              }
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          txtIncrement.text =
              _defaultIncrementValue(widget.employee['designation']);
          _customQuickAlertBox();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  _customQuickAlertBox() => QuickAlert.show(
        context: context,
        type: QuickAlertType.custom,
        title: 'Increment Salary(%)',
        confirmBtnText: 'Increment',
        confirmBtnColor: Colors.blueAccent,
        cancelBtnText: 'Cancel',
        widget: Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            controller: txtIncrement,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Increment (%)',
              hintText: 'Increment (%)',
              errorText: validateIncrement ? "Value Can't Be Empty" : null,
              suffixIcon: const Icon(Icons.percent, color: Colors.blueAccent),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.lightBlueAccent),
                borderRadius: BorderRadius.circular(25),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.blueAccent,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ),
        onConfirmBtnTap: () => _incrementSalary(),
        onCancelBtnTap: () => Navigator.pop(context),
      );
}
