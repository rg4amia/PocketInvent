import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'hub_controller.dart';
import '../../core/theme/app_colors.dart';

class HubView extends GetView<HubController> {
  const HubView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryBlue,
              AppColors.primaryBlue.withValues(alpha: 0.85),
              AppColors.primaryBlue.withValues(alpha: 0.7),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Menu Principal',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Accédez à toutes les fonctionnalités',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        SizedBox(height: 32),

                        // Section Inventaire
                        _buildSectionTitle('INVENTAIRE'),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildMenuCard(
                                icon: Icons.phone_android,
                                title: 'Téléphones',
                                subtitle: 'Voir l\'inventaire',
                                color: AppColors.primaryBlue,
                                onTap: controller.navigateToInventory,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: _buildMenuCard(
                                icon: Icons.add_circle_outline,
                                title: 'Ajouter',
                                subtitle: 'Nouveau téléphone',
                                color: Color(0xFF10B981),
                                onTap: controller.navigateToAddPhone,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 32),

                        // Section Contacts
                        _buildSectionTitle('CONTACTS'),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildMenuCard(
                                icon: Icons.business,
                                title: 'Fournisseurs',
                                subtitle: 'Gérer les fournisseurs',
                                color: Color(0xFFF59E0B),
                                onTap: controller.navigateToFournisseurs,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: _buildMenuCard(
                                icon: Icons.people,
                                title: 'Clients',
                                subtitle: 'Gérer les clients',
                                color: Color(0xFF8B5CF6),
                                onTap: controller.navigateToClients,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 32),

                        // Section Configuration
                        _buildSectionTitle('CONFIGURATION'),
                        SizedBox(height: 16),
                        _buildMenuCard(
                          icon: Icons.settings,
                          title: 'Données de référence',
                          subtitle:
                              'Marques, modèles, couleurs, capacités, statuts',
                          color: Color(0xFF6B7280),
                          onTap: controller.navigateToReferences,
                          isWide: true,
                        ),

                        SizedBox(height: 32),

                        // Bouton Déconnexion
                        _buildLogoutButton(),

                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.phone_iphone_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'GOSTOCK',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ),
                    SizedBox(height: 4),
                    Obx(() => Text(
                          controller.userName.value.isNotEmpty
                              ? 'Bonjour, ${controller.userName.value}'
                              : 'Gestion de stock',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withValues(alpha: 0.95),
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: AppColors.textSecondary,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    bool isWide = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
              maxLines: isWide ? 2 : 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return GestureDetector(
      onTap: () {
        Get.dialog(
          AlertDialog(
            title: Text('Déconnexion'),
            content: Text('Voulez-vous vraiment vous déconnecter ?'),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: Text('Annuler'),
              ),
              TextButton(
                onPressed: () {
                  Get.back();
                  controller.signOut();
                },
                child: Text(
                  'Déconnexion',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, color: Colors.red, size: 20),
            SizedBox(width: 8),
            Text(
              'Déconnexion',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
