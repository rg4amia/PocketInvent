import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/telephone_model.dart';
import '../../data/models/transaction_model.dart';
import '../../data/services/supabase_service.dart';

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
    final clients = await _supabaseService.getClients();
    final statutsPaiement = await _supabaseService.getStatutsPaiement();

    Map<String, dynamic>? selectedClient;
    Map<String, dynamic>? selectedStatut;
    final prixVenteController = TextEditingController();
    final notesController = TextEditingController();

    await Get.dialog(
      AlertDialog(
        title: Text('Vendre le téléphone'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<Map<String, dynamic>>(
                decoration: InputDecoration(labelText: 'Client'),
                items: clients.map((client) {
                  return DropdownMenuItem(
                    value: client,
                    child: Text(client['nom']),
                  );
                }).toList(),
                onChanged: (value) => selectedClient = value,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: prixVenteController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Prix de vente *',
                  suffixText: '€',
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<Map<String, dynamic>>(
                decoration: InputDecoration(labelText: 'Statut de paiement *'),
                items: statutsPaiement.map((statut) {
                  return DropdownMenuItem(
                    value: statut,
                    child: Text(statut['libelle']),
                  );
                }).toList(),
                onChanged: (value) => selectedStatut = value,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: notesController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Notes',
                  hintText: 'Informations supplémentaires...',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (prixVenteController.text.isEmpty || selectedStatut == null) {
                Get.snackbar('Erreur', 'Veuillez remplir tous les champs obligatoires');
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
                  'notes': notesController.text.isNotEmpty ? notesController.text : null,
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
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              } catch (e) {
                Get.snackbar(
                  'Erreur',
                  'Échec de l\'enregistrement: ${e.toString()}',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            },
            child: Text('Enregistrer'),
          ),
        ],
      ),
    );
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
}
