import 'package:flutter/material.dart';
import '../../../services/transaction_service.dart';
import '../../../models/transaction.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  late Future<List<Transaction>> _future;

  @override
  void initState() {
    super.initState();
    _future = TransactionService.getAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      body: FutureBuilder<List<Transaction>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucune transaction'));
          }

          final tx = snapshot.data!;
          return ListView.builder(
            itemCount: tx.length,
            itemBuilder: (context, i) {
              final t = tx[i];
              return ListTile(
                title: Text(t.votant),
                subtitle: Text(t.date),
                trailing: Text('${t.montant} CFA'),
              );
            },
          );
        },
      ),
    );
  }
}
