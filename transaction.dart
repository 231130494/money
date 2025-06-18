import 'package:money/model/category.dart';

class Transaction {
  int? id;
  double amount;
  String? description;
  String type;
  DateTime date;
  int? categoryId;
  Category? category;

  Transaction({
    this.id,
    required this.amount,
    this.description,
    required this.type,
    required this.date,
    this.categoryId,
    this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'description': description,
      'type': type,
      'date': date.millisecondsSinceEpoch,
      'categoryId': categoryId,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      amount: map['amount'],
      description: map['description'],
      type: map['type'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      categoryId: map['categoryId'],
    );
  }
}