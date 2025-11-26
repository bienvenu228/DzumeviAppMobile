// lib/screens/candidats_screen.dart
import 'package:flutter/material.dart';
import '../models/concours.dart';


class CandidatsScreen extends StatefulWidget {
  final Concours concours;

  const CandidatsScreen({super.key, required this.concours});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Candidats - ${concours.name}'),
      ),
      body:  Center(

        child: 
      ),
    );
  }
}