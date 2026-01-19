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
import '../phone/widgets/imei_camera_scanner.dart';

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

  void showScanGuide() {
    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            Icon(Icons.qr_code_scanner, color: Colors.blue),
            SizedBox(width: 8),
            Text('Comment scanner l\'IMEI'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTipWidget(
                Icons.lightbulb_outline,
                'Bon éclairage',
                'Assurez-vous d\'avoir un bon éclairage sans reflets',
              ),
              SizedBox(height: 12),
              _buildTipWidget(
                Icons.center_focus_strong,
                'Cadrage',
                'Centrez l\'IMEI dans le cadre et rapprochez-vous',
              ),
              SizedBox(height: 12),
              _buildTipWidget(
                Icons.camera_alt,
                'Stabilité',
                'Tenez le téléphone stable pour éviter le flou',
              ),
              SizedBox(height: 12),
              _buildTipWidget(
                Icons.cleaning_services,
                'Propreté',
                'Nettoyez l\'objectif et l\'étiquette IMEI',
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'L\'IMEI est un numéro à 15 chiffres généralement situé sur l\'étiquette du téléphone',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Annuler'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Get.back();
              scanImeiWithOcr();
            },
            icon: Icon(Icons.camera_alt),
            label: Text('Scanner'),
          ),
        ],
      ),
    );
  }

  Widget _buildTipWidget(IconData icon, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade700),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 2),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> scanImeiWithOcr() async {
    try {
      // Use the new live camera scanner
      Get.to(
        () => ImeiCameraScanner(
          onImeiDetected: (String imei) {
            imeiController.text = imei;
            Get.snackbar(
              'Succès',
              'IMEI détecté: $imei',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white,
              duration: Duration(seconds: 3),
            );
          },
        ),
      );
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Échec du scan: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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
      print('Impossible d\'ajouter le téléphone: ${e.toString()}');
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
