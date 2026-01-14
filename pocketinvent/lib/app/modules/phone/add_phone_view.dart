import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'add_phone_controller.dart';
import '../../core/theme/app_colors.dart';

class AddPhoneView extends GetView<AddPhoneController> {
  const AddPhoneView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        title: Text('Ajouter un téléphone'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primaryBlue),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
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
              const SizedBox(height: 24),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildImeiSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundPrimary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'IMEI',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller.imeiController,
            keyboardType: TextInputType.number,
            maxLength: 15,
            style: TextStyle(fontSize: 15),
            decoration: InputDecoration(
              hintText: 'Entrer l\'IMEI (15 chiffres)',
              counterText: '',
            ),
          ),
          const SizedBox(height: 12),
          Obx(
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
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Icon(Icons.camera_alt_outlined, size: 20),
              label: Text('Scanner IMEI'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundPrimary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Photo du téléphone',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 12),
          Obx(
            () => controller.phoneImage.value != null
                ? Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          controller.phoneImage.value!,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: () => controller.phoneImage.value = null,
                        icon: Icon(Icons.delete_outline,
                            color: AppColors.deleteAccent, size: 20),
                        label: Text(
                          'Supprimer',
                          style: TextStyle(color: AppColors.deleteAccent),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.deleteAccent),
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: controller.pickPhoneImage,
                          icon: Icon(Icons.camera_alt_outlined, size: 20),
                          label: Text('Prendre photo'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: controller.pickPhoneImageFromGallery,
                          icon: Icon(Icons.photo_library_outlined, size: 20),
                          label: Text('Galerie'),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundPrimary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Détails',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 16),

          // Marque
          _buildLabel('Marque *'),
          const SizedBox(height: 6),
          Obx(
            () => DropdownButtonFormField<Map<String, dynamic>>(
              value: controller.selectedMarque.value,
              decoration: InputDecoration(
                hintText: 'Sélectionner une marque',
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
              items: controller.marques.map((marque) {
                return DropdownMenuItem(
                  value: marque,
                  child: Text(marque['nom'], style: TextStyle(fontSize: 15)),
                );
              }).toList(),
              onChanged: controller.onMarqueChanged,
            ),
          ),
          const SizedBox(height: 16),

          // Modèle
          _buildLabel('Modèle *'),
          const SizedBox(height: 6),
          Obx(
            () => DropdownButtonFormField<Map<String, dynamic>>(
              value: controller.selectedModele.value,
              decoration: InputDecoration(
                hintText: 'Sélectionner un modèle',
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
              items: controller.modeles.map((modele) {
                return DropdownMenuItem(
                  value: modele,
                  child: Text(modele['nom'], style: TextStyle(fontSize: 15)),
                );
              }).toList(),
              onChanged: (value) => controller.selectedModele.value = value,
            ),
          ),
          const SizedBox(height: 16),

          // Couleur
          _buildLabel('Couleur *'),
          const SizedBox(height: 6),
          Obx(
            () => DropdownButtonFormField<Map<String, dynamic>>(
              value: controller.selectedCouleur.value,
              decoration: InputDecoration(
                hintText: 'Sélectionner une couleur',
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
              items: controller.couleurs.map((couleur) {
                return DropdownMenuItem(
                  value: couleur,
                  child:
                      Text(couleur['libelle'], style: TextStyle(fontSize: 15)),
                );
              }).toList(),
              onChanged: (value) => controller.selectedCouleur.value = value,
            ),
          ),
          const SizedBox(height: 16),

          // Capacité
          _buildLabel('Capacité *'),
          const SizedBox(height: 6),
          Obx(
            () => DropdownButtonFormField<Map<String, dynamic>>(
              value: controller.selectedCapacite.value,
              decoration: InputDecoration(
                hintText: 'Sélectionner une capacité',
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
              items: controller.capacites.map((capacite) {
                return DropdownMenuItem(
                  value: capacite,
                  child:
                      Text(capacite['valeur'], style: TextStyle(fontSize: 15)),
                );
              }).toList(),
              onChanged: (value) => controller.selectedCapacite.value = value,
            ),
          ),
          const SizedBox(height: 16),

          // Prix d'achat
          _buildLabel('Prix d\'achat *'),
          const SizedBox(height: 6),
          TextField(
            controller: controller.prixAchatController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            style: TextStyle(fontSize: 15),
            decoration: InputDecoration(
              hintText: '0.00',
              suffixText: '€',
              suffixStyle: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Fournisseur
          _buildLabel('Fournisseur'),
          const SizedBox(height: 6),
          Obx(
            () => DropdownButtonFormField<Map<String, dynamic>>(
              value: controller.selectedFournisseur.value,
              decoration: InputDecoration(
                hintText: 'Sélectionner un fournisseur',
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
              items: controller.fournisseurs.map((fournisseur) {
                return DropdownMenuItem(
                  value: fournisseur,
                  child:
                      Text(fournisseur['nom'], style: TextStyle(fontSize: 15)),
                );
              }).toList(),
              onChanged: (value) =>
                  controller.selectedFournisseur.value = value,
            ),
          ),
          const SizedBox(height: 16),

          // Statut de paiement
          _buildLabel('Statut de paiement *'),
          const SizedBox(height: 6),
          Obx(
            () => DropdownButtonFormField<Map<String, dynamic>>(
              value: controller.selectedStatutPaiement.value,
              decoration: InputDecoration(
                hintText: 'Sélectionner un statut',
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
              items: controller.statutsPaiement.map((statut) {
                return DropdownMenuItem(
                  value: statut,
                  child:
                      Text(statut['libelle'], style: TextStyle(fontSize: 15)),
                );
              }).toList(),
              onChanged: (value) =>
                  controller.selectedStatutPaiement.value = value,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
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
