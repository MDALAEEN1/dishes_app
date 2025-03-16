import 'package:flutter/material.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({Key? key}) : super(key: key);

  // حوار لتغيير كلمة المرور
  void _showChangePasswordDialog(BuildContext context) {
    final _passwordController = TextEditingController();
    final _confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'New Password',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final newPassword = _passwordController.text;
                final confirmPassword = _confirmPasswordController.text;

                if (newPassword == confirmPassword && newPassword.isNotEmpty) {
                  // من المفترض هنا إضافة وظيفة تغيير كلمة المرور باستخدام Firebase
                  print('Password changed to: $newPassword');
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Password changed successfully')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Passwords do not match')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // حوار لتفعيل المصادقة الثنائية
  void _showTwoFactorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Two-Factor Authentication'),
          content: const Text(
            'Two-factor authentication (2FA) adds an extra layer of security to your account. '
            'You will receive a verification code via SMS or email whenever you log in.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // إضافة وظيفة لتفعيل المصادقة الثنائية (مثل Firebase Auth)
                print('Two-factor authentication enabled');
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('2FA enabled successfully')),
                );
              },
              child: const Text('Enable'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy & Security'),
        backgroundColor: Colors.greenAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Change Password'),
              subtitle:
                  const Text('Update your password to secure your account.'),
              onTap: () => _showChangePasswordDialog(context),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.shield),
              title: const Text('Two-Factor Authentication'),
              subtitle: const Text('Enable 2FA for added security.'),
              onTap: () => _showTwoFactorDialog(context),
            ),
          ],
        ),
      ),
    );
  }
}
