import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'phone_detail_controller.dart';
import '../../core/theme/app_colors.dart';

class PhoneDetailView extends GetView<PhoneDetailController> {
  const PhoneDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: AppBar(
        title: Text('Détails du téléphone'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Row(
                  children: [
                    Icon(Icons.sell, color: AppColors.successAccent),
                    const SizedBox(width: 8),
                    Text('Vendre'),
                  ],
                ),
                onTap: () => Future.delayed(
                  Duration.zero,
                  () => controller.showSellDialog(),
                ),
              ),
              PopupMenuItem(
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    const SizedBox(width: 8),
                    Text('Supprimer'),
                  ],
                ),
                onTap: () => Future.delayed(
                  Duration.zero,
                  () => controller.deleteTelephone(),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildPhotoSection(),
            _buildInfoSection(),
            _buildHistorySection(),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoSection() {
    return controller.telephone.photoUrl != null
        ? CachedNetworkImage(
            imageUrl: controller.telephone.photoUrl!,
            height: 300,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              height: 300,
              color: AppColors.backgroundSecondary,
              child: Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (context, url, error) => Container(
              height: 300,
              color: AppColors.backgroundSecondary,
              child: Icon(
                Icons.phone_iphone_rounded,
                size: 80,
                color: AppColors.textPlaceholder,
              ),
            ),
          )
        : Container(
            height: 300,
            color: AppColors.backgroundSecondary,
            child: Icon(
              Icons.phone_iphone_rounded,
              size: 80,
              color: AppColors.textPlaceholder,
            ),
          );
  }

  Widget _buildInfoSection() {
    final phone = controller.telephone;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${phone.marqueName} ${phone.modeleName}',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow('IMEI', phone.imei),
          _buildInfoRow('Couleur', phone.couleurName),
          _buildInfoRow('Capacité', phone.capaciteValue),
          _buildInfoRow(
            'Prix d\'achat',
            '${phone.prixAchat.toStringAsFixed(2)} €',
          ),
          if (phone.prixVente != null)
            _buildInfoRow(
              'Prix de vente',
              '${phone.prixVente!.toStringAsFixed(2)} €',
            ),
          _buildInfoRow('Fournisseur', phone.fournisseurName ?? 'Non spécifié'),
          _buildInfoRow('Statut', phone.statutPaiementLibelle),
          _buildInfoRow(
            'Date d\'entrée',
            DateFormat('dd/MM/yyyy à HH:mm').format(phone.dateEntree),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(fontSize: 15, color: AppColors.textSecondary),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistorySection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Historique des transactions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Obx(() {
            if (controller.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }

            if (controller.transactions.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Aucune transaction',
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: controller.transactions.length,
              separatorBuilder: (context, index) => Divider(height: 24),
              itemBuilder: (context, index) {
                final transaction = controller.transactions[index];
                return _buildTransactionItem(transaction);
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(transaction) {
    final isVente = transaction.typeTransaction == 'Vente';

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isVente
                ? AppColors.successAccent.withValues(alpha: 0.1)
                : AppColors.deleteAccent.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            isVente ? Icons.arrow_upward : Icons.arrow_downward,
            color: isVente ? AppColors.successAccent : AppColors.deleteAccent,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                transaction.typeTransaction,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              if (transaction.clientName != null)
                Text(
                  'Client: ${transaction.clientName}',
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.textSecondary,
                  ),
                ),
              if (transaction.fournisseurName != null)
                Text(
                  'Fournisseur: ${transaction.fournisseurName}',
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.textSecondary,
                  ),
                ),
              Text(
                DateFormat(
                  'dd/MM/yyyy à HH:mm',
                ).format(transaction.dateTransaction),
                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        Text(
          '${transaction.montant.toStringAsFixed(2)} €',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: isVente ? AppColors.successAccent : AppColors.deleteAccent,
          ),
        ),
      ],
    );
  }
}
