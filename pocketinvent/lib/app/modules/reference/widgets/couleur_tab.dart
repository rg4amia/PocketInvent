import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../reference_controller.dart';

class CouleurTab extends GetView<ReferenceController> {
  const CouleurTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value && controller.couleurs.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.couleurs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.palette, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text('Aucune couleur',
                    style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.couleurs.length,
          itemBuilder: (context, index) {
            final couleur = controller.couleurs[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: couleur.codeCouleur != null
                    ? Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _parseColor(couleur.codeCouleur!),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                      )
                    : null,
                title: Text(couleur.libelle),
                subtitle: couleur.codeCouleur != null
                    ? Text(couleur.codeCouleur!)
                    : null,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _showEditDialog(couleur),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => controller.deleteCouleur(couleur.id),
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

  Color _parseColor(String hexColor) {
    try {
      return Color(int.parse(hexColor.replaceFirst('#', '0xFF')));
    } catch (e) {
      return Colors.grey;
    }
  }

  void _showAddDialog() {
    controller.textController.clear();
    controller.colorCodeController.clear();

    Get.dialog(
      AlertDialog(
        title: const Text('Nouvelle couleur'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller.textController,
              decoration: const InputDecoration(
                labelText: 'Nom de la couleur',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.colorCodeController,
              decoration: const InputDecoration(
                labelText: 'Code couleur (ex: #FF0000)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: controller.createCouleur,
            child: const Text('Créer'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(couleur) {
    controller.textController.text = couleur.libelle;
    controller.colorCodeController.text = couleur.codeCouleur ?? '';

    Get.dialog(
      AlertDialog(
        title: const Text('Modifier couleur'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller.textController,
              decoration: const InputDecoration(
                labelText: 'Nom de la couleur',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.colorCodeController,
              decoration: const InputDecoration(
                labelText: 'Code couleur (ex: #FF0000)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => controller.updateCouleur(couleur.id),
            child: const Text('Modifier'),
          ),
        ],
      ),
    );
  }
}
