import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'add_client_controller.dart';
import '../../core/theme/app_colors.dart';
import '../widgets/id_photo_picker.dart';

class AddClientView extends GetView<AddClientController> {
  const AddClientView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        title: Obx(() => Text(
              controller.isEditMode.value
                  ? 'Modifier le client'
                  : 'Nouveau client',
            )),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.isEditMode.value) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primaryBlue),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildInfoSection(),
              const SizedBox(height: 24),
              _buildPhotoSection(),
              const SizedBox(height: 32),
              _buildSaveButton(),
              const SizedBox(height: 24),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildInfoSection() {
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
            'Informations',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 16),

          // Nom
          _buildLabel('Nom *'),
          const SizedBox(height: 6),
          TextField(
            controller: controller.nomController,
            style: const TextStyle(fontSize: 15),
            decoration: const InputDecoration(
              hintText: 'Entrer le nom',
            ),
          ),
          const SizedBox(height: 16),

          // Téléphone
          _buildLabel('Téléphone'),
          const SizedBox(height: 6),
          TextField(
            controller: controller.telephoneController,
            keyboardType: TextInputType.phone,
            style: const TextStyle(fontSize: 15),
            decoration: const InputDecoration(
              hintText: 'Entrer le numéro',
            ),
          ),
          const SizedBox(height: 16),

          // Email
          _buildLabel('Email'),
          const SizedBox(height: 6),
          TextField(
            controller: controller.emailController,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(fontSize: 15),
            decoration: const InputDecoration(
              hintText: 'Entrer l\'email',
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
      child: IdPhotoPicker(
        selectedPhoto: controller.selectedIdPhoto,
        photoUrl: controller.idPhotoUrl,
        onPickFromGallery: controller.pickIdPhoto,
        onTakePhoto: controller.takeIdPhoto,
        onRemove: controller.removeIdPhoto,
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
        onPressed: controller.isLoading.value ? null : controller.save,
        child: controller.isLoading.value
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(controller.isEditMode.value ? 'Modifier' : 'Enregistrer'),
      ),
    );
  }
}
