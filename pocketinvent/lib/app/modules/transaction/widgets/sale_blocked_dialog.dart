import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/telephone_model.dart';
import 'return_dialog.dart';

/// Dialog displayed when a user attempts to sell a phone that is already sold.
///
/// This dialog:
/// - Explains why the sale is blocked (phone status is "Vendu")
/// - Provides a clear error message
/// - Offers a button to register a return transaction
///
/// Requirements: 3.2
class SaleBlockedDialog extends StatelessWidget {
  final TelephoneModel phone;
  final Function()? onReturnRegistered;

  const SaleBlockedDialog({
    Key? key,
    required this.phone,
    this.onReturnRegistered,
  }) : super(key: key);

  void _showReturnDialog() {
    Get.back(); // Close this dialog first
    Get.dialog(
      ReturnDialog(
        phone: phone,
        onSuccess: onReturnRegistered,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 450),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Error icon
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.red[50],
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.block,
                color: Colors.red,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),

            // Title
            const Text(
              'Vente bloquée',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

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
                    '${phone.marqueName} ${phone.modeleName}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'IMEI: ${phone.imei}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red[100],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 16,
                          color: Colors.red[900],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Statut: Vendu',
                          style: TextStyle(
                            color: Colors.red[900],
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Explanation message
            Text(
              'Ce téléphone ne peut pas être vendu car il est déjà marqué comme vendu.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Pour pouvoir le revendre, vous devez d\'abord enregistrer un retour.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),

            // Action buttons
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _showReturnDialog,
                    icon: const Icon(Icons.keyboard_return),
                    label: const Text('Enregistrer un retour'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Get.back(),
                    child: const Text('Fermer'),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
