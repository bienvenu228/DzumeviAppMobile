import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/vote.dart';

class VoteService {
  final String baseUrl = "http://127.0.0.1:8000/api";

  Future<List<Vote>> getVotes() async {
    final res = await http.get(Uri.parse('$baseUrl/votes'));

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as List;
      return data.map((e) => Vote.fromJson(e)).toList();
    } else {
      throw Exception('Erreur lors du chargement des votes');
    }
  }
}
