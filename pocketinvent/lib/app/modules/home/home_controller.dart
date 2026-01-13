import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/telephone_model.dart';
import '../../data/services/supabase_service.dart';
import '../../data/services/storage_service.dart';
import '../../routes/app_pages.dart';

class HomeController extends GetxController {
  final SupabaseService _supabaseService = Get.find<SupabaseService>();
  final StorageService _storageService = Get.find<StorageService>();

  final searchController = TextEditingController();
  final selectedTab = 0.obs;
  final isLoading = false.obs;
  final telephones = <TelephoneModel>[].obs;
  final filteredTelephones = <TelephoneModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadTelephones();
    searchController.addListener(_filterTelephones);
  }

  Future<void> loadTelephones() async {
    try {
      isLoading.value = true;

      // Load from local cache first
      final cachedTelephones = _storageService.getAllTelephones();
      if (cachedTelephones.isNotEmpty) {
        telephones.value = cachedTelephones;
        _filterTelephones();
      }

      // Sync with Supabase
      final remoteTelephones = await _supabaseService.getTelephones();
      await _storageService.saveTelephones(remoteTelephones);

      telephones.value = remoteTelephones;
      _filterTelephones();
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de charger les téléphones: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _filterTelephones() {
    final query = searchController.text.toLowerCase();

    if (query.isEmpty) {
      filteredTelephones.value = _filterByTab(telephones);
    } else {
      final filtered = telephones.where((phone) {
        return phone.imei.toLowerCase().contains(query) ||
            phone.marqueName.toLowerCase().contains(query) ||
            phone.modeleName.toLowerCase().contains(query) ||
            (phone.fournisseurName?.toLowerCase().contains(query) ?? false);
      }).toList();

      filteredTelephones.value = _filterByTab(filtered);
    }
  }

  List<TelephoneModel> _filterByTab(List<TelephoneModel> phones) {
    switch (selectedTab.value) {
      case 0: // All
        return phones;
      case 1: // Incoming (Achat)
        return phones
            .where((p) => p.statutPaiementLibelle != 'Revendu')
            .toList();
      case 2: // Outgoing (Revendu)
        return phones
            .where((p) => p.statutPaiementLibelle == 'Revendu')
            .toList();
      default:
        return phones;
    }
  }

  void onTabChanged(int index) {
    selectedTab.value = index;
    _filterTelephones();
  }

  void goToAddPhone() {
    Get.toNamed(Routes.ADD_PHONE)?.then((_) => loadTelephones());
  }

  void goToPhoneDetail(TelephoneModel phone) {
    Get.toNamed(
      Routes.PHONE_DETAIL,
      arguments: phone,
    )?.then((_) => loadTelephones());
  }

  Future<void> signOut() async {
    try {
      await _supabaseService.signOut();
      await _storageService.clearAll();
      Get.offAllNamed(Routes.AUTH);
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Échec de la déconnexion: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
