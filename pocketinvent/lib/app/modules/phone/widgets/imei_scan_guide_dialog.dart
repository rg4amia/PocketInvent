import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImeiScanGuideDialog extends StatelessWidget {
  final VoidCallback onScanPressed;

  const ImeiScanGuideDialog({
    Key? key,
    required this.onScanPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.qr_code_scanner, color: Theme.of(context).primaryColor),
          SizedBox(width: 8),
          Text('Comment scanner l\'IMEI'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTip(
              Icons.lightbulb_outline,
              'Bon éclairage',
              'Assurez-vous d\'avoir un bon éclairage sans reflets',
            ),
            SizedBox(height: 12),
            _buildTip(
              Icons.center_focus_strong,
              'Cadrage',
              'Centrez l\'IMEI dans le cadre et rapprochez-vous',
            ),
            SizedBox(height: 12),
            _buildTip(
              Icons.camera_alt,
              'Stabilité',
              'Tenez le téléphone stable pour éviter le flou',
            ),
            SizedBox(height: 12),
            _buildTip(
              Icons.cleaning_services,
              'Propreté',
              'Nettoyez l\'objectif et l\'étiquette IMEI',
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'L\'IMEI est un numéro à 15 chiffres généralement situé sur l\'étiquette du téléphone',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
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
        ElevatedButton.icon(
          onPressed: () {
            Get.back();
            onScanPressed();
          },
          icon: Icon(Icons.camera_alt),
          label: Text('Scanner'),
        ),
      ],
    );
  }

  Widget _buildTip(IconData icon, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade700),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 2),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
