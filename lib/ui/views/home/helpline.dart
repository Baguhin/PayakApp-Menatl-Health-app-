// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Helpline extends StatefulWidget {
  const Helpline({super.key});

  @override
  _HelplineState createState() => _HelplineState();
}

class _HelplineState extends State<Helpline> {
  List<Map<String, String>> emergencyContacts = [];

  @override
  void initState() {
    super.initState();
    _loadContacts(); // Load contacts when the widget is initialized
  }

  // Method to load contacts from SharedPreferences
  Future<void> _loadContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedContacts = prefs.getString('emergencyContacts');
    if (savedContacts != null) {
      // Decode the JSON string and cast it correctly
      List<dynamic> decodedList = json.decode(savedContacts);
      setState(() {
        emergencyContacts = decodedList.map((item) {
          return Map<String, String>.from(item);
        }).toList();
      });
    }
  }

  // Method to save contacts to SharedPreferences
  Future<void> _saveContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('emergencyContacts', json.encode(emergencyContacts));
  }

  void _addContact() {
    String? contactName;
    String? contactPhone;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: const Text(
            'Add Emergency Contact',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  contactName = value;
                },
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                onChanged: (value) {
                  contactPhone = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onPressed: () {
                // Check if contactName or contactPhone is empty
                if (contactName == null ||
                    contactName!.isEmpty ||
                    contactPhone == null ||
                    contactPhone!.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill up all fields!'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return; // Do not proceed with adding the contact
                }

                setState(() {
                  // Check for duplicates before adding
                  if (!emergencyContacts
                      .any((contact) => contact['phone'] == contactPhone)) {
                    emergencyContacts.add({
                      'name': contactName!,
                      'phone': contactPhone!,
                    });
                    _saveContacts(); // Save contacts after adding
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Contact already exists!')),
                    );
                  }
                });

                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _makePhoneCall(String phoneNumber) async {
    final Uri callUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      if (kDebugMode) {
        print('Could not launch $phoneNumber');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Failed to make a call. Please check your device settings.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Helper'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addContact, // Trigger the add contact method
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: emergencyContacts.isEmpty
            ? const Center(
                child: Text(
                  'No emergency contacts added yet. Tap "+" to add a contact.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.grey,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: emergencyContacts.length,
                itemBuilder: (context, index) {
                  final contact = emergencyContacts[index];
                  return Card(
                    elevation: 4.0,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ListTile(
                      leading: IconButton(
                        icon: const Icon(Icons.call, color: Colors.teal),
                        onPressed: () {
                          _makePhoneCall(contact['phone']!);
                        },
                      ),
                      title: Text(
                        contact['name']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      subtitle: Text(
                        contact['phone']!,
                        style: const TextStyle(fontSize: 14.0),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            emergencyContacts.removeAt(index);
                            _saveContacts(); // Save contacts after removing
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
