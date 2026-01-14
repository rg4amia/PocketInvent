import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/marque.dart';
import '../../data/models/modele.dart';
import '../../data/models/couleur.dart';
import '../../data/models/capacite.dart';
import '../../data/models/statut_paiement.dart';
import '../../data/services/reference_service.dart';

class ReferenceController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final ReferenceService _service = Get.find<ReferenceService>();

  late TabController tabController;

  final marques = <Marque>[].obs;
  final modeles = <Modele>[].obs;
  final couleurs = <Couleur>[].obs;
  final capacites = <Capacite>[].obs;
  final statuts = <StatutPaiement>[].obs;

  final isLoading = false.obs;
  final textController = TextEditingController();
  final colorCodeController = TextEditingController();
  final selectedMarqueId = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 5, vsync: this);
    loadAllData();
  }

  @override
  void onClose() {
    tabController.dispose();
    textController.dispose();
    colorCodeController.dispose();
    super.onClose();
  }

  Future<void> loadAllData() async {
    await Future.wait([
      loadMarques(),
      loadModeles(),
      loadCouleurs(),
      loadCapacites(),
      loadStatuts(),
    ]);
  }

  // MARQUES
  Future<void> loadMarques() async {
    try {
      isLoading.value = true;
      marques.value = await _service.getMarques();
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de charger les marques');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createMarque() async {
    if (textController.text.trim().isEmpty) {
      Get.snackbar('Erreur', 'Le nom est obligatoire');
      return;
    }

    try {
      isLoading.value = true;
      await _service.createMarque(textController.text.trim());
      Get.back();
      Get.snackbar('Succès', 'Marque créée');
      await loadMarques();
      textController.clear();
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de créer la marque');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateMarque(String id) async {
    if (textController.text.trim().isEmpty) {
      Get.snackbar('Erreur', 'Le nom est obligatoire');
      return;
    }

    try {
      isLoading.value = true;
      await _service.updateMarque(id, textController.text.trim());
      Get.back();
      Get.snackbar('Succès', 'Marque modifiée');
      await loadMarques();
      textController.clear();
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de modifier la marque');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteMarque(String id) async {
    final confirm = await _confirmDelete('cette marque');
    if (confirm == true) {
      try {
        await _service.deleteMarque(id);
        Get.snackbar('Succès', 'Marque supprimée');
        await loadMarques();
      } catch (e) {
        Get.snackbar('Erreur', 'Impossible de supprimer (modèles associés?)');
      }
    }
  }

  // MODELES
  Future<void> loadModeles() async {
    try {
      isLoading.value = true;
      modeles.value = await _service.getModeles();
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de charger les modèles');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createModele() async {
    if (textController.text.trim().isEmpty || selectedMarqueId.value == null) {
      Get.snackbar('Erreur', 'Le nom et la marque sont obligatoires');
      return;
    }

    try {
      isLoading.value = true;
      await _service.createModele(
          textController.text.trim(), selectedMarqueId.value!);
      Get.back();
      Get.snackbar('Succès', 'Modèle créé');
      await loadModeles();
      textController.clear();
      selectedMarqueId.value = null;
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de créer le modèle');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateModele(String id) async {
    if (textController.text.trim().isEmpty || selectedMarqueId.value == null) {
      Get.snackbar('Erreur', 'Le nom et la marque sont obligatoires');
      return;
    }

    try {
      isLoading.value = true;
      await _service.updateModele(
          id, textController.text.trim(), selectedMarqueId.value!);
      Get.back();
      Get.snackbar('Succès', 'Modèle modifié');
      await loadModeles();
      textController.clear();
      selectedMarqueId.value = null;
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de modifier le modèle');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteModele(String id) async {
    final confirm = await _confirmDelete('ce modèle');
    if (confirm == true) {
      try {
        await _service.deleteModele(id);
        Get.snackbar('Succès', 'Modèle supprimé');
        await loadModeles();
      } catch (e) {
        Get.snackbar(
            'Erreur', 'Impossible de supprimer (téléphones associés?)');
      }
    }
  }

  // COULEURS
  Future<void> loadCouleurs() async {
    try {
      isLoading.value = true;
      couleurs.value = await _service.getCouleurs();
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de charger les couleurs');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createCouleur() async {
    if (textController.text.trim().isEmpty) {
      Get.snackbar('Erreur', 'Le nom est obligatoire');
      return;
    }

    try {
      isLoading.value = true;
      await _service.createCouleur(
        textController.text.trim(),
        colorCodeController.text.trim().isEmpty
            ? null
            : colorCodeController.text.trim(),
      );
      Get.back();
      Get.snackbar('Succès', 'Couleur créée');
      await loadCouleurs();
      textController.clear();
      colorCodeController.clear();
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de créer la couleur');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateCouleur(String id) async {
    if (textController.text.trim().isEmpty) {
      Get.snackbar('Erreur', 'Le nom est obligatoire');
      return;
    }

    try {
      isLoading.value = true;
      await _service.updateCouleur(
        id,
        textController.text.trim(),
        colorCodeController.text.trim().isEmpty
            ? null
            : colorCodeController.text.trim(),
      );
      Get.back();
      Get.snackbar('Succès', 'Couleur modifiée');
      await loadCouleurs();
      textController.clear();
      colorCodeController.clear();
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de modifier la couleur');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteCouleur(String id) async {
    final confirm = await _confirmDelete('cette couleur');
    if (confirm == true) {
      try {
        await _service.deleteCouleur(id);
        Get.snackbar('Succès', 'Couleur supprimée');
        await loadCouleurs();
      } catch (e) {
        Get.snackbar(
            'Erreur', 'Impossible de supprimer (téléphones associés?)');
      }
    }
  }

  // CAPACITES
  Future<void> loadCapacites() async {
    try {
      isLoading.value = true;
      capacites.value = await _service.getCapacites();
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de charger les capacités');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createCapacite() async {
    if (textController.text.trim().isEmpty) {
      Get.snackbar('Erreur', 'La valeur est obligatoire');
      return;
    }

    try {
      isLoading.value = true;
      await _service.createCapacite(textController.text.trim());
      Get.back();
      Get.snackbar('Succès', 'Capacité créée');
      await loadCapacites();
      textController.clear();
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de créer la capacité');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateCapacite(String id) async {
    if (textController.text.trim().isEmpty) {
      Get.snackbar('Erreur', 'La valeur est obligatoire');
      return;
    }

    try {
      isLoading.value = true;
      await _service.updateCapacite(id, textController.text.trim());
      Get.back();
      Get.snackbar('Succès', 'Capacité modifiée');
      await loadCapacites();
      textController.clear();
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de modifier la capacité');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteCapacite(String id) async {
    final confirm = await _confirmDelete('cette capacité');
    if (confirm == true) {
      try {
        await _service.deleteCapacite(id);
        Get.snackbar('Succès', 'Capacité supprimée');
        await loadCapacites();
      } catch (e) {
        Get.snackbar(
            'Erreur', 'Impossible de supprimer (téléphones associés?)');
      }
    }
  }

  // STATUTS
  Future<void> loadStatuts() async {
    try {
      isLoading.value = true;
      statuts.value = await _service.getStatutsPaiement();
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de charger les statuts');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createStatut() async {
    if (textController.text.trim().isEmpty) {
      Get.snackbar('Erreur', 'Le libellé est obligatoire');
      return;
    }

    try {
      isLoading.value = true;
      await _service.createStatutPaiement(textController.text.trim());
      Get.back();
      Get.snackbar('Succès', 'Statut créé');
      await loadStatuts();
      textController.clear();
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de créer le statut');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateStatut(String id) async {
    if (textController.text.trim().isEmpty) {
      Get.snackbar('Erreur', 'Le libellé est obligatoire');
      return;
    }

    try {
      isLoading.value = true;
      await _service.updateStatutPaiement(id, textController.text.trim());
      Get.back();
      Get.snackbar('Succès', 'Statut modifié');
      await loadStatuts();
      textController.clear();
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de modifier le statut');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteStatut(String id) async {
    final confirm = await _confirmDelete('ce statut');
    if (confirm == true) {
      try {
        await _service.deleteStatutPaiement(id);
        Get.snackbar('Succès', 'Statut supprimé');
        await loadStatuts();
      } catch (e) {
        Get.snackbar(
            'Erreur', 'Impossible de supprimer (téléphones associés?)');
      }
    }
  }

  Future<bool?> _confirmDelete(String item) {
    return Get.dialog<bool>(
      AlertDialog(
        title: const Text('Confirmation'),
        content: Text('Voulez-vous vraiment supprimer $item ?'),
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
  }
}
