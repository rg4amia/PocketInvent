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
      backgroundColor: AppColors.backgroundSecondary,
      appBar: AppBar(
        title: Text('PocketInvent'),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_horiz),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('Déconnexion'),
                onTap: controller.signOut,
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildSegmentedTabs(),
          Expanded(child: _buildPhoneList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.goToAddPhone,
        backgroundColor: AppColors.primaryBlue,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: TextField(
        controller: controller.searchController,
        decoration: InputDecoration(
          hintText: 'Rechercher par IMEI, marque, modèle...',
          hintStyle: TextStyle(fontSize: 15, color: AppColors.textTertiary),
          prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
          filled: true,
          fillColor: AppColors.backgroundSecondary,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
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
          height: 32,
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryBlue
                : AppColors.backgroundPrimary,
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
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
        return Center(child: CircularProgressIndicator());
      }

      if (controller.filteredTelephones.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.phone_iphone_outlined,
                size: 64,
                color: AppColors.textTertiary,
              ),
              const SizedBox(height: 16),
              Text(
                'Aucun téléphone',
                style: TextStyle(fontSize: 17, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 8),
              Text(
                'Appuyez sur + pour ajouter',
                style: TextStyle(fontSize: 15, color: AppColors.textTertiary),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.loadTelephones,
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
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
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 6,
              offset: Offset(0, 2),
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
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 64,
                        height: 64,
                        color: AppColors.backgroundSecondary,
                        child: Icon(
                          Icons.phone_iphone,
                          color: AppColors.textTertiary,
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 64,
                        height: 64,
                        color: AppColors.backgroundSecondary,
                        child: Icon(
                          Icons.phone_iphone,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    )
                  : Container(
                      width: 64,
                      height: 64,
                      color: AppColors.backgroundSecondary,
                      child: Icon(
                        Icons.phone_iphone,
                        color: AppColors.textTertiary,
                      ),
                    ),
            ),
            const SizedBox(width: 12),

            // Text Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${phone.marqueName} ${phone.modeleName}',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    phone.fournisseurName ?? 'Sans fournisseur',
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    DateFormat('dd/MM/yyyy').format(phone.dateEntree),
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Arrow Icon
            Icon(
              isRevendu ? Icons.arrow_upward : Icons.arrow_downward,
              size: 24,
              color: isRevendu
                  ? AppColors.outgoingAccent
                  : AppColors.incomingAccent,
            ),
          ],
        ),
      ),
    );
  }
}
