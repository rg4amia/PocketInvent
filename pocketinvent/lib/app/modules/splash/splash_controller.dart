import 'package:get/get.dart';
import '../../data/services/supabase_service.dart';
import '../../routes/app_pages.dart';

class SplashController extends GetxController {
  late final SupabaseService _supabaseService;
  final hasError = false.obs;
  final isRetrying = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    try {
      hasError.value = false;
      print('[SPLASH] Starting auth check...');

      // Initialize SupabaseService
      _supabaseService = Get.put(SupabaseService());
      print('[SPLASH] SupabaseService initialized');

      // Minimum splash duration for smooth UX
      await Future.delayed(const Duration(milliseconds: 1500));

      final user = _supabaseService.currentUser;
      print('[SPLASH] Current user: ${user?.id ?? "null"}');

      // Add a small delay before navigation for smooth transition
      await Future.delayed(const Duration(milliseconds: 300));

      if (user != null) {
        print('[SPLASH] Navigating to HOME');
        Get.offAllNamed(Routes.HOME);
      } else {
        print('[SPLASH] Navigating to AUTH');
        Get.offAllNamed(Routes.AUTH);
      }
    } catch (e, stackTrace) {
      print('[SPLASH] Error during auth check: $e');
      print('[SPLASH] StackTrace: $stackTrace');

      // Show error state instead of immediately navigating
      hasError.value = true;

      // Auto-retry after 3 seconds if not manually retried
      Future.delayed(const Duration(seconds: 3), () {
        if (hasError.value && !isRetrying.value) {
          retry();
        }
      });
    }
  }

  void retry() {
    if (isRetrying.value) return;

    isRetrying.value = true;
    print('[SPLASH] Retrying auth check...');

    Future.delayed(const Duration(milliseconds: 500), () {
      isRetrying.value = false;
      _checkAuth();
    });
  }
}
