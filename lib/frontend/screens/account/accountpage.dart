import 'package:calaroiscount/frontend/widgets/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late String username = '';
  late String email = '';

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  // وظيفة لجلب بيانات المستخدم من Firebase
  void _getUserData() async {
    User? user = _auth.currentUser;

    if (user != null) {
      // تحقق من إذا كان الـ State ما زال موجودًا
      if (mounted) {
        setState(() {
          email = user.email ?? '';
        });
      }

      // جلب اسم المستخدم من Firestore
      DocumentSnapshot userData =
          await _firestore.collection('users').doc(user.uid).get();
      if (userData.exists) {
        // تحقق من إذا كان الـ State ما زال موجودًا
        if (mounted) {
          setState(() {
            username = userData['firstName'] ?? '';
          });
        }
      }
    }
  }

  // وظيفة تسجيل الخروج
  void _logout(BuildContext context) async {
    try {
      await _auth.signOut(); // تسجيل الخروج من Firebase
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You have logged out successfully!")),
      );
      // إعادة توجيه المستخدم إلى صفحة تسجيل الدخول
      Navigator.pushReplacementNamed(context, '/login-page');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbackground,
      body: ListView(
        children: [
          // قسم معلومات المستخدم
          Container(
            color: kapp,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage("assets/images/chef.png"),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username.isEmpty ? "USER" : username,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      email.isEmpty ? "EMAIL" : email,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // إعدادات الحساب
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Profile"),
            subtitle: const Text("View and edit your profile"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.of(context).pushNamed(
                '/Profile-page',
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text("Notifications"),
            subtitle: const Text("Manage notification settings"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.of(context).pushNamed(
                '/Notifications-page',
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text("Privacy & Security"),
            subtitle: const Text("Adjust your privacy settings"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.of(context).pushNamed(
                '/Privacy-page',
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text("Help & Support"),
            subtitle: const Text("Get help and support"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.of(context).pushNamed(
                '/Help-page',
              );
            },
          ),
          const Divider(),
          // تسجيل الخروج
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              "Log Out",
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              _logout(context); // تسجيل الخروج عند الضغط على "Log Out"
            },
          ),
        ],
      ),
    );
  }
}
