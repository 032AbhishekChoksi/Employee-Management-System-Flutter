import 'dart:async';

import 'package:employee_management_system/routes/route_helper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  pageRedirect() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLogging = prefs.getBool('isLogging') ?? false;

    Timer(const Duration(seconds: 2), () {
      if (isLogging) {
        String role = prefs.getString('role') ?? '';
        print("Role:- $role");
        if (role == 'employee') {
          Navigator.pushReplacementNamed(
              context, RouteHelper.employeeDashboard);
        } else if (role == 'admin') {
          Navigator.pushReplacementNamed(context, RouteHelper.adminDashboard);
        } else {
          prefs.setBool('isLogging', false);
          Navigator.pushReplacementNamed(context, RouteHelper.selectLogin);
        }
      } else {
        Navigator.pushReplacementNamed(context, RouteHelper.selectLogin);
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageRedirect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            textDirection: TextDirection.ltr,
            children: [
              Image.asset(
                'assets/images/ems_logo.png',
                fit: BoxFit.fill,
                width: 350,
                height: 350,
              ),
              const SizedBox(height: 100),
              const Text(
                'Developed By Abhishek Choksi',
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 26,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
