import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'therapist_viewmodel.dart';

class TherapistView extends StackedView<TherapistViewModel> {
  const TherapistView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    TherapistViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Therapists'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent, // Set your theme color
      ),
      body: viewModel.isBusy
          ? const Center(child: CircularProgressIndicator())
          : viewModel.therapists.isEmpty
              ? const Center(child: Text('No therapists available.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: viewModel.therapists.length,
                  itemBuilder: (context, index) {
                    final therapist = viewModel.therapists[index];
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16.0),
                        title: Text(
                          therapist.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          '${therapist.location} • ${therapist.specialty}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.info),
                          onPressed: () {
                            // Implement action for additional details
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  @override
  TherapistViewModel viewModelBuilder(BuildContext context) =>
      TherapistViewModel();

  @override
  void onModelReady(TherapistViewModel viewModel) {
    viewModel.fetchTherapists();
  }
}
