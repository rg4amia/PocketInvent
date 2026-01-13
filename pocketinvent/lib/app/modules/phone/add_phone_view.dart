import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'add_phone_controller.dart';
import '../../core/theme/app_colors.dart';

class AddPhoneView extends GetView<AddPhoneController> {
  const AddPhoneView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: AppBar(title: Text('Ajouter un téléphone')),
      body: Obx(() {
        if (controller.isLoading.value && controller.marques.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildImeiSection(),
              const SizedBox(height: 24),
              _buildPhotoSection(),
              const SizedBox(height: 24),
              _buildDetailsSection(),
              const SizedBox(height: 32),
              _buildSaveButton(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildImeiSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'IMEI',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller.imeiController,
              keyboardType: TextInputType.number,
              maxLength: 15,
              decoration: InputDecoration(
                hintText: 'Entrer l\'IMEI (15 chiffres)',
                counterText: '',
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Obx(
                    () => ElevatedButton.icon(
                      onPressed: controller.isOcrProcessing.value
                          ? null
                          : controller.scanImeiWithOcr,
                      icon: controller.isOcrProcessing.value
                          ? SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Icon(Icons.camera_alt),
                      label: Text('Scanner IMEI'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Photo du téléphone',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Obx(
              () => controller.phoneImage.value != null
                  ? Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            controller.phoneImage.value!,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton.icon(
                          onPressed: () => controller.phoneImage.value = null,
                          icon: Icon(Icons.delete, color: Colors.red),
                          label: Text(
                            'Supprimer',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: controller.pickPhoneImage,
                            icon: Icon(Icons.camera_alt),
                            label: Text('Prendre photo'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: controller.pickPhoneImageFromGallery,
                            icon: Icon(Icons.photo_library),
                            label: Text('Galerie'),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Détails',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),

            // Marque
            Obx(
              () => DropdownButtonFormField<Map<String, dynamic>>(
                value: controller.selectedMarque.value,
                decoration: InputDecoration(labelText: 'Marque *'),
                items: controller.marques.map((marque) {
                  return DropdownMenuItem(
                    value: marque,
                    child: Text(marque['nom']),
                  );
                }).toList(),
                onChanged: controller.onMarqueChanged,
              ),
            ),
            const SizedBox(height: 16),

            // Modèle
            Obx(
              () => DropdownButtonFormField<Map<String, dynamic>>(
                value: controller.selectedModele.value,
                decoration: InputDecoration(labelText: 'Modèle *'),
                items: controller.modeles.map((modele) {
                  return DropdownMenuItem(
                    value: modele,
                    child: Text(modele['nom']),
                  );
                }).toList(),
                onChanged: (value) => controller.selectedModele.value = value,
              ),
            ),
            const SizedBox(height: 16),

            // Couleur
            Obx(
              () => DropdownButtonFormField<Map<String, dynamic>>(
                value: controller.selectedCouleur.value,
                decoration: InputDecoration(labelText: 'Couleur *'),
                items: controller.couleurs.map((couleur) {
                  return DropdownMenuItem(
                    value: couleur,
                    child: Text(couleur['libelle']),
                  );
                }).toList(),
                onChanged: (value) => controller.selectedCouleur.value = value,
              ),
            ),
            const SizedBox(height: 16),

            // Capacité
            Obx(
              () => DropdownButtonFormField<Map<String, dynamic>>(
                value: controller.selectedCapacite.value,
                decoration: InputDecoration(labelText: 'Capacité *'),
                items: controller.capacites.map((capacite) {
                  return DropdownMenuItem(
                    value: capacite,
                    child: Text(capacite['valeur']),
                  );
                }).toList(),
                onChanged: (value) => controller.selectedCapacite.value = value,
              ),
            ),
            const SizedBox(height: 16),

            // Prix d'achat
            TextField(
              controller: controller.prixAchatController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Prix d\'achat *',
                suffixText: '€',
              ),
            ),
            const SizedBox(height: 16),

            // Fournisseur
            Obx(
              () => DropdownButtonFormField<Map<String, dynamic>>(
                value: controller.selectedFournisseur.value,
                decoration: InputDecoration(labelText: 'Fournisseur'),
                items: controller.fournisseurs.map((fournisseur) {
                  return DropdownMenuItem(
                    value: fournisseur,
                    child: Text(fournisseur['nom']),
                  );
                }).toList(),
                onChanged: (value) =>
                    controller.selectedFournisseur.value = value,
              ),
            ),
            const SizedBox(height: 16),

            // Statut de paiement
            Obx(
              () => DropdownButtonFormField<Map<String, dynamic>>(
                value: controller.selectedStatutPaiement.value,
                decoration: InputDecoration(labelText: 'Statut de paiement *'),
                items: controller.statutsPaiement.map((statut) {
                  return DropdownMenuItem(
                    value: statut,
                    child: Text(statut['libelle']),
                  );
                }).toList(),
                onChanged: (value) =>
                    controller.selectedStatutPaiement.value = value,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Obx(
      () => ElevatedButton(
        onPressed: controller.isLoading.value ? null : controller.saveTelephone,
        child: controller.isLoading.value
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text('Enregistrer'),
      ),
    );
  }
}
