import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:tangullo/data/Journalizing.dart';
import 'package:tangullo/ui/views/journalizing/journalizing_viewmodel.dart';

class JournalizingView extends StatelessWidget {
  const JournalizingView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<JournalizingViewModel>.reactive(
      viewModelBuilder: () => JournalizingViewModel(),
      builder: (context, viewModel, child) => Scaffold(
        backgroundColor: Colors.blueGrey[50],
        appBar: AppBar(
          title: const Text(
            'My Journal',
            style: TextStyle(fontFamily: 'Pacifico', fontSize: 26),
          ),
          backgroundColor: Colors.teal[300],
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _showAddOrEditDialog(context, viewModel),
            ),
          ],
        ),
        body: StreamBuilder<List<JournalEntry>>(
          stream: viewModel.entries,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final entries = snapshot.data!;
            return ListView.builder(
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];
                return Card(
                  margin: const EdgeInsets.all(10.0),
                  color: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12.0),
                    title: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        entry.title,
                        style: TextStyle(
                          fontFamily: 'Serif',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal[800],
                        ),
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        entry.content,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () => _showDeleteConfirmation(
                          context, viewModel, entry.id!),
                    ),
                    onTap: () => _showDetailView(context, viewModel, entry),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _showAddOrEditDialog(
      BuildContext context, JournalizingViewModel viewModel,
      [JournalEntry? entry]) {
    final titleController = TextEditingController(text: entry?.title);
    final contentController = TextEditingController(text: entry?.content);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Text(entry == null ? 'New Journal Entry' : 'Edit Entry'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              style: const TextStyle(fontFamily: 'Serif', fontSize: 18),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(labelText: 'Content'),
              maxLines: 5,
              minLines: 3,
              style: const TextStyle(fontFamily: 'Serif', fontSize: 16),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal[300],
            ),
            onPressed: () {
              if (entry == null) {
                viewModel.addEntry(JournalEntry(
                  title: titleController.text,
                  content: contentController.text,
                  date: DateTime.now(),
                ));
              } else {
                viewModel.updateEntry(JournalEntry(
                  id: entry.id,
                  title: titleController.text,
                  content: contentController.text,
                  date: entry.date,
                ));
              }
              Navigator.pop(context);
            },
            child: Text(entry == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(
      BuildContext context, JournalizingViewModel viewModel, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this entry?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              viewModel.deleteEntry(id);
              Navigator.pop(context);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }

  void _showDetailView(BuildContext context, JournalizingViewModel viewModel,
      JournalEntry entry) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.blueGrey[50],
          appBar: AppBar(
            title: Text(
              entry.title,
              style: const TextStyle(fontFamily: 'Pacifico', fontSize: 24),
            ),
            backgroundColor: Colors.teal[300],
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () =>
                    _showAddOrEditDialog(context, viewModel, entry),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                onPressed: () =>
                    _showDeleteConfirmation(context, viewModel, entry.id!),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Date: ${entry.date.toLocal()}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.teal[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  entry.content,
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: 'Serif',
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
