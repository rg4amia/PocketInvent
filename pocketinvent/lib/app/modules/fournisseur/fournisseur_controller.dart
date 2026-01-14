import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/fournisseur.dart';
import '../../data/services/fournisseur_service.dart';
import '../../routes/app_pages.dart';

class FournisseurController extends GetxController {
  final FournisseurService _service = Get.find<FournisseurService>();

  final fournisseurs = <Fournisseur>[].obs;
  final isLoading = false.obs;
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadFournisseurs();
  }

  List<Fournisseur> get filteredFournisseurs {
    if (searchQuery.value.isEmpty) {
      return fournisseurs;
    }
    return fournisseurs
        .where((f) =>
            f.nom.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
            (f.telephone?.contains(searchQuery.value) ?? false) ||
            (f.email?.toLowerCase().contains(searchQuery.value.toLowerCase()) ??
                false))
        .toList();
  }

  Future<void> loadFournisseurs() async {
    try {
      isLoading.value = true;
      final data = await _service.getFournisseurs();
      fournisseurs.value = data;
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de charger les fournisseurs',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> navigateToAdd() async {
    final result = await Get.toNamed(Routes.ADD_FOURNISSEUR);
    if (result == true) {
      await loadFournisseurs();
    }
  }

  Future<void> navigateToEdit(Fournisseur fournisseur) async {
    final result =
        await Get.toNamed(Routes.ADD_FOURNISSEUR, arguments: fournisseur);
    if (result == true) {
      await loadFournisseurs();
    }
  }

  Future<void> deleteFournisseur(String id) async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Confirmation'),
        content: const Text('Voulez-vous vraiment supprimer ce fournisseur ?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        isLoading.value = true;
        await _service.deleteFournisseur(id);
        Get.snackbar('Succès', 'Fournisseur supprimé');
        await loadFournisseurs();
      } catch (e) {
        Get.snackbar('Erreur', 'Impossible de supprimer le fournisseur');
      } finally {
        isLoading.value = false;
      }
    }
  }
}
