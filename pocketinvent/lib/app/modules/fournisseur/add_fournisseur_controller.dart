import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/models/fournisseur.dart';
import '../../data/services/fournisseur_service.dart';

class AddFournisseurController extends GetxController {
  final FournisseurService _service = Get.find<FournisseurService>();
  final ImagePicker _picker = ImagePicker();

  final isLoading = false.obs;
  final isEditMode = false.obs;
  final selectedIdPhoto = Rx<File?>(null);
  final idPhotoUrl = RxnString();

  final nomController = TextEditingController();
  final telephoneController = TextEditingController();
  final emailController = TextEditingController();

  String? _fournisseurId;

  @override
  void onInit() {
    super.onInit();

    // Check if we're in edit mode
    final args = Get.arguments;
    if (args != null && args is Fournisseur) {
      isEditMode.value = true;
      _fournisseurId = args.id;
      _loadFournisseurData(args);
    }
  }

  @override
  void onClose() {
    nomController.dispose();
    telephoneController.dispose();
    emailController.dispose();
    super.onClose();
  }

  void _loadFournisseurData(Fournisseur fournisseur) {
    nomController.text = fournisseur.nom;
    telephoneController.text = fournisseur.telephone ?? '';
    emailController.text = fournisseur.email ?? '';
    idPhotoUrl.value = fournisseur.photoIdentiteUrl;
  }

  Future<void> pickIdPhoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        selectedIdPhoto.value = File(image.path);
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de sélectionner l\'image');
    }
  }

  Future<void> takeIdPhoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        selectedIdPhoto.value = File(image.path);
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de prendre la photo');
    }
  }

  void removeIdPhoto() {
    selectedIdPhoto.value = null;
    idPhotoUrl.value = null;
  }

  Future<void> save() async {
    if (nomController.text.trim().isEmpty) {
      Get.snackbar('Erreur', 'Le nom est obligatoire');
      return;
    }

    try {
      isLoading.value = true;

      String? photoUrl = idPhotoUrl.value;
      if (selectedIdPhoto.value != null) {
        if (photoUrl != null) {
          await _service.deleteIdPhoto(photoUrl);
        }
        photoUrl = await _service.uploadIdPhoto(selectedIdPhoto.value!);
      }

      if (isEditMode.value) {
        await _service.updateFournisseur(
          id: _fournisseurId!,
          nom: nomController.text.trim(),
          telephone: telephoneController.text.trim().isEmpty
              ? null
              : telephoneController.text.trim(),
          email: emailController.text.trim().isEmpty
              ? null
              : emailController.text.trim(),
          photoIdentiteUrl: photoUrl,
        );
        Get.back(result: true);
        Get.snackbar('Succès', 'Fournisseur modifié');
      } else {
        await _service.createFournisseur(
          nom: nomController.text.trim(),
          telephone: telephoneController.text.trim().isEmpty
              ? null
              : telephoneController.text.trim(),
          email: emailController.text.trim().isEmpty
              ? null
              : emailController.text.trim(),
          photoIdentiteUrl: photoUrl,
        );
        Get.back(result: true);
        Get.snackbar('Succès', 'Fournisseur créé');
      }
    } catch (e) {
      Get.snackbar(
        'Erreur',
        isEditMode.value
            ? 'Impossible de modifier le fournisseur'
            : 'Impossible de créer le fournisseur',
      );
    } finally {
      isLoading.value = false;
    }
  }
}
