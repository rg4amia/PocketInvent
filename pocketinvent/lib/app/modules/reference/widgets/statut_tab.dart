import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../reference_controller.dart';

class StatutTab extends GetView<ReferenceController> {
  const StatutTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value && controller.statuts.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.statuts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text('Aucun statut', style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.statuts.length,
          itemBuilder: (context, index) {
            final statut = controller.statuts[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text(statut.libelle),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _showEditDialog(statut),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => controller.deleteStatut(statut.id),
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
        title: const Text('Nouveau statut'),
        content: TextField(
          controller: controller.textController,
          decoration: const InputDecoration(
            labelText: 'Libellé du statut',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: controller.createStatut,
            child: const Text('Créer'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(statut) {
    controller.textController.text = statut.libelle;
    Get.dialog(
      AlertDialog(
        title: const Text('Modifier statut'),
        content: TextField(
          controller: controller.textController,
          decoration: const InputDecoration(
            labelText: 'Libellé du statut',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => controller.updateStatut(statut.id),
            child: const Text('Modifier'),
          ),
        ],
      ),
    );
  }
}
