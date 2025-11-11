import 'package:flutter/foundation.dart';
import '../models/admin.dart';
import '../models/votant.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _service = AuthService();

  Admin? admin;
  Votant? votant;
  bool isLoading = false;

  Future<void> loginAdmin(String email, String password) async {
    isLoading = true;
    notifyListeners();

    admin = await _service.loginAdmin(email, password);

    isLoading = false;
    notifyListeners();
  }
}
