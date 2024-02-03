import 'package:hive/hive.dart';

part 'db_category.g.dart';

@HiveType(typeId: 2)
class CategoryModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String categories;

  @HiveField(2)
  final bool isIncome; // Add the isIncome property here

  CategoryModel({
    required this.id,
    required this.categories,
    required this.isIncome, // Add this parameter to the constructor
  });
}
