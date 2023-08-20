import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickalert/quickalert.dart';

class EMPRegistration extends StatefulWidget {
  const EMPRegistration({super.key});

  @override
  State<EMPRegistration> createState() => _EMPRegistrationState();
}

class _EMPRegistrationState extends State<EMPRegistration> {
  TextEditingController txtNo = TextEditingController();
  bool validateNo = false;
  TextEditingController txtName = TextEditingController();
  bool validateName = false;
  TextEditingController txtContactNo = TextEditingController();
  bool validateContactNo = false;
  String selectedGender = 'M';
  TextEditingController txtEmail = TextEditingController();
  bool validateEmail = false;
  TextEditingController txtPassword = TextEditingController();
  bool validatePassword = false;
  bool passwordVisible = false;
  List<String> listOfCity = [
    'Ahmedabad',
    'Ankleshware',
    'Bardoli',
    'Bharuch',
    'Surat',
    'Vadodara',
  ];
  String selectedCity = 'Bardoli';
  TextEditingController txtDOB = TextEditingController();
  bool validateDOB = false;
  var selectedDOB;
  TextEditingController txtSalary = TextEditingController();
  bool validateSalary = false;
  List<String> listOfDesignation = [
    'Project Manager',
    'Assistant Manager',
    'Sr. Developer',
    'Jr. Developer'
  ];
  String selectedDesignation = 'Jr. Developer';

  // Empty Field Validation
  _fieldValidationCheck() {
    setState(() {
      txtNo.text.isEmpty ? validateNo = true : validateNo = false;
      txtName.text.isEmpty ? validateName = true : validateName = false;
      txtContactNo.text.isEmpty
          ? validateContactNo = true
          : validateContactNo = false;
      txtEmail.text.isEmpty ? validateEmail = true : validateEmail = false;
      txtPassword.text.isEmpty
          ? validatePassword = true
          : validatePassword = false;
      txtDOB.text.isEmpty ? validateDOB = true : validateDOB = false;
      txtSalary.text.isEmpty ? validateSalary = true : validateSalary = false;
    });
  }

  // Clear Field
  _fieldClear() {
    setState(() {
      txtNo.text = '';
      txtName.text = '';
      txtContactNo.text = '';
      selectedGender = 'M';
      txtEmail.text = '';
      txtPassword.text = '';
      selectedCity = 'Bardoli';
      txtDOB.text = '';
      txtSalary.text = '';
      selectedDesignation = 'Jr. Developer';
    });
  }

  // refer the collection or table in the firebase database
  late FirebaseFirestore db;

  _registerEmployee() async {
    _fieldValidationCheck();

    String no = txtNo.text.toString();
    String name = txtName.text;
    String contactNo = txtContactNo.text;
    String email = txtEmail.text;
    String password = txtPassword.text;
    String dob = txtDOB.text;
    final double? salary = double.tryParse(txtSalary.text.toString());

    final data = {
      'name': name,
      'contactNo': contactNo,
      'gender': selectedGender,
      'email': email,
      'password': password,
      'city': selectedCity,
      'dob': dob,
      'designation': selectedDesignation,
      'salary': salary,
      'status': false,
    };

    // Add a document into tblEmployee on Cloud Firestore
    await db
        .collection("tblEmployee")
        .doc(no)
        .set(data)
        .then((documentSnapshot) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: 'Employee Register Successfully',
      );
      print("Added Employee with ID: $data");
      _fieldClear();
    }).onError((error, stackTrace) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        text: 'Not Register Employee!',
      );
      print("Error writing document: $error");
    });
  }

  @override
  void initState() {
    super.initState();
    db = FirebaseFirestore.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Employee Registration')),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Container(
            margin: const EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Login Title
                Text(
                  'Registration',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 15),
                // No Text Field
                TextField(
                  controller: txtNo,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  decoration: InputDecoration(
                    labelText: 'ID',
                    hintText: 'ID',
                    errorText: validateNo ? "Value Can't Be Empty" : null,
                    prefixIcon:
                    const Icon(Icons.numbers, color: Colors.blueAccent),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      const BorderSide(color: Colors.lightBlueAccent),
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
                const SizedBox(height: 15),
                // Name Text Field
                TextField(
                  controller: txtName,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    hintText: 'Name',
                    errorText: validateName ? "Value Can't Be Empty" : null,
                    prefixIcon:
                    const Icon(Icons.person, color: Colors.blueAccent),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      const BorderSide(color: Colors.lightBlueAccent),
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
                const SizedBox(height: 20),
                // Contact No Text Field
                TextField(
                  controller: txtContactNo,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  decoration: InputDecoration(
                    labelText: 'Contact No',
                    hintText: 'Contact No',
                    errorText:
                    validateContactNo ? "Value Can't Be Empty" : null,
                    prefixIcon:
                    const Icon(Icons.phone, color: Colors.blueAccent),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      const BorderSide(color: Colors.lightBlueAccent),
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
                // Male Radio Button
                RadioListTile(
                  title: const Text('Male', style: TextStyle(fontSize: 20)),
                  value: 'M',
                  groupValue: selectedGender,
                  onChanged: (changeGender) {
                    setState(() {
                      selectedGender = changeGender!;
                    });
                  },
                ),
                // Female Radio Button
                RadioListTile(
                  title: const Text('Female', style: TextStyle(fontSize: 20)),
                  value: 'F',
                  groupValue: selectedGender,
                  onChanged: (changeGender) {
                    setState(() {
                      selectedGender = changeGender!;
                    });
                  },
                ),
                // Other Radio Button
                RadioListTile(
                  title: const Text('Other', style: TextStyle(fontSize: 20)),
                  value: 'O',
                  groupValue: selectedGender,
                  onChanged: (changeGender) {
                    setState(() {
                      selectedGender = changeGender!;
                    });
                  },
                ),
                const SizedBox(height: 15),
                // Email Text Field
                TextField(
                  controller: txtEmail,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Email',
                    errorText: validateEmail ? "Value Can't Be Empty" : null,
                    prefixIcon: const Icon(Icons.alternate_email,
                        color: Colors.blueAccent),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      const BorderSide(color: Colors.lightBlueAccent),
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
                const SizedBox(height: 20),
                // Password Text Field
                TextField(
                  controller: txtPassword,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: !passwordVisible,
                  obscuringCharacter: '*',
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Password',
                    errorText: validatePassword ? "Value Can't Be Empty" : null,
                    prefixIcon:
                    const Icon(Icons.password, color: Colors.blueAccent),
                    suffixIcon: IconButton(
                      onPressed: () =>
                          setState(() => passwordVisible = !passwordVisible),
                      icon: Icon(
                        passwordVisible
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Colors.blueAccent,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      const BorderSide(color: Colors.lightBlueAccent),
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
                const SizedBox(height: 20),
                // City Dropdown
                Container(
                  height: 55,
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: DropdownButton(
                    focusColor: Colors.blueAccent,
                    elevation: 10,
                    isExpanded: true,
                    value: selectedCity,
                    iconEnabledColor: Colors.blueAccent,
                    iconSize: 30,
                    items: listOfCity
                        .map<DropdownMenuItem<String>>(
                          (city) => DropdownMenuItem(
                        value: city,
                        child: Text(
                          city,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    )
                        .toList(),
                    onChanged: (String? changeValue) {
                      setState(() {
                        selectedCity = changeValue!;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 15),
                // DOB
                TextField(
                  controller: txtDOB,
                  readOnly: true,
                  showCursor: true,
                  onTap: () async {
                    DateTime? datePicker = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2001),
                      lastDate: DateTime.now(),
                    );

                    if (datePicker != null) {
                      setState(() {
                        selectedDOB =
                            DateFormat('dd-MM-yyy').format(datePicker);
                        txtDOB.text = selectedDOB;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'DOB',
                    hintText: 'DOB',
                    errorText: validateDOB ? "Value Can't Be Empty" : null,
                    prefixIcon: const Icon(Icons.calendar_month,
                        color: Colors.blueAccent),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      const BorderSide(color: Colors.lightBlueAccent),
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
                const SizedBox(height: 20),
                // Designation Dropdown
                Container(
                  height: 55,
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: DropdownButton(
                    focusColor: Colors.blueAccent,
                    elevation: 10,
                    isExpanded: true,
                    value: selectedDesignation,
                    iconEnabledColor: Colors.blueAccent,
                    iconSize: 30,
                    items: listOfDesignation
                        .map<DropdownMenuItem<String>>(
                          (designation) => DropdownMenuItem(
                        value: designation,
                        child: Text(
                          designation,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    )
                        .toList(),
                    onChanged: (String? changeValue) {
                      setState(() {
                        selectedDesignation = changeValue!;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),
                // Salary
                TextField(
                  controller: txtSalary,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Salary',
                    hintText: 'Salary',
                    errorText: validateSalary ? "Value Can't Be Empty" : null,
                    prefixIcon: const Icon(Icons.currency_rupee,
                        color: Colors.blueAccent),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      const BorderSide(color: Colors.lightBlueAccent),
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
                const SizedBox(height: 20),
                // Register Button
                SizedBox(
                  width: 300,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () => _registerEmployee(),
                    child: const Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Login Link
                RichText(
                  text: TextSpan(
                    text: "Have an account?\t",
                    style: const TextStyle(fontSize: 22, color: Colors.grey),
                    children: [
                      TextSpan(
                        text: "Login",
                        style: const TextStyle(
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                          color: Colors.black,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pop(context);
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
