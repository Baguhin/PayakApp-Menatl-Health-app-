import 'package:stacked/stacked.dart';
import 'package:tangullo/services/firestore.dart';
import 'package:tangullo/data/Journalizing.dart';

class JournalizingViewModel extends BaseViewModel {
  final FirestoreService _firestoreService = FirestoreService();

  Stream<List<JournalEntry>> get entries =>
      _firestoreService.getJournalEntries();

  Future<void> addEntry(JournalEntry entry) async {
    await _firestoreService.createJournalEntry(entry);
    notifyListeners();
  }

  Future<void> updateEntry(JournalEntry entry) async {
    await _firestoreService.updateJournalEntry(entry);
    notifyListeners();
  }

  Future<void> deleteEntry(String id) async {
    await _firestoreService.deleteJournalEntry(id);
    notifyListeners();
  }
}
