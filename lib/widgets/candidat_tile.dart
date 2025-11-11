import 'package:flutter/material.dart';

class CandidatTile extends StatelessWidget {
  final String nom;
  final String categorie;
  final String photo;

  const CandidatTile({
    super.key,
    required this.nom,
    required this.categorie,
    required this.photo,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(photo, width: 50, height: 50, fit: BoxFit.cover),
      title: Text(nom),
      subtitle: Text(categorie),
    );
  }
}
