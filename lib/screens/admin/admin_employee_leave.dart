import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

class AdminEmployeeLeave extends StatefulWidget {
  String id;

  AdminEmployeeLeave({super.key, required this.id});

  @override
  State<AdminEmployeeLeave> createState() => _AdminEmployeeLeaveState();
}

class _AdminEmployeeLeaveState extends State<AdminEmployeeLeave> {
  // Firebase Firestore
  late FirebaseFirestore db;

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
      .collection("tblLeave")
      .where('empid', isEqualTo: widget.id)
      .snapshots();

// Update Leave Status
  _updateLeaveStatus(DocumentSnapshot documentSnapshot, String status) async {
    // Update a document into tblLeave on Cloud Firestore
    await db.collection("tblLeave").doc(documentSnapshot.id).update({
      'status': status,
    }).then((documentSnapshot) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: 'Leave Status Update Successfully',
      );
      print("Leave Status Update");
    }).onError((error, stackTrace) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        text: 'Not Leave Status Apply!',
      );
      print("Error writing document: $error");
    });
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
                        title: Text(documentSnapshot['leave']),
                        subtitle: Text(documentSnapshot['reason']),
                        trailing: InkWell(
                          onTap: () {
                            documentSnapshot['status']
                                .toString()
                                .toLowerCase() ==
                                'pending'
                                ? QuickAlert.show(
                              context: context,
                              type: QuickAlertType.confirm,
                              title: 'Leave Status',
                              text: 'Approve or Reject?',
                              confirmBtnText: 'Approve',
                              cancelBtnText: 'Reject',
                              confirmBtnColor: Colors.green,
                              onConfirmBtnTap: () {
                                _updateLeaveStatus(documentSnapshot, 'approve');
                                Navigator.pop(context);
                              },
                              onCancelBtnTap: () {
                                _updateLeaveStatus(documentSnapshot, 'reject');
                                Navigator.pop(context);
                              },
                            ):null;
                          },
                          child: Text(
                            documentSnapshot['status'].toString().toUpperCase(),
                            style: documentSnapshot['status']
                                        .toString()
                                        .toLowerCase() ==
                                    'pending'
                                ? TextStyle(
                                    fontSize: 18,
                                    color: Colors.green,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.green,
                                  )
                                : TextStyle(
                                    fontSize: 18,
                                    color: documentSnapshot['status']
                                                .toString()
                                                .toLowerCase() ==
                                            'approve'
                                        ? Colors.blue
                                        : documentSnapshot['status']
                                                    .toString()
                                                    .toLowerCase() ==
                                                'reject'
                                            ? Colors.red
                                            : Colors.black,
                                  ),
                          ),
                        ),
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
