import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EMPLeave extends StatefulWidget {
  String empid;

  EMPLeave({super.key, required this.empid});

  @override
  State<EMPLeave> createState() => _EMPLeaveState();
}

class _EMPLeaveState extends State<EMPLeave> {
  // Firebase Firestore
  late FirebaseFirestore db;

  // late SharedPreferences prefs;
  // String empid = '';

  List<String> typeOfLeave = ['Casual', 'Sick', 'Marriage '];
  String selectedLeave = 'Casual';
  TextEditingController txtLeaveReason = TextEditingController();
  bool validateLeaveReason = false;
  TextEditingController txtFromToDate = TextEditingController();
  var selectedFromDate;
  var selectedToDate;
  bool validateFromToDate = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    db = FirebaseFirestore.instance;
    // prefs = await SharedPreferences.getInstance();
    // empid = await prefs.getString('empid') ?? '';
  }

  // Load data into Stream Builder
  _streamSnapshot() => db
      .collection("tblLeave")
      .where('empid', isEqualTo: widget.empid)
      .snapshots();

  // Empty Field Validation
  _fieldValidationCheck() {
    setState(() {
      txtLeaveReason.text.isEmpty
          ? validateLeaveReason = true
          : validateLeaveReason = false;
      txtFromToDate.text.isEmpty
          ? validateFromToDate = true
          : validateFromToDate = false;
    });
  }

  // Clear Field
  _fieldClear() {
    setState(() {
      txtLeaveReason.text = '';
      txtFromToDate.text = '';
      selectedLeave = 'Casual';
    });
  }

  // Apply Leave
  _applyLeave() async {
    _fieldValidationCheck();

    String leaveReason = txtLeaveReason.text.toString();
    String fromToDate = txtFromToDate.text.toString();

    final data = {
      'empid': widget.empid,
      'leave': selectedLeave,
      'reason': leaveReason,
      'fromToDate': fromToDate,
      'status': 'pending',
    };

    // Add a document into tblLeave on Cloud Firestore
    await db.collection("tblLeave").add(data).then((documentSnapshot) {
      _fieldClear();
      print("Leave Apply with ID: ${documentSnapshot.id}");
      Navigator.pop(context);
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: 'Leave Apply Successfully',
      );
    }).onError((error, stackTrace) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        text: 'Not Leave Apply!',
      );
      print("Error writing document: $error");
    });
  }

  // Update Leave
  _updateLeave(DocumentSnapshot documentSnapshot) async {
    _fieldValidationCheck();

    String leaveReason = txtLeaveReason.text.toString();
    String fromToDate = txtFromToDate.text.toString();

    final data = {
      'empid': widget.empid,
      'leave': selectedLeave,
      'reason': leaveReason,
      'fromToDate': fromToDate,
      'status': 'pending',
    };

    // Update a document into tblLeave on Cloud Firestore
    await db
        .collection("tblLeave")
        .doc(documentSnapshot.id)
        .update(data)
        .then((documentSnapshot) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: 'Leave Update Successfully',
      );
      print("Leave Update");
    }).onError((error, stackTrace) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        text: 'Not Leave Apply!',
      );
      print("Error writing document: $error");
    });
  }

  //  Delete record into tblLeave on Cloud Firestore
  _deleteLeave(DocumentSnapshot documentSnapshot) async {
    await db.collection("tblLeave").doc(documentSnapshot.id).delete().then(
      (doc) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'Leave Deleted Successfully',
        );
        print("Leave Deleted Successfully");
      },
      onError: (e) => print("Error updating document $e"),
    );
  }

  // Show Modal Bottom Sheet Form Open for insert and edit
  void _showForm(DocumentSnapshot? documentSnapshot) async {
    if (documentSnapshot != null) {
      selectedLeave = documentSnapshot['leave'];
      txtLeaveReason.text = documentSnapshot['reason'];
      txtFromToDate.text = documentSnapshot['fromToDate'];
    }
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      elevation: 5,
      builder: (context) => Container(
        margin: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              const Text('Leave Apply',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
              const SizedBox(height: 10),
              //   Leave Type
              Container(
                height: 55,
                margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: DropdownButton(
                  focusColor: Colors.blueAccent,
                  elevation: 10,
                  isExpanded: true,
                  value: selectedLeave,
                  iconEnabledColor: Colors.blueAccent,
                  iconSize: 30,
                  items: typeOfLeave
                      .map<DropdownMenuItem<String>>(
                        (leave) => DropdownMenuItem(
                          value: leave,
                          child: Text(
                            leave,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.normal),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (String? changeValue) {
                    setState(() {
                      selectedLeave = changeValue!;
                    });
                  },
                ),
              ),
              const SizedBox(height: 10),
              //   Leave Reason
              TextField(
                controller: txtLeaveReason,
                keyboardType: TextInputType.multiline,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Leave Reason',
                  hintText: 'Leave Reason',
                  errorText:
                      validateLeaveReason ? "Value Can't Be Empty" : null,
                  prefixIcon: const Icon(Icons.description_outlined,
                      color: Colors.blueAccent),
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
              const SizedBox(height: 10),
              // From and TO Date
              TextField(
                controller: txtFromToDate,
                readOnly: true,
                showCursor: true,
                onTap: () async {
                  DateTimeRange? dateTimeRangePicker =
                      await showDateRangePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(
                      const Duration(days: 365),
                    ),
                  );
                  if (dateTimeRangePicker != null) {
                    setState(() {
                      selectedFromDate = DateFormat('dd-MM-yyy')
                          .format(dateTimeRangePicker.start);
                      selectedToDate = DateFormat('dd-MM-yyy')
                          .format(dateTimeRangePicker.end);
                      txtFromToDate.text =
                          selectedFromDate + ' - ' + selectedToDate;
                    });
                  }
                },
                decoration: InputDecoration(
                  labelText: 'From Date - To Date',
                  hintText: 'From Date - To Date',
                  errorText: validateFromToDate ? "Value Can't Be Empty" : null,
                  prefixIcon: const Icon(Icons.calendar_month,
                      color: Colors.blueAccent),
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
              const SizedBox(height: 10),
              // Apply Leave Button
              Center(
                child: SizedBox(
                  width: 300,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      if (documentSnapshot == null) {
                        _applyLeave();
                      } else {
                        _updateLeave(documentSnapshot);
                      }
                    },
                    child: const Text(
                      'Apply',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
          stream: _streamSnapshot(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              debugPrint(
                  "ID:${widget.empid} and length: ${snapshot.data!.docs.length}");
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
                        trailing: documentSnapshot['status'] == 'pending'
                            ? SizedBox(
                                width: 100,
                                child: Row(
                                  children: [
                                    IconButton(
                                        onPressed: () =>
                                            _showForm(documentSnapshot),
                                        icon: const Icon(Icons.edit)),
                                    IconButton(
                                        onPressed: () =>
                                            _deleteLeave(documentSnapshot),
                                        icon: const Icon(Icons.delete))
                                  ],
                                ),
                              )
                            : Text(
                                documentSnapshot['status']
                                    .toString()
                                    .toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.green,
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(null),
        child: const Icon(Icons.add),
      ),
    );
  }
}
