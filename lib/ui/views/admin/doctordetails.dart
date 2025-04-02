import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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

class DoctorContactPage extends StatelessWidget {
  final Map<String, dynamic> doctor;
  final String imageUrl;

  const DoctorContactPage(
      {super.key, required this.doctor, required this.imageUrl});

  void _makePhoneCall(BuildContext context, String phoneNumber) async {
    final Uri url = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cannot launch phone call")),
      );
    }
  }

  void _sendEmail(BuildContext context, String email) async {
    final Uri url = Uri.parse('mailto:$email');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cannot open email")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Doctor Details"),
        backgroundColor: Colors.purple.shade300,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              elevation: 5,
              child: ClipRRect(
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
            ),
            const SizedBox(height: 20),

            // Doctor Name & Specialization
            Text(
              doctor['name'],
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              doctor['specialization'],
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),

            const SizedBox(height: 10),

            // Ratings
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star, color: Colors.orange, size: 24),
                Text(" ${doctor['rating']} / 5.0",
                    style: const TextStyle(fontSize: 16)),
              ],
            ),

            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),

            // Contact Information
            const Text("Contact Information",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),

            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.phone, color: Colors.blue),
                      title: Text(doctor['phone'] ?? "Not available"),
                      onTap: () =>
                          _makePhoneCall(context, doctor['phone'] ?? ""),
                    ),
                    ListTile(
                      leading: const Icon(Icons.email, color: Colors.red),
                      title: Text(doctor['email'] ?? "Not available"),
                      onTap: () => _sendEmail(context, doctor['email'] ?? ""),
                    ),
                    ListTile(
                      leading:
                          const Icon(Icons.location_on, color: Colors.green),
                      title: Text(doctor['address'] ?? "No address provided"),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),

            // About Doctor
            const Text("About Doctor",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
    );
  }
}
