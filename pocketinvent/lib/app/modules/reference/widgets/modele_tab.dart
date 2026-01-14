import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../reference_controller.dart';
import '../../../core/theme/app_colors.dart';

class ModeleTab extends GetView<ReferenceController> {
  const ModeleTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: Obx(() {
        if (controller.isLoading.value && controller.modeles.isEmpty) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primaryBlue),
          );
        }

        if (controller.modeles.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.smartphone_outlined,
                    size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Aucun modèle',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: _showAddDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Ajouter un modèle'),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          itemCount: controller.modeles.length,
          itemBuilder: (context, index) {
            final modele = controller.modeles[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppColors.backgroundPrimary,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border, width: 1),
              ),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                title: Text(
                  modele.nom,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                subtitle: Text(
                  modele.marqueNom ?? 'Marque inconnue',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.edit_outlined,
                        color: AppColors.editAccent,
                        size: 20,
                      ),
                      onPressed: () => _showEditDialog(modele),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        color: AppColors.deleteAccent,
                        size: 20,
                      ),
                      onPressed: () => controller.deleteModele(modele.id),
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
        backgroundColor: AppColors.primaryBlue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showAddDialog() {
    controller.textController.clear();
    controller.selectedMarqueId.value = null;

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Nouveau modèle',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            letterSpacing: -0.3,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller.textController,
              style: const TextStyle(fontSize: 15),
              decoration: InputDecoration(
                labelText: 'Nom du modèle',
                labelStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: AppColors.inputBackground,
              ),
            ),
            const SizedBox(height: 16),
            Obx(() => DropdownButtonFormField<String>(
                  value: controller.selectedMarqueId.value,
                  style: const TextStyle(fontSize: 15, color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Marque',
                    labelStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: AppColors.inputBackground,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                  ),
                  items: controller.marques.map((marque) {
                    return DropdownMenuItem(
                      value: marque.id,
                      child: Text(marque.nom),
                    );
                  }).toList(),
                  onChanged: (value) =>
                      controller.selectedMarqueId.value = value,
                )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Annuler',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: controller.createModele,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Créer'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(modele) {
    controller.textController.text = modele.nom;
    controller.selectedMarqueId.value = modele.marqueId;

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Modifier modèle',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            letterSpacing: -0.3,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller.textController,
              style: const TextStyle(fontSize: 15),
              decoration: InputDecoration(
                labelText: 'Nom du modèle',
                labelStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: AppColors.inputBackground,
              ),
            ),
            const SizedBox(height: 16),
            Obx(() => DropdownButtonFormField<String>(
                  value: controller.selectedMarqueId.value,
                  style: const TextStyle(fontSize: 15, color: Colors.black),
                  decoration: InputDecoration(
                    labelText: 'Marque',
                    labelStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: AppColors.inputBackground,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                  ),
                  items: controller.marques.map((marque) {
                    return DropdownMenuItem(
                      value: marque.id,
                      child: Text(marque.nom),
                    );
                  }).toList(),
                  onChanged: (value) =>
                      controller.selectedMarqueId.value = value,
                )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Annuler',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () => controller.updateModele(modele.id),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Modifier'),
          ),
        ],
      ),
    );
  }
}
