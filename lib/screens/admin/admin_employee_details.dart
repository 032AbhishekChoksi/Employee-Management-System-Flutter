import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_management_system/screens/admin/admin_employee_leave.dart';
import 'package:employee_management_system/screens/admin/admin_employee_salary.dart';
import 'package:flutter/material.dart';

class AdminEmployeeDetails extends StatefulWidget {
  const AdminEmployeeDetails({super.key});

  @override
  State<AdminEmployeeDetails> createState() => _AdminEmployeeDetailsState();
}

class _AdminEmployeeDetailsState extends State<AdminEmployeeDetails> {
  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as DocumentSnapshot;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("${arg['name']}"),
          bottom: const TabBar(
            labelStyle: TextStyle(fontSize: 19),
            tabs: [
              Tab(text: 'Leaves'),
              Tab(text: 'Salaries'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            AdminEmployeeLeave(id: arg.id),
           AdminEmployeeSalary(employee: arg),
          ],
        ),
      ),
    );
  }
}
