import 'package:get/get.dart';
import '../../data/services/supabase_service.dart';
import '../../routes/app_pages.dart';

class SplashController extends GetxController {
  late final SupabaseService _supabaseService;

  @override
  void onInit() {
    super.onInit();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    try {
      print('[SPLASH] Starting auth check...');

      // Initialize SupabaseService
      _supabaseService = Get.put(SupabaseService());
      print('[SPLASH] SupabaseService initialized');

      await Future.delayed(const Duration(milliseconds: 500));

      final user = _supabaseService.currentUser;
      print('[SPLASH] Current user: ${user?.id ?? "null"}');

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
      // Navigate to auth on error
      Get.offAllNamed(Routes.AUTH);
    }
  }
}
