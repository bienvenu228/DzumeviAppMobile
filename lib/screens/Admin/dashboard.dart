import 'package:flutter/material.dart';

class AdminDashboard extends StatefulWidget {
  AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  Widget build(BuildContext context) {
    final items = ['Item 1', 'Item 2', 'Item 3'];

    return Scaffold(
      appBar: AppBar(title: const Text('Admin - Gestion')),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(items[index]),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // Navigation avec argument pour édition
                Navigator.pushNamed(context, '/admin/edit/${index + 1}');
              },
            ),
          );
        },
      ),
    );
  }
}
