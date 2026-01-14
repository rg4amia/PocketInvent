import 'package:get/get.dart';
import 'storage_service.dart';
import '../models/transaction_model.dart';

/// Service for managing notification badges
///
/// Tracks new transactions and provides badge counts for the navigation bar.
///
/// Requirements: 5.6
class NotificationService extends GetxService {
  final StorageService _storageService = Get.find<StorageService>();

  static const String _lastViewedTransactionKey =
      'last_viewed_transaction_time';

  /// Get the count of new transactions since last view
  ///
  /// Returns the number of transactions that were created after the last time
  /// the user viewed the transactions screen.
  ///
  /// Requirements: 5.6
  int getNewTransactionCount() {
    try {
      final lastViewedTime = _getLastViewedTransactionTime();
      final allTransactions = _storageService.getAllTransactions();

      if (lastViewedTime == null) {
        // If never viewed, show count of all transactions
        return allTransactions.length;
      }

      // Count transactions created after last viewed time
      final newTransactions = allTransactions.where((transaction) {
        return transaction.dateTransaction.isAfter(lastViewedTime);
      }).toList();

      return newTransactions.length;
    } catch (e) {
      print('Error getting new transaction count: $e');
      return 0;
    }
  }

  /// Mark transactions as viewed
  ///
  /// Updates the last viewed timestamp to now, effectively clearing the badge.
  ///
  /// Requirements: 5.6
  Future<void> markTransactionsAsViewed() async {
    try {
      await _storageService.saveUserData(
        _lastViewedTransactionKey,
        DateTime.now().toIso8601String(),
      );
    } catch (e) {
      print('Error marking transactions as viewed: $e');
    }
  }

  /// Get the last time transactions were viewed
  DateTime? _getLastViewedTransactionTime() {
    try {
      final timeString = _storageService.getUserData(_lastViewedTransactionKey);
      if (timeString == null) return null;
      return DateTime.parse(timeString);
    } catch (e) {
      print('Error getting last viewed time: $e');
      return null;
    }
  }

  /// Check if there are new transactions
  ///
  /// Returns true if there are any transactions created after the last view.
  ///
  /// Requirements: 5.6
  bool hasNewTransactions() {
    return getNewTransactionCount() > 0;
  }

  /// Reset notification state (for testing or admin purposes)
  Future<void> resetNotifications() async {
    try {
      await _storageService.saveUserData(_lastViewedTransactionKey, null);
    } catch (e) {
      print('Error resetting notifications: $e');
    }
  }
}
