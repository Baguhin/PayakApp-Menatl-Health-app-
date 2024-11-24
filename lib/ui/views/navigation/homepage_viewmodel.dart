import 'package:stacked/stacked.dart';

class HomepageViewModel extends BaseViewModel {
  int _currentTabIndex = 0;
  bool _isLoading = false; // Track the loading state

  int get currentTabIndex => _currentTabIndex;

  bool get isLoading => _isLoading; // Return the loading state

  void onTabSelected(int index) {
    if (index != _currentTabIndex) {
      // Update the current tab index and notify listeners
      _currentTabIndex = index;
      notifyListeners();
    }
  }

  // Set loading state to true when fetching data, and false once data is fetched
  Future<void> fetchHomeData() async {
    _isLoading = true; // Start loading
    notifyListeners();
    // Simulate network delay
    await Future.delayed(Duration(seconds: 2));
    _isLoading = false; // End loading
    notifyListeners();
  }

  Future<void> fetchDoctorData() async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(Duration(seconds: 2));
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchMessagesData() async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(Duration(seconds: 2));
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchSettingsData() async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(Duration(seconds: 2));
    _isLoading = false;
    notifyListeners();
  }
}
