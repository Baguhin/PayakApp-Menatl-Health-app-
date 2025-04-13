import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SeminarDetailPage extends StatefulWidget {
  final String seminarId;

  const SeminarDetailPage({
    Key? key,
    required this.seminarId,
  }) : super(key: key);

  @override
  _SeminarDetailPageState createState() => _SeminarDetailPageState();
}

class _SeminarDetailPageState extends State<SeminarDetailPage> {
  bool isLoading = true;
  Map<String, dynamic>? seminar;
  List<Map<String, dynamic>> supportOptions = [];
  bool isRegistered = false;
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    fetchSeminarDetails();
  }

  Future<void> fetchSeminarDetails() async {
    try {
      setState(() {
        isLoading = true;
      });

      // Fetch seminar details
      final response = await supabase
          .from('seminars')
          .select()
          .eq('id', widget.seminarId)
          .single();

      // Fetch support options
      final supportOptionsResponse = await supabase
          .from('seminar_support_options')
          .select()
          .eq('seminar_id', widget.seminarId);

      // Check if user is registered
      final userId = '1'; // Replace with actual user ID from your auth system
      final registrationResponse = await supabase
          .from('seminar_registrations')
          .select()
          .eq('user_id', userId)
          .eq('seminar_id', widget.seminarId);

      setState(() {
        seminar = response;
        supportOptions =
            List<Map<String, dynamic>>.from(supportOptionsResponse);
        isRegistered = registrationResponse.isNotEmpty;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Failed to load seminar details: ${e.toString()}')),
      );
    }
  }

  Future<void> registerForSeminar() async {
    try {
      final userId = '1'; // Replace with actual user ID from your auth system

      // Register user using Supabase stored procedure
      await supabase.rpc('register_for_seminar',
          params: {'p_user_id': userId, 'p_seminar_id': widget.seminarId});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful!')),
      );
      fetchSeminarDetails(); // Refresh the data
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Future<void> cancelRegistration() async {
    try {
      final userId = '1'; // Replace with actual user ID from your auth system

      // Cancel registration using Supabase stored procedure
      await supabase.rpc('cancel_seminar_registration',
          params: {'p_user_id': userId, 'p_seminar_id': widget.seminarId});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration cancelled successfully!')),
      );
      fetchSeminarDetails(); // Refresh the data
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLoading ? 'Seminar Details' : seminar?['title'] ?? ''),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : seminar == null
              ? const Center(child: Text('Seminar not found'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title Section
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        width: double.infinity,
                        child: Text(
                          seminar!['title'],
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Description
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        seminar!['description'],
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),

                      // Details Grid
                      const Text(
                        'Seminar Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              _buildDetailRow(Icons.calendar_today, 'Date',
                                  seminar!['date']),
                              const Divider(),
                              _buildDetailRow(
                                  Icons.access_time, 'Time', seminar!['time']),
                              const Divider(),
                              _buildDetailRow(
                                  Icons.hourglass_bottom,
                                  'Duration',
                                  '${seminar!['duration']} minutes'),
                              const Divider(),
                              _buildDetailRow(Icons.person, 'Instructor',
                                  seminar!['instructor']),
                              const Divider(),
                              _buildDetailRow(
                                  Icons.category, 'Topic', seminar!['topic']),
                              const Divider(),
                              _buildDetailRow(Icons.location_on, 'Location',
                                  seminar!['location']),
                              const Divider(),
                              _buildDetailRow(
                                  Icons.person_outline,
                                  'Participants',
                                  '${seminar!['current_participants']}/${seminar!['capacity']}'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Additional Information
                      if (seminar!['qualifications']?.isNotEmpty == true) ...[
                        const Text(
                          'Instructor Qualifications',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          seminar!['qualifications'],
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 20),
                      ],

                      if (seminar!['target_audience']?.isNotEmpty == true) ...[
                        const Text(
                          'Target Audience',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          seminar!['target_audience'],
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // Support Options
                      if (supportOptions.isNotEmpty) ...[
                        const Text(
                          'Support Options',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Card(
                          elevation: 2,
                          child: ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: supportOptions.length,
                            separatorBuilder: (_, __) => const Divider(),
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: const Icon(Icons.check_circle,
                                    color: Colors.green),
                                title:
                                    Text(supportOptions[index]['option_name']),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // Resources
                      if (seminar!['provides_resources'] == true) ...[
                        const Text(
                          'Resources',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          seminar!['resources'] ??
                              'Resources will be provided at the seminar.',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // Certificate
                      if (seminar!['offers_certificate'] == true) ...[
                        const Row(
                          children: [
                            Icon(Icons.workspace_premium, color: Colors.amber),
                            SizedBox(width: 8),
                            Text(
                              'Certificate of Completion Available',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],

                      // Action Buttons
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            backgroundColor: isRegistered
                                ? Colors.red
                                : Theme.of(context).primaryColor,
                          ),
                          onPressed: seminar!['current_participants'] >=
                                      seminar!['capacity'] &&
                                  !isRegistered
                              ? null
                              : isRegistered
                                  ? cancelRegistration
                                  : registerForSeminar,
                          child: Text(
                            isRegistered
                                ? 'Cancel Registration'
                                : seminar!['current_participants'] >=
                                        seminar!['capacity']
                                    ? 'Seminar Full'
                                    : 'Register Now',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[700]),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[800],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
