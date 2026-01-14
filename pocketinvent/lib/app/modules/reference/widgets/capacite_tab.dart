import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../reference_controller.dart';

class CapaciteTab extends GetView<ReferenceController> {
  const CapaciteTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value && controller.capacites.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.capacites.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.storage, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text('Aucune capacité',
                    style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.capacites.length,
          itemBuilder: (context, index) {
            final capacite = controller.capacites[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text(capacite.valeur),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _showEditDialog(capacite),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => controller.deleteCapacite(capacite.id),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog() {
    controller.textController.clear();
    Get.dialog(
      AlertDialog(
        title: const Text('Nouvelle capacité'),
        content: TextField(
          controller: controller.textController,
          decoration: const InputDecoration(
            labelText: 'Capacité (ex: 128GB)',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: controller.createCapacite,
            child: const Text('Créer'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(capacite) {
    controller.textController.text = capacite.valeur;
    Get.dialog(
      AlertDialog(
        title: const Text('Modifier capacité'),
        content: TextField(
          controller: controller.textController,
          decoration: const InputDecoration(
            labelText: 'Capacité (ex: 128GB)',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => controller.updateCapacite(capacite.id),
            child: const Text('Modifier'),
          ),
        ],
      ),
    );
  }
}
