import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import '../models/admin.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _service = AuthService();
  Admin? admin;
  bool isLoading = false;

  Future<void> loginAdmin(String name, String password) async {
    isLoading = true;
    notifyListeners();

    try {
      final data = await _service.loginAdmin(name, password);
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('token', data['token']);
      await prefs.setString('admin_name', data['admin']['name']);

      admin = Admin.fromJson(data['admin']);
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
