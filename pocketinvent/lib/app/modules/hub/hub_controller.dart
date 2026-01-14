import 'package:get/get.dart';
import '../../routes/app_pages.dart';
import '../../data/services/supabase_service.dart';
import '../../data/services/notification_service.dart';

class HubController extends GetxController {
  final SupabaseService _supabaseService = Get.find<SupabaseService>();
  late final NotificationService _notificationService;

  final userName = ''.obs;
  final userEmail = ''.obs;
  final currentNavIndex = 3.obs;
  final transactionBadgeCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _notificationService = Get.find<NotificationService>();
    _loadUserInfo();
    _updateBadgeCount();
  }

  /// Update the transaction badge count
  ///
  /// Requirements: 5.6
  void _updateBadgeCount() {
    transactionBadgeCount.value = _notificationService.getNewTransactionCount();
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
        Get.offNamed(Routes.DASHBOARD);
        break;
      case 1:
        navigateToInventory();
        break;
      case 2:
        Get.offNamed(Routes.TRANSACTIONS);
        break;
      case 3:
        // Already on hub
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
