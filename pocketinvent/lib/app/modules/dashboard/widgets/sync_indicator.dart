import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../data/services/sync_service.dart';

/// Widget that displays the current sync status and offline indicator
///
/// Shows:
/// - Offline mode indicator when no connection
/// - Syncing indicator when data is being synchronized
/// - Last sync time when idle
///
/// Requirements: 9.5, 9.7
class SyncIndicator extends StatelessWidget {
  const SyncIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final syncService = Get.find<SyncService>();

    return Obx(() {
      // Show offline indicator
      if (!syncService.isOnline.value) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFFF9800),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(
                Icons.cloud_off,
                size: 16,
                color: Color(0xFFFFFFFF),
              ),
              SizedBox(width: 6),
              Text(
                'Hors ligne',
                style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }

      // Show syncing indicator
      if (syncService.isSyncing.value) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF2196F3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFFFFF)),
                ),
              ),
              SizedBox(width: 6),
              Text(
                'Synchronisation...',
                style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }

      // Show last sync time
      final lastSync = syncService.lastSyncTime.value;
      final now = DateTime.now();
      final difference = now.difference(lastSync);

      String timeAgo;
      if (difference.inMinutes < 1) {
        timeAgo = 'À l\'instant';
      } else if (difference.inMinutes < 60) {
        timeAgo = 'Il y a ${difference.inMinutes} min';
      } else if (difference.inHours < 24) {
        timeAgo = 'Il y a ${difference.inHours}h';
      } else {
        timeAgo = DateFormat('dd/MM à HH:mm').format(lastSync);
      }

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF4CAF50),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_done,
              size: 16,
              color: Color(0xFFFFFFFF),
            ),
            const SizedBox(width: 6),
            Text(
              timeAgo,
              style: const TextStyle(
                color: Color(0xFFFFFFFF),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    });
  }
}
