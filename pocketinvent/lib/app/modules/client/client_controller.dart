import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/client.dart';
import '../../data/services/client_service.dart';
import '../../routes/app_pages.dart';

class ClientController extends GetxController {
  final ClientService _service = Get.find<ClientService>();

  final clients = <Client>[].obs;
  final isLoading = false.obs;
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadClients();
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

  Future<void> navigateToAdd() async {
    final result = await Get.toNamed(Routes.ADD_CLIENT);
    if (result == true) {
      await loadClients();
    }
  }

  Future<void> navigateToEdit(Client client) async {
    final result = await Get.toNamed(Routes.ADD_CLIENT, arguments: client);
    if (result == true) {
      await loadClients();
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
}
