import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/services/supabase_service.dart';
import '../../data/services/ocr_service.dart';
import '../../data/services/fournisseur_service.dart';
import '../../data/services/reference_service.dart';
import '../../data/models/marque.dart';
import '../../data/models/modele.dart';
import '../../data/models/couleur.dart';
import '../../data/models/capacite.dart';
import '../../data/models/statut_paiement.dart';
import '../../data/models/fournisseur.dart';

class AddPhoneController extends GetxController {
  final SupabaseService _supabaseService = Get.find<SupabaseService>();
  final OcrService _ocrService = Get.put(OcrService());
  final ImagePicker _imagePicker = ImagePicker();

  // Nouveaux services
  late final FournisseurService _fournisseurService;
  late final ReferenceService _referenceService;

  final imeiController = TextEditingController();
  final prixAchatController = TextEditingController();

  final isLoading = false.obs;
  final isOcrProcessing = false.obs;
  final phoneImage = Rx<File?>(null);

  final marques = <Marque>[].obs;
  final modeles = <Modele>[].obs;
  final couleurs = <Couleur>[].obs;
  final capacites = <Capacite>[].obs;
  final fournisseurs = <Fournisseur>[].obs;
  final statutsPaiement = <StatutPaiement>[].obs;

  final selectedMarque = Rx<Marque?>(null);
  final selectedModele = Rx<Modele?>(null);
  final selectedCouleur = Rx<Couleur?>(null);
  final selectedCapacite = Rx<Capacite?>(null);
  final selectedFournisseur = Rx<Fournisseur?>(null);
  final selectedStatutPaiement = Rx<StatutPaiement?>(null);

  @override
  void onInit() {
    super.onInit();
    _initServices();
    loadReferenceData();
  }

  void _initServices() {
    try {
      _fournisseurService = Get.find<FournisseurService>();
    } catch (e) {
      _fournisseurService = Get.put(FournisseurService());
    }

    try {
      _referenceService = Get.find<ReferenceService>();
    } catch (e) {
      _referenceService = Get.put(ReferenceService());
    }
  }

  Future<void> loadReferenceData() async {
    try {
      isLoading.value = true;

      final results = await Future.wait([
        _referenceService.getMarques(),
        _referenceService.getCouleurs(),
        _referenceService.getCapacites(),
        _fournisseurService.getFournisseurs(),
        _referenceService.getStatutsPaiement(),
      ]);

      marques.value = results[0] as List<Marque>;
      couleurs.value = results[1] as List<Couleur>;
      capacites.value = results[2] as List<Capacite>;
      fournisseurs.value = results[3] as List<Fournisseur>;
      statutsPaiement.value = results[4] as List<StatutPaiement>;

      print(
          '[AddPhone] Loaded: ${marques.length} marques, ${couleurs.length} couleurs, ${capacites.length} capacites, ${fournisseurs.length} fournisseurs, ${statutsPaiement.length} statuts');
    } catch (e) {
      print('[AddPhone] Error loading data: $e');
      Get.snackbar(
        'Erreur',
        'Impossible de charger les données: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> onMarqueChanged(Marque? marque) async {
    selectedMarque.value = marque;
    selectedModele.value = null;

    if (marque != null) {
      try {
        modeles.value = await _referenceService.getModeles(marqueId: marque.id);
        print(
            '[AddPhone] Loaded ${modeles.length} modeles for marque ${marque.nom}');
      } catch (e) {
        print('[AddPhone] Error loading modeles: $e');
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
        'marque_id': selectedMarque.value!.id,
        'modele_id': selectedModele.value!.id,
        'couleur_id': selectedCouleur.value!.id,
        'capacite_id': selectedCapacite.value!.id,
        'fournisseur_id': selectedFournisseur.value?.id,
        'prix_achat': double.parse(prixAchatController.text),
        'statut_paiement_id': selectedStatutPaiement.value!.id,
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
