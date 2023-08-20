import 'package:employee_management_system/screens/admin/admin_dashboard.dart';
import 'package:employee_management_system/screens/admin/admin_employee_details.dart';
import 'package:employee_management_system/screens/admin/admin_login.dart';
import 'package:employee_management_system/screens/employee/empdashboard.dart';
import 'package:employee_management_system/screens/employee/emplogin.dart';
import 'package:employee_management_system/screens/employee/empregister.dart';
import 'package:employee_management_system/screens/select_login.dart';
import 'package:employee_management_system/screens/splash.dart';
import 'package:flutter/material.dart';

class RouteHelper {
  static const String splash = '/';
  static const String selectLogin = 'select-login';
  static const String employeeLogin = 'employee-login';
  static const String employeeRegister = 'employee-register';
  static const String employeeDashboard = 'employee-dashboard';
   static const String adminLogin = 'admin-login';
  static const String adminDashboard = 'admin-dashboard';
  static const String adminEmployeeDetails = 'admin-employee-details';

  static Map<String, WidgetBuilder> get routes {
    return {
      splash: (context) => const Splash(),
      selectLogin: (context) => const SelectLogin(),
      employeeLogin: (context) => const EMPLogin(),
      employeeRegister: (context) => const EMPRegistration(),
      employeeDashboard: (context) => const EMPDashboard(),
      adminLogin:(context) => const AdminLogin(),
      adminDashboard:(context) => const AdminDashboard(),
      adminEmployeeDetails:(context) => const AdminEmployeeDetails()
    };
  }
}
