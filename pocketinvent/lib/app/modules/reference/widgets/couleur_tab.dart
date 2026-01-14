import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../reference_controller.dart';
import '../../../core/theme/app_colors.dart';

class CouleurTab extends GetView<ReferenceController> {
  const CouleurTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: Obx(() {
        if (controller.isLoading.value && controller.couleurs.isEmpty) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primaryBlue),
          );
        }

        if (controller.couleurs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.palette_outlined, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Aucune couleur',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: _showAddDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Ajouter une couleur'),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          itemCount: controller.couleurs.length,
          itemBuilder: (context, index) {
            final couleur = controller.couleurs[index];
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
                leading: couleur.codeCouleur != null
                    ? Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _parseColor(couleur.codeCouleur!),
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.border, width: 2),
                        ),
                      )
                    : null,
                title: Text(
                  couleur.libelle,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                subtitle: couleur.codeCouleur != null
                    ? Text(
                        couleur.codeCouleur!,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      )
                    : null,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.edit_outlined,
                        color: AppColors.editAccent,
                        size: 20,
                      ),
                      onPressed: () => _showEditDialog(couleur),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        color: AppColors.deleteAccent,
                        size: 20,
                      ),
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
        backgroundColor: AppColors.primaryBlue,
        child: const Icon(Icons.add, color: Colors.white),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Nouvelle couleur',
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
                labelText: 'Nom de la couleur',
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
            TextField(
              controller: controller.colorCodeController,
              style: const TextStyle(fontSize: 15),
              decoration: InputDecoration(
                labelText: 'Code couleur (ex: #FF0000)',
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
            onPressed: controller.createCouleur,
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

  void _showEditDialog(couleur) {
    controller.textController.text = couleur.libelle;
    controller.colorCodeController.text = couleur.codeCouleur ?? '';

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Modifier couleur',
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
                labelText: 'Nom de la couleur',
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
            TextField(
              controller: controller.colorCodeController,
              style: const TextStyle(fontSize: 15),
              decoration: InputDecoration(
                labelText: 'Code couleur (ex: #FF0000)',
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
            onPressed: () => controller.updateCouleur(couleur.id),
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
