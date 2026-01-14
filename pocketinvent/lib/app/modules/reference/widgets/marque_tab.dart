import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../reference_controller.dart';

class MarqueTab extends GetView<ReferenceController> {
  const MarqueTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value && controller.marques.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.marques.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.phone_android, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text('Aucune marque',
                    style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.marques.length,
          itemBuilder: (context, index) {
            final marque = controller.marques[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text(marque.nom),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _showEditDialog(marque),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => controller.deleteMarque(marque.id),
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
        title: const Text('Nouvelle marque'),
        content: TextField(
          controller: controller.textController,
          decoration: const InputDecoration(
            labelText: 'Nom de la marque',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: controller.createMarque,
            child: const Text('Créer'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(marque) {
    controller.textController.text = marque.nom;
    Get.dialog(
      AlertDialog(
        title: const Text('Modifier marque'),
        content: TextField(
          controller: controller.textController,
          decoration: const InputDecoration(
            labelText: 'Nom de la marque',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => controller.updateMarque(marque.id),
            child: const Text('Modifier'),
          ),
        ],
      ),
    );
  }
}
