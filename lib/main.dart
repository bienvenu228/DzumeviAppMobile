import 'package:dzumevimobile/screens/Admin/admin.edit.dart';
import 'package:dzumevimobile/screens/Admin/dashboard.dart';
import 'package:dzumevimobile/screens/Admin/vote.liste.dart';
import 'package:dzumevimobile/screens/candidat.detail.dart';
import 'package:dzumevimobile/screens/candidatListPage.dart';
import 'package:dzumevimobile/screens/vote.detail.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dzumevi App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      onGenerateRoute: (settings) {
        // Route avec argument: /candidat/123
        if (settings.name?.startsWith('/candidat/') ?? false) {
          final candidatId = settings.name!.split('/').last;
          return MaterialPageRoute(
            builder: (context) => CandidatDetailPage(candidatId: candidatId),
            settings: settings,
          );
        }

        // Route avec argument: /vote/456
        if (settings.name?.startsWith('/vote/') ?? false) {
          final voteId = settings.name!.split('/').last;
          return MaterialPageRoute(
            builder: (context) => VoteDetailPage(voteId: voteId),
            settings: settings,
          );
        }

        // Route avec plusieurs arguments: /admin/edit/789
        if (settings.name?.startsWith('/admin/edit/') ?? false) {
          final itemId = settings.name!.split('/').last;
          return MaterialPageRoute(
            builder: (context) => AdminEditPage(itemId: itemId),
            settings: settings,
          );
        }

        // Route par défaut
        return MaterialPageRoute(
          builder: (context) => HomePage(),
        );
      },
      routes: {
        '/': (context) => HomePage(),
        '/candidats': (context) => CandidatListPage(),
        '/votes': (context) => VoteListPage(),
        '/admin': (context) => AdminDashboard(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dzumevi App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/candidats');
              },
              child: const Text('Voir les Candidats'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/votes');
              },
              child: const Text('Voir les Votes'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/admin');
              },
              child: const Text('Admin'),
            ),
          ],
        ),
      ),
    );
  }
}