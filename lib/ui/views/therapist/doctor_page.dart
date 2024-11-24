// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:tangullo/data/json.dart';
import 'package:tangullo/theme/colors.dart';
import 'package:tangullo/ui/views/pages/doctor_profile_page.dart';
import 'package:tangullo/widgets/doctor_box.dart';
import 'package:tangullo/widgets/textbox.dart';

class DoctorPage extends StatefulWidget {
  const DoctorPage({Key? key}) : super(key: key);

  @override
  _DoctorPageState createState() => _DoctorPageState();
}

class _DoctorPageState extends State<DoctorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBgColor,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(171, 88, 86, 214),
        elevation: 0,
        title: const Text(
          "Mental Health Trained Person",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(
              Icons.info,
              color: Colors.grey,
            ),
          )
        ],
      ),
      body: getBody(),
    );
  }

  getBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20), // Added space before search/filter
            const Row(
              children: [
                Expanded(child: CustomTextBox()),
                SizedBox(width: 10), // Increased spacing
                Icon(
                  Icons.filter_list_rounded,
                  color: primary,
                  size: 35,
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "Available Mental Health",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: primary, // Use your primary color for headings
              ),
            ),
            const SizedBox(height: 10), // Space after heading
            getDoctorList(),
          ],
        ),
      ),
    );
  }

  getDoctorList() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 10, // Space between columns
        mainAxisSpacing: 10, // Space between rows
      ),
      itemCount: doctors.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          // Added Card widget for elevation
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: DoctorBox(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        DoctorProfilePage(doctor: doctors[index])),
              );
            },
            index: index,
            doctor: doctors[index],
          ),
        );
      },
    );
  }
}
