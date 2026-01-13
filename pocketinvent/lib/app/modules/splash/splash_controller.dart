import 'package:get/get.dart';
import '../../data/services/supabase_service.dart';
import '../../routes/app_pages.dart';

class SplashController extends GetxController {
  final SupabaseService _supabaseService = Get.put(SupabaseService());

  @override
  void onInit() {
    super.onInit();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(seconds: 2));

    if (_supabaseService.currentUser != null) {
      Get.offAllNamed(Routes.HOME);
    } else {
      Get.offAllNamed(Routes.AUTH);
    }
  }
}
