import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Center(
        child: const Text(
          'Manage your notifications settings here.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
