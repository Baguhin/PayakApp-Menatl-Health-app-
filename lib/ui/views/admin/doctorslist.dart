import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class DoctorsListPage extends StatefulWidget {
  const DoctorsListPage({super.key});

  @override
  _DoctorsListPageState createState() => _DoctorsListPageState();
}

class _DoctorsListPageState extends State<DoctorsListPage> {
  final String apiUrl = 'http://192.168.43.161:5000/doctors'; // Update IP
  final String imageUrl = 'http://192.168.43.161:5000/uploads/';
  List<dynamic> doctors = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDoctors();
  }

  Future<void> fetchDoctors() async {
    try {
      Response response = await Dio().get(apiUrl);
      if (response.statusCode == 200) {
        if (!mounted) return; // Prevent setState() if widget is disposed
        setState(() {
          doctors = response.data;
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load doctors");
      }
    } catch (e) {
      if (!mounted) return; // Prevent setState() if widget is disposed
      setState(() {
        isLoading = false;
      });
      print("❌ Error fetching doctors: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false, // Removes back button
        title: const Text(
          "Mental Health Trained Person",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.purple.shade300,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Search",
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Title
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Available Mental Health Experts",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
            ),
          ),

          // Doctors Grid View
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : doctors.isEmpty
                    ? const Center(child: Text("No doctors available"))
                    : Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // Two cards per row
                            childAspectRatio: 0.8,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: doctors.length,
                          itemBuilder: (context, index) {
                            final doctor = doctors[index];
                            return GestureDetector(
                              onTap: () {
                                // Navigate to Doctor Details Page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DoctorDetailsPage(
                                      doctor: doctor,
                                      imageUrl: '$imageUrl${doctor['image']}',
                                    ),
                                  ),
                                );
                              },
                              child: DoctorCard(
                                name: doctor['name'],
                                specialization: doctor['specialization'],
                                imageUrl: '$imageUrl${doctor['image']}',
                                reviews: doctor['reviews'] ?? "0",
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}

// Doctor Card Widget
class DoctorCard extends StatelessWidget {
  final String name;
  final String specialization;
  final String imageUrl;
  final String reviews;

  const DoctorCard({
    super.key,
    required this.name,
    required this.specialization,
    required this.imageUrl,
    required this.reviews,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              imageUrl,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 100),
            ),
          ),
          const SizedBox(height: 10),
          Text(name,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text(specialization, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 5),
          Text("⭐ $reviews Review",
              style: const TextStyle(color: Colors.orange)),
        ],
      ),
    );
  }
}

class DoctorDetailsPage extends StatelessWidget {
  final Map<String, dynamic> doctor;
  final String imageUrl;

  const DoctorDetailsPage({
    super.key,
    required this.doctor,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Doctor Details"),
        backgroundColor: Colors.purple.shade300,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  imageUrl,
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, size: 150),
                ),
              ),
              const SizedBox(height: 20),

              // Doctor Name
              Text(
                doctor['name'],
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              // Specialization
              Text(
                doctor['specialization'],
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),

              const SizedBox(height: 10),

              // Reviews & Rating
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star, color: Colors.orange, size: 24),
                  Text(
                    " ${doctor['rating']} / 5.0",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              const Divider(),

              // Contact Information
              const SizedBox(height: 10),
              const Text(
                "Contact Information",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),

              // Phone
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.phone, color: Colors.blue),
                  const SizedBox(width: 5),
                  Text(
                    doctor['phone'] ?? "Not available",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),

              const SizedBox(height: 5),

              // Email
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.email, color: Colors.red),
                  const SizedBox(width: 5),
                  Text(
                    doctor['email'] ?? "Not available",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),

              const SizedBox(height: 5),

              // Address
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_on, color: Colors.green),
                  const SizedBox(width: 5),
                  Flexible(
                    child: Text(
                      doctor['address'] ?? "No address provided",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              const Divider(),

              // About Doctor
              const SizedBox(height: 10),
              const Text(
                "About Doctor",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(
                doctor['bio'] ?? "No information available.",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),

              const SizedBox(height: 20),

              // Book Appointment Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple.shade300,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Feature coming soon!")),
                  );
                },
                child: const Text("Book Appointment",
                    style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
