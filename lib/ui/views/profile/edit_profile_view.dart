// ignore_for_file: library_private_types_in_public_api, deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfileView extends StatefulWidget {
  final String? currentDisplayName;
  final String? currentEmail;
  final String? currentPhone;
  final String? currentLocation;
  final String? currentBio;

  const EditProfileView({
    Key? key,
    this.currentDisplayName,
    this.currentEmail,
    this.currentPhone,
    this.currentLocation,
    this.currentBio,
  }) : super(key: key);

  @override
  _EditProfileViewState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _formKey = GlobalKey<FormState>();
  late String _displayName, _email, _phone, _location, _bio;

  @override
  void initState() {
    super.initState();
    _displayName = widget.currentDisplayName ?? '';
    _email = widget.currentEmail ?? '';
    _phone = widget.currentPhone ?? '';
    _location = widget.currentLocation ?? '';
    _bio = widget.currentBio ?? '';
  }

  Future<void> _updateProfile() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Update user display name and email
      await user.updateProfile(displayName: _displayName);
      await user.updateEmail(_email);

      // Update additional fields in Firestore
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'displayName': _displayName,
        'email': _email,
        'phone': _phone,
        'location': _location,
        'bio': _bio,
      }, SetOptions(merge: true));

      // Reload user data to ensure updates are reflected
      await user.reload();
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Edit Profile'),
          backgroundColor: const Color(0xFF6BBF9B)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                  initialValue: _displayName,
                  decoration: const InputDecoration(labelText: 'Display Name'),
                  onChanged: (value) => _displayName = value),
              TextFormField(
                  initialValue: _email,
                  decoration: const InputDecoration(labelText: 'Email'),
                  onChanged: (value) => _email = value,
                  validator: (value) => value != null && value.contains('@')
                      ? null
                      : 'Enter a valid email'),
              TextFormField(
                  initialValue: _phone,
                  decoration: const InputDecoration(labelText: 'Phone'),
                  onChanged: (value) => _phone = value),
              TextFormField(
                  initialValue: _location,
                  decoration: const InputDecoration(labelText: 'Location'),
                  onChanged: (value) => _location = value),
              TextFormField(
                  initialValue: _bio,
                  decoration: const InputDecoration(labelText: 'Bio'),
                  onChanged: (value) => _bio = value),
              const SizedBox(height: 20.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _updateProfile();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6BBF9B)),
                  child: const Text('Save Changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
