import 'package:employee_management_system/routes/route_helper.dart';
import 'package:employee_management_system/screens/employee/empleave.dart';
import 'package:employee_management_system/screens/employee/empsalary.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EMPDashboard extends StatefulWidget {
  const EMPDashboard({super.key});

  @override
  State<EMPDashboard> createState() => _EMPDashboardState();
}

class _EMPDashboardState extends State<EMPDashboard> {
  late SharedPreferences prefs;
  String empid = '';

  _logout() async {
    await prefs.setBool('isLogging', false);
    await prefs.setString('role', '');
    await prefs.setString('empid', '');
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
    prefs = await SharedPreferences.getInstance();
    empid = await prefs.getString('empid') ?? '';
  }

  _getEMPID() async {
    empid = await prefs.getString('empid') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    // _getEMPID();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            title: const Text('Dashboard'),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Leaves'),
                Tab(text: 'Salaries'),
              ],
            ),
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
            ]),
        body: TabBarView(
          children: [
            EMPLeave(empid: empid),
            EMPSalary(empid: empid),
          ],
        ),
      ),
    );
  }
}
