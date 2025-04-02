import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tangullo/ui/views/new_homepage/screens/patient_dashboard/doctor_appointment/components/category_card.dart';
import 'package:tangullo/ui/views/new_homepage/screens/patient_dashboard/doctor_appointment/components/doctor_card.dart';
import '../constant.dart';
import 'doctor_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<DoctorModel> doctors = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Doctor's Appointment",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.cyan,
        elevation: 1,
      ),
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 50),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'Find Your Desired\nDoctor',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: SearchBar(
                  hintText: "Search for a doctor...",
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'Categories',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              buildCategoryList(),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'Top Doctors',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              buildDoctorList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCategoryList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          const SizedBox(width: 30),
          CategoryCard(
            'Psychiatrist',
            'assets/icons/psychiatrist.png',
            kOrangeColor,
            'Psychiatrist',
          ),
          const SizedBox(width: 10),
          CategoryCard(
            'Dental\nSurgeon',
            'assets/icons/dental_surgeon.png',
            kBlueColor,
            'Dental',
          ),
          const SizedBox(width: 10),
          CategoryCard(
            'Heart\nSurgeon',
            'assets/icons/heart_surgeon.png',
            kYellowColor,
            'Heart Surgeon',
          ),
          const SizedBox(width: 10),
          CategoryCard(
            'Eye\nSpecialist',
            'assets/icons/eye_specialist.png',
            kOrangeColor,
            'Eye Specialist',
          ),
          const SizedBox(width: 30),
        ],
      ),
    );
  }

  Widget buildDoctorList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('userdata').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text("No doctors available."),
          );
        }

        doctors.clear();
        for (var element in snapshot.data!.docs) {
          try {
            if (element['type'] == "doctor") {
              doctors.add(DoctorModel(
                element.id,
                element['name'],
                element['specialization'],
                element['phone'],
                element['hospital'],
                element['about'],
              ));
            }
          } catch (e) {
            continue;
          }
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: (doctors.length <= 3) ? doctors.length : 3,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      DoctorCard(
                        doctors[index].uid,
                        doctors[index].displayName,
                        "${doctors[index].specialization} - ${doctors[index].hospital}",
                        (index % 2 == 0) ? kBlueColor : kYellowColor,
                        doctors[index].bio,
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                },
              ),
              const SizedBox(height: 80),
            ],
          ),
        );
      },
    );
  }
}
