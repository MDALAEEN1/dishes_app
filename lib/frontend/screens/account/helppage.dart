import 'package:calaroiscount/frontend/screens/account/FAQpage.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({Key? key}) : super(key: key);

  Future<void> _launchURL() async {
    const url = 'tel:+1234567890'; // رقم الهاتف الخاص بالدعم
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // قسم الأسئلة الشائعة
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('FAQ'),
              subtitle: const Text('Find answers to common questions.'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => FAQPage()), // صفحة الأسئلة الشائعة
                );
              },
            ),
            const Divider(),

            // قسم الاتصال بالدعم
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Contact Us'),
              subtitle: const Text('Reach out to our support team.'),
              onTap: _launchURL, // فتح تطبيق الهاتف لإجراء مكالمة
            ),
          ],
        ),
      ),
    );
  }
}
