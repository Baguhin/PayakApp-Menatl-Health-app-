import 'package:flutter_test/flutter_test.dart';
import 'package:tangullo/app/app.locator.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('TherapistViewModel Tests -', () {
    setUp(() => registerServices());
    tearDown(() => locator.reset());
  });
}
