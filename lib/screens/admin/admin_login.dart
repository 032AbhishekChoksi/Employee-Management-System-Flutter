import 'package:flutter/material.dart';
import 'package:employee_management_system/routes/route_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quickalert/quickalert.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  TextEditingController txtUserName = TextEditingController();
  bool validateUserName = false;
  TextEditingController txtPassword = TextEditingController();
  bool validatePassword = false;
  bool passwordVisible = false;

  // Empty Field Validation
  _fieldValidationCheck() {
    setState(() {
      txtUserName.text.isEmpty
          ? validateUserName = true
          : validateUserName = false;
      txtPassword.text.isEmpty
          ? validatePassword = true
          : validatePassword = false;
    });
  }

  // Firebase Firestore
  late FirebaseFirestore db;

  // Obtain shared preferences.
  late SharedPreferences prefs;

  _loginAdmin() async {
    _fieldValidationCheck();

    String userName = txtUserName.text;
    String password = txtPassword.text.toString().toLowerCase();

    await db
        .collection('tblAdmin')
        .where('username', isEqualTo: userName)
        .get()
        .then((querySnapshot) async {
      if (querySnapshot.docs.isNotEmpty) {
        final String dbPassword =
            querySnapshot.docs[0]['password'].toString().toLowerCase();
        if (password == dbPassword) {
          prefs.setBool('isLogging', true);
          prefs.setString('role', 'admin');

          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            text: 'Admin Login Successfully!',
          );
          Navigator.pushNamedAndRemoveUntil(
              context, RouteHelper.adminDashboard, (route) => false);
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
          text: 'Admin Not Registered!',
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _init();
    // _staticAdminRegister();
  }

  _init() async {
    db = FirebaseFirestore.instance;
    prefs = await SharedPreferences.getInstance();
  }

  _staticAdminRegister() async {
    final data = {
      'username': 'admin',
      'password': 'Admin#123',
    };

    // Add a document into tbAdmin on Cloud Firestore
    await db.collection("tblAdmin").add(data).then((documentSnapshot) {
      print("Admin ID: ${documentSnapshot.id}");
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: 'Admin Register Successfully',
      );
    }).onError((error, stackTrace) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        text: 'Admin Not Register!',
      );
      print("Error writing document: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Login')),
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
                // User Namae Text Field
                TextField(
                  controller: txtUserName,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    labelText: 'User Name',
                    hintText: 'User Name',
                    errorText: validateUserName ? "Value Can't Be Empty" : null,
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
                    onPressed: () => _loginAdmin(),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
