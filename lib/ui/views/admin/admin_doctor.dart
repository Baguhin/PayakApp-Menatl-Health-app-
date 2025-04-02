import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class AdminDoctorPage extends StatefulWidget {
  const AdminDoctorPage({super.key});

  @override
  _AdminDoctorPageState createState() => _AdminDoctorPageState();
}

class _AdminDoctorPageState extends State<AdminDoctorPage> {
  List doctors = [];
  bool isLoading = true;
  final Dio dio = Dio();
  final String apiUrl =
      'https://legit-backend-iqvk.onrender.com/doctors'; // Replace with your actual API URL

  @override
  void initState() {
    super.initState();
    fetchDoctors();
  }

  Future<void> fetchDoctors() async {
    try {
      final response = await dio.get(apiUrl);
      setState(() {
        doctors = response.data;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching doctors: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> deleteDoctor(int id) async {
    try {
      await dio.delete('$apiUrl/$id');
      setState(() {
        doctors.removeWhere((doctor) => doctor['id'] == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Doctor deleted successfully")),
      );
    } catch (e) {
      print("Error deleting doctor: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to delete doctor")),
      );
    }
  }

  void confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text("Delete Doctor",
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text("Are you sure you want to delete this doctor?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              deleteDoctor(id);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Doctors",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: fetchDoctors,
              child: ListView.builder(
                itemCount: doctors.length,
                itemBuilder: (context, index) {
                  final doctor = doctors[index];
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(10),
                        leading: Hero(
                          tag: doctor['id'],
                          child: CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(
                              'http://yourserver.com/uploads/${doctor['image']}',
                            ),
                          ),
                        ),
                        title: Text(
                          doctor['name'],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        subtitle: Text(doctor['specialization'],
                            style: TextStyle(color: Colors.grey[600])),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => confirmDelete(doctor['id']),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
