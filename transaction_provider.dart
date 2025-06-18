import 'package:flutter/material.dart';
import 'package:money/model/transaction.dart';
import 'package:money/model/repositories.dart';

class TransactionProvider with ChangeNotifier {
  final TransactionRepository _repository = TransactionRepository();
  List<Transaction> _transactions = [];

  List<Transaction> get transactions => _transactions;
  double get totalIncome => _transactions
      .where((t) => t.type == 'income')
      .fold(0.0, (sum, item) => sum + item.amount);
  double get totalExpense => _transactions
      .where((t) => t.type == 'expense')
      .fold(0.0, (sum, item) => sum + item.amount);
  double get balance => totalIncome - totalExpense;

  TransactionProvider() {
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    _transactions = await _repository.getTransactions();
    notifyListeners();
  }

  Future<void> addTransaction(Transaction transaction) async {
    await _repository.insertTransaction(transaction);
    await fetchTransactions();
  }

  Future<void> updateTransaction(Transaction transaction) async {
    await _repository.updateTransaction(transaction);
    await fetchTransactions();
  }

  Future<void> deleteTransaction(int id) async {
    await _repository.deleteTransaction(id);
    await fetchTransactions();
  }
}