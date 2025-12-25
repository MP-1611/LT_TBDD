import 'local_storage_service.dart';

class AppStartupService {
  static String getInitialRoute() {
    final hasWeight = LocalStorageService.getWeight() > 0;
    final hasInterests =
        LocalStorageService.getInterests().isNotEmpty;

    if (!hasWeight) {
      return '/onboarding/personal';
    }

    if (!hasInterests) {
      return '/onboarding/interests';
    }

    return '/home';
  }
}
