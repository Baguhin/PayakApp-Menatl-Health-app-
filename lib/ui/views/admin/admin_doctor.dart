import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class AdminDoctorPage extends StatefulWidget {
  const AdminDoctorPage({super.key});

  @override
  _AdminDoctorPageState createState() => _AdminDoctorPageState();
}

class _AdminDoctorPageState extends State<AdminDoctorPage> {
  List doctors = [];
  bool isLoading = true;
  final Dio dio = Dio();
  final String apiUrl = 'https://legit-backend-iqvk.onrender.com/doctors';
  final TextEditingController searchController = TextEditingController();
  List filteredDoctors = [];
  String selectedSpecialty = 'All';
  List<String> specialties = ['All'];
  bool isGridView = false;

  @override
  void initState() {
    super.initState();
    fetchDoctors();
    searchController.addListener(filterDoctors);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> fetchDoctors() async {
    setState(() => isLoading = true);
    try {
      final response = await dio.get(apiUrl);

      // Extract unique specialties for filter
      final specialtySet = <String>{'All'};
      for (final doctor in response.data) {
        if (doctor['specialization'] != null) {
          specialtySet.add(doctor['specialization']);
        }
      }

      setState(() {
        doctors = response.data;
        filteredDoctors = response.data;
        specialties = specialtySet.toList()..sort();
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching doctors: $e");
      setState(() => isLoading = false);
      _showErrorSnackBar("Failed to load doctors. Pull down to retry.");
    }
  }

  void filterDoctors() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredDoctors = doctors.where((doctor) {
        final matchesSearch = doctor['name'].toLowerCase().contains(query) ||
            doctor['specialization'].toLowerCase().contains(query);
        final matchesSpecialty = selectedSpecialty == 'All' ||
            doctor['specialization'] == selectedSpecialty;
        return matchesSearch && matchesSpecialty;
      }).toList();
    });
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> deleteDoctor(int id) async {
    try {
      await dio.delete('$apiUrl/$id');
      setState(() {
        doctors.removeWhere((doctor) => doctor['id'] == id);
        filterDoctors(); // Update filtered list too
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Doctor deleted successfully"),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'UNDO',
            textColor: Colors.white,
            onPressed: () {
              // In a real app, you would implement undo functionality here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text("Undo is not implemented in this demo")),
              );
            },
          ),
        ),
      );
    } catch (e) {
      print("Error deleting doctor: $e");
      _showErrorSnackBar("Failed to delete doctor");
    }
  }

  void confirmDelete(int id, String doctorName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text("Delete Doctor",
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text("Are you sure you want to delete Dr. $doctorName?"),
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

  void navigateToEditDoctor(Map<String, dynamic> doctor) {
    // In a real app, you would navigate to an edit page
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Edit functionality would open here")),
    );
  }

  void navigateToAddDoctor() {
    // In a real app, you would navigate to an add doctor page
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Add doctor functionality would open here")),
    );
  }

  void navigateToDoctorDetails(Map<String, dynamic> doctor) {
    // In a real app, you would navigate to a detail page
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Viewing details for Dr. ${doctor['name']}")),
    );
  }

  Widget _buildListItem(Map<String, dynamic> doctor) {
    return Slidable(
      key: ValueKey(doctor['id']),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => navigateToEditDoctor(doctor),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
          ),
          SlidableAction(
            onPressed: (_) => confirmDelete(doctor['id'], doctor['name']),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: () => navigateToDoctorDetails(doctor),
          borderRadius: BorderRadius.circular(12),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: Hero(
              tag: 'doctor-${doctor['id']}',
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey[200],
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl:
                        'http://yourserver.com/uploads/${doctor['image']}',
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.grey[400],
                    ),
                    fit: BoxFit.cover,
                    width: 60,
                    height: 60,
                  ),
                ),
              ),
            ),
            title: Text(
              doctor['name'],
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  doctor['specialization'],
                  style: TextStyle(
                      color: Colors.blue[700], fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                if (doctor['email'] != null)
                  Text(
                    doctor['email'],
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
              ],
            ),
            trailing: const Icon(Icons.chevron_right),
          ),
        ),
      ),
    );
  }

  Widget _buildGridItem(Map<String, dynamic> doctor) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => navigateToDoctorDetails(doctor),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: CachedNetworkImage(
                imageUrl: 'http://yourserver.com/uploads/${doctor['image']}',
                placeholder: (context, url) => const SizedBox(
                  height: 120,
                  child: Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 120,
                  color: Colors.grey[200],
                  child: Icon(Icons.person, size: 60, color: Colors.grey[400]),
                ),
                fit: BoxFit.cover,
                height: 120,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    doctor['name'],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    doctor['specialization'],
                    style: TextStyle(color: Colors.blue[700], fontSize: 14),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => navigateToEditDoctor(doctor),
                        tooltip: 'Edit',
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(8),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () =>
                            confirmDelete(doctor['id'], doctor['name']),
                        tooltip: 'Delete',
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(8),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search doctors...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedSpecialty,
                    decoration: InputDecoration(
                      labelText: 'Specialty',
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                    ),
                    items: specialties.map((specialty) {
                      return DropdownMenuItem(
                        value: specialty,
                        child: Text(specialty),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedSpecialty = value;
                        });
                        filterDoctors();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: Icon(isGridView ? Icons.list : Icons.grid_view),
                  onPressed: () => setState(() => isGridView = !isGridView),
                  tooltip: isGridView
                      ? 'Switch to List View'
                      : 'Switch to Grid View',
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    foregroundColor: Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        ),
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
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchDoctors,
            tooltip: 'Refresh',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAddDoctor,
        icon: const Icon(Icons.add),
        label: const Text('Add Doctor'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          _buildSearchAndFilter(),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredDoctors.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off,
                                size: 64, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              'No doctors found',
                              style: TextStyle(
                                  fontSize: 18, color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 8),
                            TextButton.icon(
                              onPressed: () {
                                searchController.clear();
                                setState(() {
                                  selectedSpecialty = 'All';
                                });
                                filterDoctors();
                              },
                              icon: const Icon(Icons.refresh),
                              label: const Text('Clear filters'),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: fetchDoctors,
                        child: isGridView
                            ? GridView.builder(
                                padding: const EdgeInsets.all(16),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.75,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                ),
                                itemCount: filteredDoctors.length,
                                itemBuilder: (context, index) {
                                  return _buildGridItem(filteredDoctors[index]);
                                },
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.all(16),
                                itemCount: filteredDoctors.length,
                                itemBuilder: (context, index) {
                                  return _buildListItem(filteredDoctors[index]);
                                },
                              ),
                      ),
          ),
        ],
      ),
    );
  }
}
