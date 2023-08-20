import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_management_system/routes/route_helper.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  // Firebase Firestore
  late FirebaseFirestore db;
  late SharedPreferences prefs;

  _logout() async {
    await prefs.setBool('isLogging', false);
    await prefs.setString('role', '');
    Navigator.pushNamedAndRemoveUntil(
      context,
      RouteHelper.selectLogin,
      (route) => false,
    );
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    db = FirebaseFirestore.instance;
    prefs = await SharedPreferences.getInstance();
  }

// Load data into Stream Builder
  _streamSnapshot() => db.collection("tblEmployee").snapshots();

  _updateStatus(DocumentSnapshot documentSnapshot, bool status) async {
    // Update a document into tblLeave on Cloud Firestore
    await db
        .collection("tblEmployee")
        .doc(documentSnapshot.id)
        .update({'status': status}).then((documentSnapshot) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: 'Approved Employee',
      );
      print("Employee Status Update");
    }).onError((error, stackTrace) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        text: 'Not Approved Employee!',
      );
      print("Error writing document: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            onPressed: () => QuickAlert.show(
              context: context,
              type: QuickAlertType.confirm,
              text: 'Do you want to logout',
              confirmBtnText: 'Yes',
              cancelBtnText: 'No',
              confirmBtnColor: Colors.green,
              onConfirmBtnTap: () => _logout(),
              onCancelBtnTap: () => Navigator.pop(context),
            ),
            icon: const Icon(Icons.login_outlined),
          ),
        ],
      ),
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
          stream: _streamSnapshot(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.docs.isNotEmpty) {
                return ListView.builder(
                  padding: const EdgeInsets.all(10.0),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    final DocumentSnapshot documentSnapshot =
                        snapshot.data!.docs[index];
                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.only(left: 10.0, right: 10),
                        leading: Text(
                          documentSnapshot.id,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        title: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            documentSnapshot['name'],
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            documentSnapshot['designation'],
                            style: const TextStyle(
                                fontSize: 16, fontStyle: FontStyle.italic),
                          ),
                        ),
                        trailing: SizedBox(
                          width: 120,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Switch(
                                value: documentSnapshot['status'],
                                onChanged: (bool value) {
                                  _updateStatus(documentSnapshot, value);
                                },
                              ),
                              const SizedBox(height: 50),
                              IconButton(
                                onPressed: () => Navigator.pushNamed(
                                  context,
                                  RouteHelper.adminEmployeeDetails,
                                  arguments: documentSnapshot,
                                ),
                                icon: const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 20,
                                ),
                              ),
                            ],
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
