import 'package:flutter/material.dart';
import 'package:employee_management_system/routes/route_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/gestures.dart';
import 'package:quickalert/quickalert.dart';

class EMPLogin extends StatefulWidget {
  const EMPLogin({super.key});

  @override
  State<EMPLogin> createState() => _EMPLoginState();
}

class _EMPLoginState extends State<EMPLogin> {
  TextEditingController txtContactNo = TextEditingController();
  bool validateContactNo = false;
  TextEditingController txtPassword = TextEditingController();
  bool validatePassword = false;
  bool passwordVisible = false;

  // Empty Field Validation
  _fieldValidationCheck() {
    setState(() {
      txtContactNo.text.isEmpty
          ? validateContactNo = true
          : validateContactNo = false;
      txtPassword.text.isEmpty
          ? validatePassword = true
          : validatePassword = false;
    });
  }

  // Firebase Firestore
  late FirebaseFirestore db;

  // Obtain shared preferences.
  late SharedPreferences prefs;

  _loginEmployee() async {
    _fieldValidationCheck();

    String contactNo = txtContactNo.text;
    String password = txtPassword.text.toString().toLowerCase();

    await db
        .collection('tblEmployee')
        .where('contactNo', isEqualTo: contactNo)
        .get()
        .then((querySnapshot) async {
      if (querySnapshot.docs.isNotEmpty) {
        final bool dbStatus =querySnapshot.docs[0]['status'];
        final String dbPassword =
            querySnapshot.docs[0]['password'].toString().toLowerCase();
        if (!dbStatus) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.warning,
            text: 'Admin Not Approved!',
          );
        } else if (password == dbPassword) {
          final String empid = querySnapshot.docs[0].id;
          prefs.setBool('isLogging', true);
          prefs.setString('role', 'employee');
          prefs.setString('empid', empid);

          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: 'Employee Login Successfully!',
          );
          Navigator.pushNamedAndRemoveUntil(
              context, RouteHelper.employeeDashboard, (route) => false);
        } else {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.warning,
            text: 'Wrong Password!',
          );
        }
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.warning,
          text: 'Employee Not Registered!',
        );
      }
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Employee Login')),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: const EdgeInsets.only(top: 50.0, left: 10.0, right: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Login Title
                Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 15),
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
                    suffixIcon:
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
                const SizedBox(height: 15),
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
                // Login Button
                SizedBox(
                  width: 300,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () => _loginEmployee(),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Sign In Link
                RichText(
                  text: TextSpan(
                    text: "Don't have account?\t",
                    style: const TextStyle(fontSize: 22, color: Colors.grey),
                    children: [
                      TextSpan(
                        text: "Register",
                        style: const TextStyle(
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                          color: Colors.black,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamed(
                                context, RouteHelper.employeeRegister);
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
