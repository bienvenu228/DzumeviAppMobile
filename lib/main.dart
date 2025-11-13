import 'package:shared_preferences/shared_preferences.dart';

import 'screens/Admin/login.dart';
import 'screens/Admin/dashboard.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  runApp(MyApp(token: token));
}

class MyApp extends StatelessWidget {
  final String? token;
  const MyApp({super.key, this.token});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: token == null
          ? const AdminLoginScreen()
          : const AdminDashboardScreen(),
    );
  }
}
