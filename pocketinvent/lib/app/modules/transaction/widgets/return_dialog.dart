import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/telephone_model.dart';
import '../../../data/models/client.dart';
import '../../../data/models/statut_paiement.dart';
import '../../../data/services/transaction_service.dart';
import '../../../data/services/client_service.dart';
import '../../../data/services/reference_service.dart';

/// Dialog for creating a return transaction for a sold phone.
///
/// This dialog allows the user to:
/// - Select the client who is returning the phone
/// - Enter the refund amount
/// - Select the payment status
/// - Add optional notes about the return
///
/// Requirements: 3.3, 3.4
class ReturnDialog extends StatefulWidget {
  final TelephoneModel phone;
  final Function()? onSuccess;

  const ReturnDialog({
    Key? key,
    required this.phone,
    this.onSuccess,
  }) : super(key: key);

  @override
  State<ReturnDialog> createState() => _ReturnDialogState();
}

class _ReturnDialogState extends State<ReturnDialog> {
  final _formKey = GlobalKey<FormState>();
  final _montantController = TextEditingController();
  final _notesController = TextEditingController();

  final _transactionService = Get.find<TransactionService>();
  final _clientService = Get.find<ClientService>();
  final _referenceService = Get.find<ReferenceService>();

  List<Client> _clients = [];
  List<StatutPaiement> _statutsPaiement = [];
  Client? _selectedClient;
  StatutPaiement? _selectedStatutPaiement;
  bool _isLoading = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _montantController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final clients = await _clientService.getClients();
      final statuts = await _referenceService.getStatutsPaiement();

      setState(() {
        _clients = clients;
        _statutsPaiement = statuts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      Get.snackbar(
        'Erreur',
        'Impossible de charger les données: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _submitReturn() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedClient == null) {
      Get.snackbar(
        'Erreur',
        'Veuillez sélectionner un client',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    if (_selectedStatutPaiement == null) {
      Get.snackbar(
        'Erreur',
        'Veuillez sélectionner un statut de paiement',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final montant = double.parse(_montantController.text);

      await _transactionService.createReturn(
        phone: widget.phone,
        client: _selectedClient!,
        montantRemboursement: montant,
        statutPaiementId: _selectedStatutPaiement!.id,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
      );

      Get.back(); // Close dialog

      Get.snackbar(
        'Succès',
        'Retour enregistré avec succès',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Call success callback if provided
      widget.onSuccess?.call();
    } catch (e) {
      setState(() => _isSubmitting = false);
      Get.snackbar(
        'Erreur',
        'Impossible d\'enregistrer le retour: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(24),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        children: [
                          const Icon(
                            Icons.keyboard_return,
                            color: Colors.orange,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Enregistrer un retour',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Get.back(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Phone info
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.phone.marqueName} ${widget.phone.modeleName}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'IMEI: ${widget.phone.imei}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                            if (widget.phone.prixVente != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                'Prix de vente: ${widget.phone.prixVente!.toStringAsFixed(2)} FCFA',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Client selection
                      const Text(
                        'Client',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<Client>(
                        initialValue: _selectedClient,
                        decoration: InputDecoration(
                          hintText: 'Sélectionner un client',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 16,
                          ),
                        ),
                        items: _clients.map((client) {
                          return DropdownMenuItem(
                            value: client,
                            child: Text(client.nom),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() => _selectedClient = value);
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Veuillez sélectionner un client';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Refund amount
                      const Text(
                        'Montant du remboursement (FCFA)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _montantController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          hintText: '0.00',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 16,
                          ),
                          suffixText: 'FCFA',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un montant';
                          }
                          final montant = double.tryParse(value);
                          if (montant == null || montant <= 0) {
                            return 'Veuillez entrer un montant valide';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Payment status
                      const Text(
                        'Statut de paiement',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<StatutPaiement>(
                        initialValue: _selectedStatutPaiement,
                        decoration: InputDecoration(
                          hintText: 'Sélectionner un statut',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 16,
                          ),
                        ),
                        items: _statutsPaiement.map((statut) {
                          return DropdownMenuItem(
                            value: statut,
                            child: Text(statut.libelle),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() => _selectedStatutPaiement = value);
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Veuillez sélectionner un statut';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Notes
                      const Text(
                        'Notes (optionnel)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _notesController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Raison du retour, état du téléphone...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.all(12),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Action buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: _isSubmitting ? null : () => Get.back(),
                            child: const Text('Annuler'),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: _isSubmitting ? null : _submitReturn,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                            child: _isSubmitting
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Text(
                                    'Enregistrer le retour',
                                    style: TextStyle(color: Colors.white),
                                  ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
