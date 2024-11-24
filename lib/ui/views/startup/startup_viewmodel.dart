import 'package:stacked/stacked.dart';

class StartupViewModel extends BaseViewModel {
  // Place anything here that needs to happen before we get into the application
  Future runStartupLogic() async {
    await Future.delayed(const Duration(seconds: 3));

    // This is where you can make decisions on where your app should navigate when
    // you have custom startup logic
  }
}
