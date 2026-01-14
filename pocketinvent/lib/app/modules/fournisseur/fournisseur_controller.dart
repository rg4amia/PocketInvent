import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/models/fournisseur.dart';
import '../../data/services/fournisseur_service.dart';
import '../widgets/id_photo_picker.dart';

class FournisseurController extends GetxController {
  final FournisseurService _service = Get.find<FournisseurService>();
  final ImagePicker _picker = ImagePicker();

  final fournisseurs = <Fournisseur>[].obs;
  final isLoading = false.obs;
  final searchQuery = ''.obs;
  final selectedIdPhoto = Rx<File?>(null);
  final idPhotoUrl = RxnString();

  final nomController = TextEditingController();
  final telephoneController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadFournisseurs();
  }

  @override
  void onClose() {
    nomController.dispose();
    telephoneController.dispose();
    emailController.dispose();
    super.onClose();
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

  Future<void> createFournisseur() async {
    if (nomController.text.trim().isEmpty) {
      Get.snackbar('Erreur', 'Le nom est obligatoire');
      return;
    }

    try {
      isLoading.value = true;

      String? photoUrl;
      if (selectedIdPhoto.value != null) {
        photoUrl = await _service.uploadIdPhoto(selectedIdPhoto.value!);
      }

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

      Get.back();
      Get.snackbar('Succès', 'Fournisseur créé');
      await loadFournisseurs();
      _clearForm();
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de créer le fournisseur');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateFournisseur(String id) async {
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

      await _service.updateFournisseur(
        id: id,
        nom: nomController.text.trim(),
        telephone: telephoneController.text.trim().isEmpty
            ? null
            : telephoneController.text.trim(),
        email: emailController.text.trim().isEmpty
            ? null
            : emailController.text.trim(),
        photoIdentiteUrl: photoUrl,
      );

      Get.back();
      Get.snackbar('Succès', 'Fournisseur modifié');
      await loadFournisseurs();
      _clearForm();
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de modifier le fournisseur');
    } finally {
      isLoading.value = false;
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

  void showAddDialog() {
    _clearForm();
    Get.dialog(
      AlertDialog(
        title: const Text('Nouveau fournisseur'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomController,
                decoration: const InputDecoration(
                  labelText: 'Nom *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: telephoneController,
                decoration: const InputDecoration(
                  labelText: 'Téléphone',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              IdPhotoPicker(
                selectedPhoto: selectedIdPhoto,
                photoUrl: idPhotoUrl,
                onPickFromGallery: pickIdPhoto,
                onTakePhoto: takeIdPhoto,
                onRemove: removeIdPhoto,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Annuler'),
          ),
          Obx(() => ElevatedButton(
                onPressed: isLoading.value ? null : createFournisseur,
                child: isLoading.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Créer'),
              )),
        ],
      ),
    );
  }

  void showEditDialog(Fournisseur fournisseur) {
    nomController.text = fournisseur.nom;
    telephoneController.text = fournisseur.telephone ?? '';
    emailController.text = fournisseur.email ?? '';
    idPhotoUrl.value = fournisseur.photoIdentiteUrl;
    selectedIdPhoto.value = null;

    Get.dialog(
      AlertDialog(
        title: const Text('Modifier fournisseur'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomController,
                decoration: const InputDecoration(
                  labelText: 'Nom *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: telephoneController,
                decoration: const InputDecoration(
                  labelText: 'Téléphone',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              IdPhotoPicker(
                selectedPhoto: selectedIdPhoto,
                photoUrl: idPhotoUrl,
                onPickFromGallery: pickIdPhoto,
                onTakePhoto: takeIdPhoto,
                onRemove: removeIdPhoto,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Annuler'),
          ),
          Obx(() => ElevatedButton(
                onPressed: isLoading.value
                    ? null
                    : () => updateFournisseur(fournisseur.id),
                child: isLoading.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Modifier'),
              )),
        ],
      ),
    );
  }

  void _clearForm() {
    nomController.clear();
    telephoneController.clear();
    emailController.clear();
    selectedIdPhoto.value = null;
    idPhotoUrl.value = null;
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
}
