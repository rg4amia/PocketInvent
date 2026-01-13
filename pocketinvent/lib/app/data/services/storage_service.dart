import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/telephone_model.dart';
import '../models/transaction_model.dart';

class StorageService extends GetxService {
  late Box<TelephoneModel> telephoneBox;
  late Box<TransactionModel> transactionBox;
  late Box userBox;

  Future<StorageService> init() async {
    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TelephoneModelAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(TransactionModelAdapter());
    }

    // Open boxes
    telephoneBox = await Hive.openBox<TelephoneModel>('telephones');
    transactionBox = await Hive.openBox<TransactionModel>('transactions');
    userBox = await Hive.openBox('user');

    return this;
  }

  // Telephone operations
  Future<void> saveTelephone(TelephoneModel telephone) async {
    await telephoneBox.put(telephone.id, telephone);
  }

  Future<void> saveTelephones(List<TelephoneModel> telephones) async {
    final Map<String, TelephoneModel> telephoneMap = {
      for (var tel in telephones) tel.id: tel,
    };
    await telephoneBox.putAll(telephoneMap);
  }

  List<TelephoneModel> getAllTelephones() {
    return telephoneBox.values.toList();
  }

  TelephoneModel? getTelephone(String id) {
    return telephoneBox.get(id);
  }

  Future<void> deleteTelephone(String id) async {
    await telephoneBox.delete(id);
  }

  // Transaction operations
  Future<void> saveTransaction(TransactionModel transaction) async {
    await transactionBox.put(transaction.id, transaction);
  }

  Future<void> saveTransactions(List<TransactionModel> transactions) async {
    final Map<String, TransactionModel> transactionMap = {
      for (var trans in transactions) trans.id: trans,
    };
    await transactionBox.putAll(transactionMap);
  }

  List<TransactionModel> getAllTransactions() {
    return transactionBox.values.toList();
  }

  List<TransactionModel> getTransactionsByPhone(String telephoneId) {
    return transactionBox.values
        .where((trans) => trans.telephoneId == telephoneId)
        .toList();
  }

  // User data
  Future<void> saveUserData(String key, dynamic value) async {
    await userBox.put(key, value);
  }

  dynamic getUserData(String key) {
    return userBox.get(key);
  }

  Future<void> clearUserData() async {
    await userBox.clear();
  }

  // Clear all data
  Future<void> clearAll() async {
    await telephoneBox.clear();
    await transactionBox.clear();
    await userBox.clear();
  }
}
