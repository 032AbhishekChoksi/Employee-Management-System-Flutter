import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EMPSalary extends StatefulWidget {
  String empid;
  EMPSalary({super.key,required this.empid});

  @override
  State<EMPSalary> createState() => _EMPSalaryState();
}

class _EMPSalaryState extends State<EMPSalary> {
  // Firebase Firestore
  late FirebaseFirestore db;

  _init() async {
    db = FirebaseFirestore.instance;
    // prefs = await SharedPreferences.getInstance();
    // empid = await prefs.getString('empid') ?? '';
  }

  @override
  void initState() {
    super.initState();
    _init();
  }
  // Load data into Stream Builder
  _streamSnapshot() => db
      .collection("tblEmployeeSalaryIncrements")
      .where('empid', isEqualTo: widget.empid)
      .snapshots();

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
    );
  }
}
