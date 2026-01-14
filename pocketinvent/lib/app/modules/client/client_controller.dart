import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/models/client.dart';
import '../../data/services/client_service.dart';
import '../widgets/id_photo_picker.dart';

class ClientController extends GetxController {
  final ClientService _service = Get.find<ClientService>();
  final ImagePicker _picker = ImagePicker();

  final clients = <Client>[].obs;
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
    loadClients();
  }

  @override
  void onClose() {
    nomController.dispose();
    telephoneController.dispose();
    emailController.dispose();
    super.onClose();
  }

  List<Client> get filteredClients {
    if (searchQuery.value.isEmpty) {
      return clients;
    }
    return clients
        .where((c) =>
            c.nom.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
            (c.telephone?.contains(searchQuery.value) ?? false) ||
            (c.email?.toLowerCase().contains(searchQuery.value.toLowerCase()) ??
                false))
        .toList();
  }

  Future<void> loadClients() async {
    try {
      isLoading.value = true;
      final data = await _service.getClients();
      clients.value = data;
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de charger les clients',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createClient() async {
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

      Get.back();
      Get.snackbar('Succès', 'Client créé');
      await loadClients();
      _clearForm();
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de créer le client');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateClient(String id) async {
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

      await _service.updateClient(
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
      Get.snackbar('Succès', 'Client modifié');
      await loadClients();
      _clearForm();
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de modifier le client');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteClient(String id) async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Confirmation'),
        content: const Text('Voulez-vous vraiment supprimer ce client ?'),
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
        await _service.deleteClient(id);
        Get.snackbar('Succès', 'Client supprimé');
        await loadClients();
      } catch (e) {
        Get.snackbar('Erreur', 'Impossible de supprimer le client');
      } finally {
        isLoading.value = false;
      }
    }
  }

  void showAddDialog() {
    _clearForm();
    Get.dialog(
      AlertDialog(
        title: const Text('Nouveau client'),
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
                onPressed: isLoading.value ? null : createClient,
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

  void showEditDialog(Client client) {
    nomController.text = client.nom;
    telephoneController.text = client.telephone ?? '';
    emailController.text = client.email ?? '';
    idPhotoUrl.value = client.photoIdentiteUrl;
    selectedIdPhoto.value = null;

    Get.dialog(
      AlertDialog(
        title: const Text('Modifier client'),
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
                onPressed:
                    isLoading.value ? null : () => updateClient(client.id),
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
