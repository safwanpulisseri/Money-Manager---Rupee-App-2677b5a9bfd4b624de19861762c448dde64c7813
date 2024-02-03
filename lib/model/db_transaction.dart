import 'package:hive/hive.dart';

part 'db_transaction.g.dart';

@HiveType(typeId: 1)
class TransactionModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final String categoryName;

  @HiveField(5)
  bool isIncome; // True if income, False if expense

  TransactionModel({
    required this.id,
    required this.amount,
    required this.description,
    required this.date,
    required this.categoryName,
    required this.isIncome,
  });

  // Setter for isIncome
  void setIncome(bool income) {
    isIncome = income;
  }
}
