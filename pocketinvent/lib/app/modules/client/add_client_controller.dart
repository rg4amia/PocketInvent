import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/models/client.dart';
import '../../data/services/client_service.dart';

class AddClientController extends GetxController {
  final ClientService _service = Get.find<ClientService>();
  final ImagePicker _picker = ImagePicker();

  final isLoading = false.obs;
  final isEditMode = false.obs;
  final selectedIdPhoto = Rx<File?>(null);
  final idPhotoUrl = RxnString();

  final nomController = TextEditingController();
  final telephoneController = TextEditingController();
  final emailController = TextEditingController();

  String? _clientId;

  @override
  void onInit() {
    super.onInit();

    // Check if we're in edit mode
    final args = Get.arguments;
    if (args != null && args is Client) {
      isEditMode.value = true;
      _clientId = args.id;
      _loadClientData(args);
    }
  }

  @override
  void onClose() {
    nomController.dispose();
    telephoneController.dispose();
    emailController.dispose();
    super.onClose();
  }

  void _loadClientData(Client client) {
    nomController.text = client.nom;
    telephoneController.text = client.telephone ?? '';
    emailController.text = client.email ?? '';
    idPhotoUrl.value = client.photoIdentiteUrl;
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
        await _service.updateClient(
          id: _clientId!,
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
        Get.snackbar('Succès', 'Client modifié');
      } else {
        await _service.createClient(
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
        Get.snackbar('Succès', 'Client créé');
      }
    } catch (e) {
      Get.snackbar(
        'Erreur',
        isEditMode.value
            ? 'Impossible de modifier le client'
            : 'Impossible de créer le client',
      );
    } finally {
      isLoading.value = false;
    }
  }
}
