import 'package:flutter/material.dart';
import '../../services/payment_service.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  final PaymentService _service = PaymentService();
  bool _loading = true;
  List<Map<String, dynamic>> _txs = [];
  Map<String, dynamic> _aggr = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      _txs = await _service.getTransactions();
      _aggr = _service.computeAggregates(_txs);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  Card(
                    child: ListTile(
                      title: const Text('Total'),
                      trailing: Text('${_aggr['total'] ?? 0}'),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: const Text('Moyenne par transaction'),
                      trailing: Text('${_aggr['average'] ?? 0}'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text('Par moyen de paiement', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  ...(((_aggr['byMethod'] ?? {}) as Map).entries.map((e) => ListTile(title: Text(e.key.toString()), trailing: Text(e.value.toString())))),
                  const Divider(),
                  const Text('Détails des transactions', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  ..._txs.map((t) => ListTile(
                        title: Text(t['reference']?.toString() ?? 'Tx'),
                        subtitle: Text('Montant: ${t['montant'] ?? '-'} • Moyen: ${t['moyen'] ?? t['method'] ?? '-'}'),
                      )),
                ],
              ),
            ),
    );
  }
}
