import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/services/supabase_service.dart';
import '../../data/services/ocr_service.dart';

class AddPhoneController extends GetxController {
  final SupabaseService _supabaseService = Get.find<SupabaseService>();
  final OcrService _ocrService = Get.put(OcrService());
  final ImagePicker _imagePicker = ImagePicker();

  final imeiController = TextEditingController();
  final prixAchatController = TextEditingController();

  final isLoading = false.obs;
  final isOcrProcessing = false.obs;
  final phoneImage = Rx<File?>(null);

  final marques = <Map<String, dynamic>>[].obs;
  final modeles = <Map<String, dynamic>>[].obs;
  final couleurs = <Map<String, dynamic>>[].obs;
  final capacites = <Map<String, dynamic>>[].obs;
  final fournisseurs = <Map<String, dynamic>>[].obs;
  final statutsPaiement = <Map<String, dynamic>>[].obs;

  final selectedMarque = Rx<Map<String, dynamic>?>(null);
  final selectedModele = Rx<Map<String, dynamic>?>(null);
  final selectedCouleur = Rx<Map<String, dynamic>?>(null);
  final selectedCapacite = Rx<Map<String, dynamic>?>(null);
  final selectedFournisseur = Rx<Map<String, dynamic>?>(null);
  final selectedStatutPaiement = Rx<Map<String, dynamic>?>(null);

  @override
  void onInit() {
    super.onInit();
    loadReferenceData();
  }

  Future<void> loadReferenceData() async {
    try {
      isLoading.value = true;

      final results = await Future.wait([
        _supabaseService.getMarques(),
        _supabaseService.getCouleurs(),
        _supabaseService.getCapacites(),
        _supabaseService.getFournisseurs(),
        _supabaseService.getStatutsPaiement(),
      ]);

      marques.value = results[0];
      couleurs.value = results[1];
      capacites.value = results[2];
      fournisseurs.value = results[3];
      statutsPaiement.value = results[4];
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de charger les données: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> onMarqueChanged(Map<String, dynamic>? marque) async {
    selectedMarque.value = marque;
    selectedModele.value = null;

    if (marque != null) {
      try {
        modeles.value = await _supabaseService.getModeles(marque['id']);
      } catch (e) {
        Get.snackbar('Erreur', 'Impossible de charger les modèles');
      }
    } else {
      modeles.clear();
    }
  }

  Future<void> scanImeiWithOcr() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
      );

      if (image == null) return;

      isOcrProcessing.value = true;

      final String? extractedImei = await _ocrService.extractImeiFromImage(
        image.path,
      );

      if (extractedImei != null && _ocrService.validateImei(extractedImei)) {
        imeiController.text = extractedImei;
        Get.snackbar(
          'Succès',
          'IMEI extrait: $extractedImei',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Erreur',
          'Impossible d\'extraire l\'IMEI. Veuillez saisir manuellement.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Échec du scan: ${e.toString()}');
    } finally {
      isOcrProcessing.value = false;
    }
  }

  Future<void> pickPhoneImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
        imageQuality: 80,
      );

      if (image != null) {
        phoneImage.value = File(image.path);
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de prendre la photo: ${e.toString()}');
    }
  }

  Future<void> pickPhoneImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        phoneImage.value = File(image.path);
      }
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de sélectionner la photo: ${e.toString()}',
      );
    }
  }

  Future<void> saveTelephone() async {
    if (!_validateInputs()) return;

    try {
      isLoading.value = true;

      // Check if IMEI already exists
      final existingPhone = await _supabaseService.getTelephoneByImei(
        imeiController.text.trim(),
      );
      if (existingPhone != null) {
        Get.snackbar(
          'Erreur',
          'Un téléphone avec cet IMEI existe déjà',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Upload photo if exists
      String? photoUrl;
      if (phoneImage.value != null) {
        final bytes = await phoneImage.value!.readAsBytes();
        photoUrl = await _supabaseService.uploadPhoto(
          phoneImage.value!.path,
          bytes,
        );
      }

      // Create telephone data
      final data = {
        'imei': imeiController.text.trim(),
        'marque_id': selectedMarque.value!['id'],
        'modele_id': selectedModele.value!['id'],
        'couleur_id': selectedCouleur.value!['id'],
        'capacite_id': selectedCapacite.value!['id'],
        'fournisseur_id': selectedFournisseur.value?['id'],
        'prix_achat': double.parse(prixAchatController.text),
        'statut_paiement_id': selectedStatutPaiement.value!['id'],
        'date_entree': DateTime.now().toIso8601String(),
        'photo_url': photoUrl,
      };

      await _supabaseService.createTelephone(data);

      Get.back();
      Get.snackbar(
        'Succès',
        'Téléphone ajouté avec succès',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Échec de l\'ajout: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  bool _validateInputs() {
    if (imeiController.text.trim().isEmpty) {
      Get.snackbar('Erreur', 'Veuillez entrer l\'IMEI');
      return false;
    }

    if (!_ocrService.validateImei(imeiController.text.trim())) {
      Get.snackbar('Erreur', 'L\'IMEI doit contenir exactement 15 chiffres');
      return false;
    }

    if (selectedMarque.value == null) {
      Get.snackbar('Erreur', 'Veuillez sélectionner une marque');
      return false;
    }

    if (selectedModele.value == null) {
      Get.snackbar('Erreur', 'Veuillez sélectionner un modèle');
      return false;
    }

    if (selectedCouleur.value == null) {
      Get.snackbar('Erreur', 'Veuillez sélectionner une couleur');
      return false;
    }

    if (selectedCapacite.value == null) {
      Get.snackbar('Erreur', 'Veuillez sélectionner une capacité');
      return false;
    }

    if (prixAchatController.text.trim().isEmpty) {
      Get.snackbar('Erreur', 'Veuillez entrer le prix d\'achat');
      return false;
    }

    if (selectedStatutPaiement.value == null) {
      Get.snackbar('Erreur', 'Veuillez sélectionner un statut de paiement');
      return false;
    }

    return true;
  }

  @override
  void onClose() {
    imeiController.dispose();
    prixAchatController.dispose();
    super.onClose();
  }
}
