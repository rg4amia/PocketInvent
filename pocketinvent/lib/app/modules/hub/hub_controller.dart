import 'package:get/get.dart';
import '../../routes/app_pages.dart';
import '../../data/services/supabase_service.dart';

class HubController extends GetxController {
  final SupabaseService _supabaseService = Get.find<SupabaseService>();

  final userName = ''.obs;
  final userEmail = ''.obs;
  final currentNavIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserInfo();
  }

  void _loadUserInfo() {
    final user = _supabaseService.currentUser;
    if (user != null) {
      userName.value = user.userMetadata?['full_name'] ?? 'Utilisateur';
      userEmail.value = user.email ?? '';
    }
  }

  void navigateToInventory() {
    Get.toNamed(Routes.HOME);
  }

  void navigateToAddPhone() {
    Get.toNamed(Routes.ADD_PHONE);
  }

  void navigateToFournisseurs() {
    Get.toNamed(Routes.FOURNISSEUR);
  }

  void navigateToClients() {
    Get.toNamed(Routes.CLIENT);
  }

  void navigateToReferences() {
    Get.toNamed(Routes.REFERENCE);
  }

  void onNavTap(int index) {
    currentNavIndex.value = index;
    switch (index) {
      case 0:
        // Already on hub
        break;
      case 1:
        navigateToInventory();
        break;
      case 2:
        navigateToAddPhone();
        break;
      case 3:
        navigateToReferences();
        break;
    }
  }

  Future<void> signOut() async {
    try {
      await _supabaseService.signOut();
      Get.offAllNamed(Routes.AUTH);
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de se déconnecter',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
