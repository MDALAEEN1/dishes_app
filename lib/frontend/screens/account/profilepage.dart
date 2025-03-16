import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  String _name = '';
  String _email = '';
  String _phone = '';
  String _address = ''; // حقل العنوان الجديد
  bool _isEditing = false;
  bool _isLoading = true;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController(); // تحكم في العنوان

  // Fetch user data from Firebase
  Future<void> _getUserData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      User? user = _auth.currentUser;

      if (user != null) {
        _email = user.email ?? '';
        DocumentSnapshot userData =
            await _firestore.collection('users').doc(user.uid).get();

        if (userData.exists) {
          setState(() {
            _name = userData['username'] ?? '';
            _phone = userData['phone'] ?? '';
            _address = userData['address'] ?? ''; // جلب العنوان
            _nameController.text = _name;
            _emailController.text = _email;
            _phoneController.text = _phone;
            _addressController.text =
                _address; // تعيين العنوان إلى الـ TextEditingController
          });
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Update user data in Firebase
  Future<void> _updateUserData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      User? user = _auth.currentUser;

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'username': _nameController.text,
          'phone': _phoneController.text,
          'address': _addressController.text, // إضافة العنوان إلى التحديث
        });

        setState(() {
          _name = _nameController.text;
          _phone = _phoneController.text;
          _address = _addressController.text; // تحديث العنوان
          _email = _emailController.text;
          _isEditing = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      }
    } catch (e) {
      print('Error updating user data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update profile')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.blueAccent,
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
            )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_isEditing)
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                    )
                  else
                    Text(
                      'Name: $_name',
                      style: const TextStyle(fontSize: 16),
                    ),
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),
                  Text(
                    'Email: $_email',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),
                  if (_isEditing)
                    TextField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone',
                        border: OutlineInputBorder(),
                      ),
                    )
                  else
                    Text(
                      'Phone: $_phone',
                      style: const TextStyle(fontSize: 16),
                    ),
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),
                  if (_isEditing)
                    TextField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        labelText: 'Address',
                        border: OutlineInputBorder(),
                      ),
                    )
                  else
                    Text(
                      'Address: $_address', // عرض العنوان
                      style: const TextStyle(fontSize: 16),
                    ),
                  const SizedBox(height: 24),
                  if (_isEditing)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: _updateUserData,
                          child: const Text('Save'),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isEditing = false;
                              _nameController.text = _name;
                              _phoneController.text = _phone;
                              _addressController.text = _address;
                              _emailController.text = _email;
                            });
                          },
                          child: const Text('Cancel'),
                        ),
                      ],
                    ),
                ],
              ),
            ),
    );
  }
}
