// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tangullo/theme/colors.dart';
import 'package:tangullo/widgets/avatar_image.dart';
import 'package:tangullo/widgets/contact_box.dart';
import 'package:tangullo/widgets/mybutton.dart';
import 'package:url_launcher/url_launcher.dart';

class DoctorProfilePage extends StatefulWidget {
  final Map<String, Object> doctor;

  const DoctorProfilePage({Key? key, required this.doctor}) : super(key: key);

  @override
  _DoctorProfilePageState createState() => _DoctorProfilePageState();
}

class _DoctorProfilePageState extends State<DoctorProfilePage> {
  late Map<String, Object> doctorData;

  @override
  void initState() {
    super.initState();
    doctorData = widget.doctor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Doctor's Profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
      body: getBody(),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: MyButton(
          disableButton: false,
          bgColor: primary,
          title: "Book Appointment",
          onTap: () {
            _requestAppointment();
          },
          borderRadius: BorderRadius.circular(15),
          gradient: const LinearGradient(
            colors: [Colors.blue, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          elevation: 5,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget getBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Info
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctorData['name'].toString(),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        doctorData['skill'].toString(),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  AvatarImage(
                    doctorData['image'].toString(),
                    radius: 15,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 10,
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5)
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Availability Information
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 2,
            child: const Padding(
              padding: EdgeInsets.all(15),
              child: Row(
                children: [
                  Icon(Icons.access_time, color: Colors.green),
                  SizedBox(width: 8),
                  Text("Available Hours: 8:00 am - 5:00 pm",
                      style: TextStyle(fontSize: 15, color: Colors.black87)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Star Rating
          buildStarRating(),
          const SizedBox(height: 10),
          Text(
            "${doctorData['review']} Patients reviewed",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Text("Successful Cases: ${doctorData['successful_patients']}",
              style: const TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 10),
          Text("Experience: ${doctorData['experience']}",
              style: const TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 30),
          // Location Information
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.blue, size: 20),
              const SizedBox(width: 5),
              Text("Location: ${doctorData['location']}",
                  style: const TextStyle(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 20),
          // Phone Information
          Row(
            children: [
              const Icon(Icons.phone, color: Colors.green, size: 20),
              const SizedBox(width: 5),
              Text("Phone: ${doctorData['phone']}",
                  style: const TextStyle(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 30),
          // Contact Options
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ContactBox(
                icon: Icons.videocam_rounded,
                color: Colors.blue,
                onTap: () {
                  // Video call action here
                },
              ),
              ContactBox(
                icon: Icons.call,
                color: Colors.green,
                onTap: () {
                  _makePhoneCall(doctorData['phone'].toString());
                },
              ),
              ContactBox(
                icon: Icons.message,
                color: Colors.orange,
                onTap: () {
                  // Message action here
                },
              ),
            ],
          ),
        ],
      ),
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

  void _requestAppointment() {
    // Implement appointment request logic here
  }

  Widget buildStarRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return Icon(
          Icons.star,
          color: index < 4 ? Colors.amber : Colors.grey.shade400,
          size: 24,
        );
      }),
    );
  }
}
