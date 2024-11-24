// ignore_for_file: deprecated_member_use

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class AdminManagementView extends StatelessWidget {
  const AdminManagementView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AdminManagementViewModel>.reactive(
      viewModelBuilder: () => AdminManagementViewModel(),
      onModelReady: (model) => model.fetchPendingRequests(),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Admin Management'),
            backgroundColor: Colors.teal.shade400,
          ),
          body: model.isBusy
              ? const Center(child: CircularProgressIndicator())
              : model.pendingRequests.isEmpty
                  ? const Center(
                      child: Text('No pending requests',
                          style: TextStyle(
                              fontSize: 18, fontStyle: FontStyle.italic)))
                  : ListView.builder(
                      itemCount: model.pendingRequests.length,
                      itemBuilder: (context, index) {
                        final request = model.pendingRequests[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.teal.shade200,
                              child:
                                  const Icon(Icons.person, color: Colors.white),
                            ),
                            title: Text(request['displayName'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            subtitle: Text(request['email']),
                            trailing: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.teal, // Background color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                model.approveRequest(request['uid']);
                              },
                              child: const Text('Approve'),
                            ),
                          ),
                        );
                      },
                    ),
        );
      },
    );
  }
}

class AdminManagementViewModel extends BaseViewModel {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  List<Map<dynamic, dynamic>> pendingRequests = [];

  Future<void> fetchPendingRequests() async {
    setBusy(true);
    try {
      final snapshot = await _database.child('pending_admin_requests').get();
      if (snapshot.exists && snapshot.value is Map) {
        pendingRequests = (snapshot.value as Map).entries.map((entry) {
          return {'uid': entry.key, ...entry.value as Map};
        }).toList();
      } else {
        pendingRequests = [];
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching pending requests: $e');
      }
      pendingRequests = [];
    } finally {
      setBusy(false);
    }
  }

  Future<void> approveRequest(String uid) async {
    setBusy(true);
    try {
      await _database.child('users').child(uid).update({
        'isEnabled': true,
        'isVerified': true,
      });
      await _database.child('pending_admin_requests').child(uid).remove();
      await fetchPendingRequests();
    } catch (e) {
      if (kDebugMode) {
        print('Error approving request: $e');
      }
    } finally {
      setBusy(false);
    }
  }
}
