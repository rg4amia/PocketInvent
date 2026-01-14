import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'home_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/telephone_model.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        title: Text('Inventaire'),
        actions: [
          IconButton(
            icon: Icon(Icons.more_horiz_rounded, size: 24),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (context) => Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading:
                            Icon(Icons.logout, color: AppColors.deleteAccent),
                        title: Text('Déconnexion'),
                        onTap: () {
                          Navigator.pop(context);
                          controller.signOut();
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          const SizedBox(height: 12),
          _buildSegmentedTabs(),
          const SizedBox(height: 16),
          Expanded(child: _buildPhoneList()),
        ],
      ),
      floatingActionButton: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.fabShadow,
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: controller.goToAddPhone,
          child: Icon(Icons.add, size: 24),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: controller.searchController,
        style: TextStyle(fontSize: 15),
        decoration: InputDecoration(
          hintText: 'Rechercher par IMEI, marque, modèle...',
          hintStyle: TextStyle(fontSize: 15, color: AppColors.textPlaceholder),
          prefixIcon:
              Icon(Icons.search, color: AppColors.textSecondary, size: 20),
          suffixIcon:
              Icon(Icons.tune, color: AppColors.textSecondary, size: 20),
          filled: true,
          fillColor: AppColors.inputBackground,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildSegmentedTabs() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Obx(
        () => Row(
          children: [
            _buildTabButton('Tous', 0),
            const SizedBox(width: 8),
            _buildTabButton('Entrées', 1),
            const SizedBox(width: 8),
            _buildTabButton('Sorties', 2),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String label, int index) {
    final isSelected = controller.selectedTab.value == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => controller.onTabChanged(index),
        child: Container(
          height: 36,
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryBlue
                : AppColors.backgroundPrimary,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? AppColors.primaryBlue : AppColors.border,
              width: 1,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : AppColors.primaryBlue,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneList() {
    return Obx(() {
      if (controller.isLoading.value && controller.filteredTelephones.isEmpty) {
        return Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryBlue,
          ),
        );
      }

      if (controller.filteredTelephones.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.phone_iphone_outlined,
                size: 80,
                color: AppColors.textPlaceholder,
              ),
              const SizedBox(height: 16),
              Text(
                'Aucun téléphone',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Appuyez sur + pour ajouter',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.loadTelephones,
        color: AppColors.primaryBlue,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: controller.filteredTelephones.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final phone = controller.filteredTelephones[index];
            return _buildPhoneCard(phone);
          },
        ),
      );
    });
  }

  Widget _buildPhoneCard(TelephoneModel phone) {
    final isRevendu = phone.statutPaiementLibelle == 'Revendu';

    return GestureDetector(
      onTap: () => controller.goToPhoneDetail(phone),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundPrimary,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 3,
              offset: Offset(0, 1),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: phone.photoUrl != null
                  ? CachedNetworkImage(
                      imageUrl: phone.photoUrl!,
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 72,
                        height: 72,
                        color: AppColors.cardBackground,
                        child: Icon(
                          Icons.phone_iphone_rounded,
                          color: AppColors.textPlaceholder,
                          size: 32,
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 72,
                        height: 72,
                        color: AppColors.cardBackground,
                        child: Icon(
                          Icons.phone_iphone_rounded,
                          color: AppColors.textPlaceholder,
                          size: 32,
                        ),
                      ),
                    )
                  : Container(
                      width: 72,
                      height: 72,
                      color: AppColors.cardBackground,
                      child: Icon(
                        Icons.phone_iphone_rounded,
                        color: AppColors.textPlaceholder,
                        size: 32,
                      ),
                    ),
            ),
            const SizedBox(width: 16),

            // Text Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${phone.marqueName} ${phone.modeleName}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    phone.fournisseurName ?? 'Sans fournisseur',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 12,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('dd/MM/yyyy').format(phone.dateEntree),
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Status Icon
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isRevendu
                    ? AppColors.successAccent.withOpacity(0.1)
                    : AppColors.deleteAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isRevendu ? Icons.arrow_upward : Icons.arrow_downward,
                size: 20,
                color: isRevendu
                    ? AppColors.successAccent
                    : AppColors.deleteAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
