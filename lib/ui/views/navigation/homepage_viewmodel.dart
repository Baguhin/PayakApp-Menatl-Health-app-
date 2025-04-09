import 'package:stacked/stacked.dart';

class HomepageViewModel extends BaseViewModel {
  int _currentTabIndex = 0;
  bool _isLoading = false;

  // Track when each tab was last loaded to manage refresh states
  final Map<int, DateTime> _lastLoadedTimes = {};

  // Time threshold for determining when to reload data (5 minutes)
  final Duration _refreshThreshold = const Duration(minutes: 5);

  // Getters
  int get currentTabIndex => _currentTabIndex;
  bool get isLoading => _isLoading;

  // Initialize with load on app start
  HomepageViewModel() {
    fetchHomeData();
  }

  void onTabSelected(int index) {
    if (index != _currentTabIndex) {
      // Update the current tab index
      _currentTabIndex = index;
      notifyListeners();

      // Check if we need to reload data for this tab (based on threshold)
      _checkAndReloadTabData(index);
    }
  }

  // Checks if the data for this tab should be reloaded (based on last load time)
  void _checkAndReloadTabData(int tabIndex) {
    final lastLoaded = _lastLoadedTimes[tabIndex];
    final now = DateTime.now();

    if (lastLoaded == null || now.difference(lastLoaded) > _refreshThreshold) {
      // Data is stale or never loaded - reload it
      switch (tabIndex) {
        case 0:
          fetchHomeData();
          break;
        case 1:
          fetchDoctorData();
          break;
        case 2:
          fetchMessagesData();
          break;
        case 3:
          fetchSettingsData();
          break;
      }
    }
  }

  // Load data for Home tab with smart loading state
  Future<void> fetchHomeData() async {
    _setLoading(true);

    try {
      // Simulate fetching data - replace with actual API calls
      await Future.delayed(const Duration(seconds: 2));

      // Update last loaded time for this tab
      _lastLoadedTimes[0] = DateTime.now();
    } catch (e) {
      // Handle error
      print('Error fetching home data: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Load data for Therapists/Doctors tab
  Future<void> fetchDoctorData() async {
    _setLoading(true);

    try {
      // Simulate fetching data
      await Future.delayed(const Duration(seconds: 2));

      _lastLoadedTimes[1] = DateTime.now();
    } catch (e) {
      print('Error fetching doctor data: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Load data for Chat/Messages tab
  Future<void> fetchMessagesData() async {
    _setLoading(true);

    try {
      await Future.delayed(const Duration(seconds: 2));

      _lastLoadedTimes[2] = DateTime.now();
    } catch (e) {
      print('Error fetching messages data: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Load data for Progress/Assessment tab
  Future<void> fetchSettingsData() async {
    _setLoading(true);

    try {
      await Future.delayed(const Duration(seconds: 2));

      _lastLoadedTimes[3] = DateTime.now();
    } catch (e) {
      print('Error fetching progress data: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Helper method to set loading state with notifyListeners
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Force refresh the current tab
  void refreshCurrentTab() {
    switch (_currentTabIndex) {
      case 0:
        fetchHomeData();
        break;
      case 1:
        fetchDoctorData();
        break;
      case 2:
        fetchMessagesData();
        break;
      case 3:
        fetchSettingsData();
        break;
    }
  }
}
