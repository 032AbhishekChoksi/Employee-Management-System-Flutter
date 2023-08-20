import 'package:employee_management_system/routes/route_helper.dart';
import 'package:flutter/material.dart';

class SelectLogin extends StatelessWidget {
  const SelectLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Select Login Title
            Text(
              'Select Login',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 25),
            // Admin Login Button
            SizedBox(
              width: 300,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  backgroundColor: Colors.lightBlueAccent,
                ),
                onPressed: () => Navigator.pushNamed(context, RouteHelper.adminLogin),
                child: const Text(
                  'Admin Login',
                  style: TextStyle(fontSize: 22, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Employee Login Button
            SizedBox(
              width: 300,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  backgroundColor: Colors.lightBlueAccent,
                ),
                onPressed: () =>
                    Navigator.pushNamed(context, RouteHelper.employeeLogin),
                child: const Text(
                  'Employee Login',
                  style: TextStyle(fontSize: 22, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
