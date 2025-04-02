import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shimmer/shimmer.dart';

import 'doctordetails.dart';

class DoctorsListPage extends StatefulWidget {
  const DoctorsListPage({super.key});

  @override
  _DoctorsListPageState createState() => _DoctorsListPageState();
}

class _DoctorsListPageState extends State<DoctorsListPage> {
  final String apiUrl = 'https://legit-backend-iqvk.onrender.com/doctors';
  final String imageUrl = 'https://legit-backend-iqvk.onrender.com/uploads/';

  List<dynamic> doctors = [];
  List<dynamic> filteredDoctors = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchDoctors();
  }

  Future<void> fetchDoctors() async {
    try {
      Response response = await Dio().get(apiUrl);
      if (response.statusCode == 200) {
        if (!mounted) return;
        setState(() {
          doctors = response.data;
          filteredDoctors = doctors; // Initialize filtered list
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load doctors");
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      print("❌ Error fetching doctors: $e");
    }
  }

  void filterDoctors(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredDoctors = doctors;
      });
      return;
    }

    setState(() {
      filteredDoctors = doctors
          .where((doctor) =>
              doctor['name'].toLowerCase().contains(query.toLowerCase()) ||
              doctor['specialization']
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Mental Health Experts",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.purple.shade300,
      ),
      body: RefreshIndicator(
        onRefresh: fetchDoctors,
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: searchController,
                onChanged: filterDoctors,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: "Search doctors...",
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

            // Doctors Grid View with Shimmer Effect
            Expanded(
              child: isLoading
                  ? _buildShimmerEffect()
                  : filteredDoctors.isEmpty
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
                            itemCount: filteredDoctors.length,
                            itemBuilder: (context, index) {
                              final doctor = filteredDoctors[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DoctorContactPage(
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
      ),
    );
  }

  // Improved Shimmer Effect for Loading State
  Widget _buildShimmerEffect() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: 6, // Show 6 placeholders while loading
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 80,
                    height: 10,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 5),
                  Container(
                    width: 100,
                    height: 10,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 5),
                  Container(
                    width: 60,
                    height: 10,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
