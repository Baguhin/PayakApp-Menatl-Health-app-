import 'package:get_it/get_it.dart';

import '../../../../services/firestore.dart';
import 'storage_repo.dart';
import 'user_controller.dart';

final locator = GetIt.instance;

String setupServices() {
  locator.registerSingleton<FirebaseService>(FirebaseService());
  locator.registerSingleton<StorageRepo>(StorageRepo());
  locator.registerSingleton<UserController>(UserController());
  return "";
}
