import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:rupee_app/model/db_transaction.dart';

final ValueNotifier<List<TransactionModel>> transactionModelNotifier =
    ValueNotifier<List<TransactionModel>>([]);

class TransactionModelFunctions {
  final box = Hive.box<TransactionModel>('transactionBox');

  List<TransactionModel> transactionDetailsNotifier = [];

  final box1 = Hive.box<TransactionModel>('transactionBox');

  Future<List<TransactionModel>> getTransactionsInDateRange(
      DateTime startDate, DateTime endDate) async {
    List<TransactionModel> transactions = box.values.toList();
    return transactions
        .where((transaction) =>
            transaction.date.isAfter(startDate) &&
            transaction.date.isBefore(endDate))
        .toList();
  }

  Future<void> addTransaction(
      TransactionModel money, String selectedRadio) async {
    final box1 = await Hive.openBox<TransactionModel>('transactionBox');
    // Check the selectedRadio value to determine if it's income or expense
    if (selectedRadio == 'Option 1') {
      money.isIncome = true; // Mark the transaction as income
    } else {
      money.isIncome = false; // Mark the transaction as expense
    }
    await box1.put(money.id, money);
    transactionModelNotifier.value.add(money);
    await box.put(money.id, money);

    transactionModelNotifier.value = box.values.toList();
    transactionModelNotifier.notifyListeners();
  }

  Future<void> getAllTransactions() async {
    final box1 = await Hive.openBox<TransactionModel>('transactionBox');
    transactionModelNotifier.value.clear();
    transactionModelNotifier.value.addAll(box1.values);
    transactionModelNotifier.notifyListeners();
  }

  Future<void> updateTransaction(
      String transactionId, TransactionModel updatedTransaction) async {
    final box = await Hive.openBox<TransactionModel>('transactionBox');
    await box.put(transactionId, updatedTransaction);
    transactionModelNotifier.value = box.values.toList();
    transactionModelNotifier.notifyListeners();
  }

  Future<void> deleteTransaction(String transactionId) async {
    final box = await Hive.openBox<TransactionModel>('transactionBox');
    await box.delete(transactionId);
    transactionModelNotifier.value = box.values.toList();
    transactionModelNotifier.notifyListeners();
  }
}
