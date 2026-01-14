import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'transaction_controller.dart';
import '../../core/theme/app_colors.dart';
import '../widgets/main_nav_bar.dart';

class TransactionView extends GetView<TransactionController> {
  const TransactionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: AppBar(
        title: const Text(
          'Transactions',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.backgroundPrimary,
        elevation: 0,
        centerTitle: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_rounded,
              size: 80,
              color: AppColors.primaryBlue.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'Historique des Transactions',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'En cours de développement',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Obx(() => MainNavBar(
            currentIndex: controller.currentNavIndex.value,
            onTap: controller.onNavTap,
            transactionBadgeCount: controller.transactionBadgeCount.value,
          )),
    );
  }
}
