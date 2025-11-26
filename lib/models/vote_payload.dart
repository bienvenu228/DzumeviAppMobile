class VotePayload {
  final int candidatId;
  final String nomVotant;
  final String telephone;
  final int nombreVotes;
  final String operateur;        // "t-money" ou "flooz"
  final int montantTotal;        // nombreVotes * prixParVote

  VotePayload({
    required this.candidatId,
    required this.nomVotant,
    required this.telephone,
    required this.nombreVotes,
    required this.operateur,
    required this.montantTotal,
  });

  Map<String, dynamic> toJson() {
    return {
      'candidat_id': candidatId,
      'nom_votant': nomVotant.trim(),
      'telephone': telephone.replaceAll(RegExp(r'\D'), ''), // nettoie le numéro
      'nombre_votes': nombreVotes,
      'operateur': operateur,
      'montant': montantTotal,
    };
  }

  @override
  String toString() {
    return 'VotePayload{candidat: $candidatId, votant: $nomVotant, votes: $nombreVotes, montant: $montantTotal FCFA}';
  }
}