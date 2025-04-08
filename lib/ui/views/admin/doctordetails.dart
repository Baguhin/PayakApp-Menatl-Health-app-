import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

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
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                imageUrl,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(Icons.person, size: 60, color: Colors.grey),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              specialization,
              style: TextStyle(
                color: Colors.purple.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star, size: 18, color: Colors.amber.shade600),
              const SizedBox(width: 4),
              Text(
                reviews,
                style: TextStyle(
                  color: Colors.amber.shade800,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Text(
                " Reviews",
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class DoctorContactPage extends StatefulWidget {
  final Map<String, dynamic> doctor;
  final String imageUrl;
  final Color primaryColor;
  final Color accentColor;

  const DoctorContactPage({
    super.key,
    required this.doctor,
    required this.imageUrl,
    required this.primaryColor,
    required this.accentColor,
  });

  @override
  State<DoctorContactPage> createState() => _DoctorContactPageState();
}

class _DoctorContactPageState extends State<DoctorContactPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _makePhoneCall(BuildContext context, String phoneNumber) async {
    final Uri url = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        _showSnackbar("Cannot launch phone call");
      }
    }
  }

  void _sendEmail(BuildContext context, String email) async {
    final Uri url = Uri.parse('mailto:$email');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        _showSnackbar("Cannot open email");
      }
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(12),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: widget.primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: widget.primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _bookAppointment() {
    if (_selectedDate == null || _selectedTime == null) {
      _showSnackbar("Please select both date and time for your appointment");
      return;
    }

    // Format the date and time for display
    final dateFormatter = DateFormat('EEEE, MMMM d, yyyy');
    final formattedDate = dateFormatter.format(_selectedDate!);
    final formattedTime = _selectedTime!.format(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Appointment Confirmation'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Doctor: ${widget.doctor['name']}'),
            const SizedBox(height: 8),
            Text('Date: $formattedDate'),
            const SizedBox(height: 4),
            Text('Time: $formattedTime'),
            const SizedBox(height: 16),
            const Text(
                'Your appointment has been scheduled. You will receive a confirmation soon.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 240,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  widget.doctor['name'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        offset: Offset(1, 1),
                        blurRadius: 3,
                        color: Color.fromRGBO(0, 0, 0, 0.5),
                      ),
                    ],
                  ),
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      widget.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: widget.primaryColor.withOpacity(0.8),
                        child: const Icon(Icons.person,
                            size: 100, color: Colors.white70),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              backgroundColor: widget.primaryColor,
            ),
          ];
        },
        body: Column(
          children: [
            const SizedBox(height: 16),
            // Doctor quick info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildInfoColumn(Icons.medical_services,
                      widget.doctor['specialization'], 'Specialist'),
                  _buildInfoColumn(
                      Icons.star, '${widget.doctor['rating']}', 'Rating'),
                  _buildInfoColumn(Icons.people,
                      '${widget.doctor['patients'] ?? "500+"}', 'Patients'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Tab Bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(25),
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey.shade700,
                indicator: BoxDecoration(
                  color: widget.primaryColor,
                  borderRadius: BorderRadius.circular(25),
                ),
                tabs: const [
                  Tab(text: 'About'),
                  Tab(text: 'Contact'),
                  Tab(text: 'Book'),
                ],
                padding: const EdgeInsets.all(5),
              ),
            ),

            // Tab Content - Now using Expanded for flexible sizing
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // About Tab - Each tab content is now in a SingleChildScrollView
                  SingleChildScrollView(
                    child: _buildAboutTab(),
                  ),

                  // Contact Tab
                  SingleChildScrollView(
                    child: _buildContactTab(),
                  ),

                  // Book Appointment Tab
                  SingleChildScrollView(
                    child: _buildBookingTab(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(IconData icon, String value, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: widget.primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: widget.primaryColor),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildAboutTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "About Doctor",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Text(
              widget.doctor['bio'] ??
                  "Dr. ${widget.doctor['name']} is a highly qualified ${widget.doctor['specialization']} with extensive experience in patient care. They are known for their excellent bedside manner and comprehensive approach to treatment.",
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Specializations",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var specialty in widget.doctor['specialties'] ??
                  [
                    widget.doctor['specialization'],
                    "General Consultation",
                    "Preventive Care"
                  ])
                Chip(
                  label: Text(specialty),
                  backgroundColor: widget.primaryColor.withOpacity(0.1),
                  labelStyle: TextStyle(color: widget.primaryColor),
                ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            "Education & Experience",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildExperienceItem(
                  "Medical University",
                  "MD in ${widget.doctor['specialization']}",
                  "2010 - 2014",
                ),
                const Divider(),
                _buildExperienceItem(
                  "City Hospital",
                  "Senior ${widget.doctor['specialization']}",
                  "2014 - Present",
                ),
              ],
            ),
          ),
          // Add padding at the bottom for better scrolling experience
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildExperienceItem(String title, String subtitle, String years) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.school,
            color: widget.primaryColor,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
          Text(
            years,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Contact Information",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.phone, color: Colors.blue),
                  ),
                  title: const Text("Phone"),
                  subtitle: Text(widget.doctor['phone'] ?? "Not available"),
                  trailing: IconButton(
                    icon: const Icon(Icons.call, color: Colors.blue),
                    onPressed: () =>
                        _makePhoneCall(context, widget.doctor['phone'] ?? ""),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.email, color: Colors.red),
                  ),
                  title: const Text("Email"),
                  subtitle: Text(widget.doctor['email'] ?? "Not available"),
                  trailing: IconButton(
                    icon: const Icon(Icons.send, color: Colors.red),
                    onPressed: () =>
                        _sendEmail(context, widget.doctor['email'] ?? ""),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.location_on, color: Colors.green),
                  ),
                  title: const Text("Address"),
                  subtitle:
                      Text(widget.doctor['address'] ?? "No address provided"),
                  trailing: IconButton(
                    icon: const Icon(Icons.map, color: Colors.green),
                    onPressed: () {
                      // Functionality to open map could be added here
                      _showSnackbar("Map view coming soon!");
                    },
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.access_time, color: Colors.purple),
                  ),
                  title: const Text("Working Hours"),
                  subtitle: const Text(
                      "Mon-Fri: 9:00 AM - 5:00 PM\nSat: 10:00 AM - 2:00 PM"),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Social Media",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSocialButton(Icons.language, Colors.blue),
              _buildSocialButton(Icons.facebook, Colors.indigo),
              _buildSocialButton(Icons.medical_services, Colors.red),
              _buildSocialButton(Icons.chat, Colors.green),
            ],
          ),
          // Add padding at the bottom for better scrolling experience
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, Color color) {
    return InkWell(
      onTap: () => _showSnackbar("Social media profile opening soon!"),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
          border: Border.all(color: color.withOpacity(0.3), width: 2),
        ),
        child: Icon(icon, color: color, size: 24),
      ),
    );
  }

  Widget _buildBookingTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Book Appointment",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Select Date
                const Text(
                  "Select Date",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () => _selectDate(context),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedDate == null
                              ? "Select a date"
                              : DateFormat('EEEE, MMMM d, yyyy')
                                  .format(_selectedDate!),
                          style: TextStyle(
                            color: _selectedDate == null
                                ? Colors.grey
                                : Colors.black,
                          ),
                        ),
                        Icon(
                          Icons.calendar_month,
                          color: widget.primaryColor,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Select Time
                const Text(
                  "Select Time",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () => _selectTime(context),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedTime == null
                              ? "Select a time"
                              : _selectedTime!.format(context),
                          style: TextStyle(
                            color: _selectedTime == null
                                ? Colors.grey
                                : Colors.black,
                          ),
                        ),
                        Icon(
                          Icons.access_time,
                          color: widget.primaryColor,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Appointment Type
                const Text(
                  "Appointment Type",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildAppointmentTypeButton(
                        "In Person",
                        Icons.person,
                        isSelected: true,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildAppointmentTypeButton(
                        "Video Call",
                        Icons.video_call,
                        isSelected: false,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Book Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _bookAppointment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.primaryColor,
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 24,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: const Text(
                      "Book Appointment",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Add padding at the bottom for better scrolling experience
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildAppointmentTypeButton(String text, IconData icon,
      {required bool isSelected}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: isSelected ? widget.primaryColor : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? widget.primaryColor : Colors.grey.shade300,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.white : Colors.grey.shade600,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey.shade800,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
