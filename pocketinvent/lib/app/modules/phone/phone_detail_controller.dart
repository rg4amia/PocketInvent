import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/telephone_model.dart';
import '../../data/models/transaction_model.dart';
import '../../data/services/supabase_service.dart';
import '../transaction/widgets/sale_blocked_dialog.dart';
import '../transaction/widgets/return_dialog.dart';

class PhoneDetailController extends GetxController {
  final SupabaseService _supabaseService = Get.find<SupabaseService>();

  late TelephoneModel telephone;
  final transactions = <TransactionModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    telephone = Get.arguments as TelephoneModel;
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    try {
      isLoading.value = true;
      transactions.value = await _supabaseService.getTransactions(telephone.id);
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de charger l\'historique: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> showSellDialog() async {
    // Check if phone can be sold (Requirements: 3.1, 3.2)
    if (!telephone.canBeSold) {
      // Show SaleBlockedDialog
      Get.dialog(
        SaleBlockedDialog(
          phone: telephone,
          onReturnRegistered: () {
            // Reload phone data and transactions after return is registered
            loadTransactions();
          },
        ),
      );
      return;
    }

    try {
      final clients = await _supabaseService.getClients();
      final statutsPaiement = await _supabaseService.getStatutsPaiement();

      Map<String, dynamic>? selectedClient;
      Map<String, dynamic>? selectedStatut;
      final prixVenteController = TextEditingController(
        text: telephone.prixVente?.toStringAsFixed(2) ?? '',
      );
      final notesController = TextEditingController();

      await Get.dialog(
        AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF10B981).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.sell,
                  color: Color(0xFF10B981),
                  size: 24,
                ),
              ),
              SizedBox(width: 12),
              Text('Vendre le téléphone'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Informations de vente',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B7280),
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 16),

                // Client dropdown
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonFormField<Map<String, dynamic>>(
                    decoration: InputDecoration(
                      labelText: 'Client (optionnel)',
                      prefixIcon: Icon(Icons.person, color: Color(0xFF6B7280)),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    dropdownColor: Colors.white,
                    items: [
                      DropdownMenuItem(
                        value: null,
                        child: Text('Aucun client',
                            style: TextStyle(color: Color(0xFF9CA3AF))),
                      ),
                      ...clients.map((client) {
                        return DropdownMenuItem(
                          value: client,
                          child: Text(client['nom']),
                        );
                      }).toList(),
                    ],
                    onChanged: (value) => selectedClient = value,
                  ),
                ),

                SizedBox(height: 16),

                // Prix de vente
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: prixVenteController,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Prix de vente *',
                      prefixIcon:
                          Icon(Icons.attach_money, color: Color(0xFF6B7280)),
                      suffixText: 'FCFA',
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),

                SizedBox(height: 16),

                // Statut de paiement
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonFormField<Map<String, dynamic>>(
                    decoration: InputDecoration(
                      labelText: 'Statut de paiement *',
                      prefixIcon: Icon(Icons.payment, color: Color(0xFF6B7280)),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    dropdownColor: Colors.white,
                    items: statutsPaiement.map((statut) {
                      return DropdownMenuItem(
                        value: statut,
                        child: Text(statut['libelle']),
                      );
                    }).toList(),
                    onChanged: (value) => selectedStatut = value,
                  ),
                ),

                SizedBox(height: 16),

                // Notes
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: notesController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Notes (optionnel)',
                      hintText: 'Informations supplémentaires...',
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(bottom: 40),
                        child: Icon(Icons.notes, color: Color(0xFF6B7280)),
                      ),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text(
                'Annuler',
                style: TextStyle(color: Color(0xFF6B7280)),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (prixVenteController.text.isEmpty ||
                    selectedStatut == null) {
                  Get.snackbar(
                    'Erreur',
                    'Veuillez remplir tous les champs obligatoires',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Color(0xFFEF4444),
                    colorText: Colors.white,
                  );
                  return;
                }

                try {
                  // Create transaction
                  await _supabaseService.createTransaction({
                    'telephone_id': telephone.id,
                    'type_transaction': 'Vente',
                    'client_id': selectedClient?['id'],
                    'montant': double.parse(prixVenteController.text),
                    'statut_paiement_id': selectedStatut!['id'],
                    'date_transaction': DateTime.now().toIso8601String(),
                    'notes': notesController.text.isNotEmpty
                        ? notesController.text
                        : null,
                  });

                  // Update telephone status to "Revendu"
                  final revenduStatut = statutsPaiement.firstWhere(
                    (s) => s['libelle'] == 'Revendu',
                    orElse: () => selectedStatut!,
                  );

                  await _supabaseService.updateTelephone(telephone.id, {
                    'prix_vente': double.parse(prixVenteController.text),
                    'statut_paiement_id': revenduStatut['id'],
                  });

                  Get.back();
                  Get.back();
                  Get.snackbar(
                    'Succès',
                    'Vente enregistrée avec succès',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Color(0xFF10B981),
                    colorText: Colors.white,
                    icon: Icon(Icons.check_circle, color: Colors.white),
                  );
                } catch (e) {
                  Get.snackbar(
                    'Erreur',
                    'Échec de l\'enregistrement: ${e.toString()}',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Color(0xFFEF4444),
                    colorText: Colors.white,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF10B981),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text('Enregistrer la vente'),
            ),
          ],
        ),
      );
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de charger les données: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Color(0xFFEF4444),
        colorText: Colors.white,
      );
    }
  }

  Future<void> deleteTelephone() async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: Text('Confirmer la suppression'),
        content: Text('Êtes-vous sûr de vouloir supprimer ce téléphone ?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _supabaseService.deleteTelephone(telephone.id);
        Get.back();
        Get.snackbar(
          'Succès',
          'Téléphone supprimé',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } catch (e) {
        Get.snackbar(
          'Erreur',
          'Échec de la suppression: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  /// Shows the return dialog for registering a return transaction.
  /// Requirements: 3.3, 3.4
  Future<void> showReturnDialog() async {
    // Check if phone is sold
    if (telephone.stockStatus != StockStatus.vendu) {
      Get.snackbar(
        'Erreur',
        'Ce téléphone n\'est pas marqué comme vendu',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    Get.dialog(
      ReturnDialog(
        phone: telephone,
        onSuccess: () {
          // Reload phone data and transactions after return is registered
          loadTransactions();
        },
      ),
    );
  }
}
