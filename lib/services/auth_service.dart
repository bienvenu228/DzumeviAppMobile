import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/admin.dart';
import '../models/votant.dart';

class AuthService {
  final String baseUrl = "https://mon-api.com/api";

  Future<Admin> loginAdmin(String email, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/admin/login'),
      body: {'email': email, 'password': password},
    );

    if (res.statusCode == 200) {
      return Admin.fromJson(jsonDecode(res.body));
    } else {
      throw Exception('Erreur de connexion admin');
    }
  }

  Future<Votant> loginVotant(String matricule) async {
    final res = await http.post(
      Uri.parse('$baseUrl/votants/login'),
      body: {'matricule': matricule},
    );

    if (res.statusCode == 200) {
      return Votant.fromJson(jsonDecode(res.body));
    } else {
      throw Exception('Erreur de connexion votant');
    }
  }
}
