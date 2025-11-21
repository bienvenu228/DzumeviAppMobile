import 'package:flutter/material.dart';
import 'candidatListPage.dart';

class VoteListPage extends StatefulWidget {
  final String voteId;
  const VoteListPage({super.key, required this.voteId});

  @override
  State<VoteListPage> createState() => _VoteListPageState();
}

class _VoteListPageState extends State<VoteListPage> {
  @override
  Widget build(BuildContext context) {
    return CandidatListPage(voteId: widget.voteId);
  }
}
