import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../clock/clock_providers.dart';
import '../storage/app_launch_storage.dart';

final appLaunchStorageProvider = Provider<AppLaunchStorage>((ref) {
  return AppLaunchStorage(ref.watch(sharedPreferencesProvider));
});
