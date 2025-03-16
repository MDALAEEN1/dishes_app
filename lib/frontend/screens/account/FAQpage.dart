import 'package:flutter/material.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQ'),
        backgroundColor: Colors.redAccent,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('Here are some frequently asked questions...'),
      ),
    );
  }
}
